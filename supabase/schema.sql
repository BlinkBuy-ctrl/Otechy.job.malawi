-- ─────────────────────────────────────────────────────────────────────
-- JOB SEARCH SECTION - SUPABASE SCHEMA
-- Complete database schema for job listing, posting, and applications
-- ─────────────────────────────────────────────────────────────────────

-- ─────────────────────────────────────────────
-- 1. PROFILES (User profiles linked to Auth)
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT,
  email VARCHAR(320),
  phone VARCHAR(20),
  whatsapp VARCHAR(20),
  location TEXT,
  bio TEXT,
  role TEXT DEFAULT 'worker' CHECK (role IN ('worker', 'customer', 'both', 'admin')),
  profile_photo TEXT,
  is_online BOOLEAN DEFAULT FALSE,
  is_verified BOOLEAN DEFAULT FALSE,
  is_trusted BOOLEAN DEFAULT FALSE,
  is_boosted BOOLEAN DEFAULT FALSE,
  rating NUMERIC DEFAULT 0,
  jobs_completed INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Profile policies
CREATE POLICY "Profiles are viewable by everyone" ON public.profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can update their own profile" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their own profile" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- ─────────────────────────────────────────────
-- 2. JOBS TABLE
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  poster_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  location TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'One-time Task'
    CHECK (type IN ('Full-time', 'Part-time', 'Contract', 'Freelance', 'One-time Task')),
  budget NUMERIC(12, 2),
  skills TEXT[] DEFAULT '{}',
  is_urgent BOOLEAN DEFAULT FALSE,
  application_count INT DEFAULT 0,
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'closed', 'deleted')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on jobs
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;

-- Jobs policies
CREATE POLICY "Open jobs are viewable by everyone" ON public.jobs
  FOR SELECT USING (status = 'open');

CREATE POLICY "Users can insert jobs" ON public.jobs
  FOR INSERT WITH CHECK (auth.uid() = poster_id);

CREATE POLICY "Job posters can update their own jobs" ON public.jobs
  FOR UPDATE USING (auth.uid() = poster_id);

CREATE POLICY "Job posters can delete their own jobs" ON public.jobs
  FOR DELETE USING (auth.uid() = poster_id);

-- ─────────────────────────────────────────────
-- 3. APPLICATIONS TABLE
-- ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES public.jobs(id) ON DELETE CASCADE,
  applicant_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  cover_letter TEXT,
  proposed_rate NUMERIC(12, 2),
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(job_id, applicant_id)
);

-- Enable RLS on applications
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;

-- Applications policies
CREATE POLICY "Applicants can view their own applications" ON public.applications
  FOR SELECT USING (auth.uid() = applicant_id);

CREATE POLICY "Job posters can view applications on their jobs" ON public.applications
  FOR SELECT USING (EXISTS (
    SELECT 1 FROM public.jobs WHERE jobs.id = applications.job_id AND jobs.poster_id = auth.uid()
  ));

CREATE POLICY "Users can insert applications" ON public.applications
  FOR INSERT WITH CHECK (auth.uid() = applicant_id);

CREATE POLICY "Applicants can update their own applications" ON public.applications
  FOR UPDATE USING (auth.uid() = applicant_id);

-- ─────────────────────────────────────────────
-- 4. HELPER FUNCTIONS
-- ─────────────────────────────────────────────

-- Function to sync application count
CREATE OR REPLACE FUNCTION public.sync_application_count()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  UPDATE public.jobs SET
    application_count = (SELECT COUNT(*) FROM public.applications WHERE job_id = COALESCE(NEW.job_id, OLD.job_id))
  WHERE id = COALESCE(NEW.job_id, OLD.job_id);
  RETURN COALESCE(NEW, OLD);
END;
$$;

-- Trigger to sync application count on insert/delete
DROP TRIGGER IF EXISTS trg_application_count ON public.applications;
CREATE TRIGGER trg_application_count
  AFTER INSERT OR DELETE ON public.applications
  FOR EACH ROW EXECUTE PROCEDURE public.sync_application_count();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Trigger to update jobs.updated_at
DROP TRIGGER IF EXISTS trg_jobs_updated_at ON public.jobs;
CREATE TRIGGER trg_jobs_updated_at
  BEFORE UPDATE ON public.jobs
  FOR EACH ROW EXECUTE PROCEDURE public.set_updated_at();

-- ─────────────────────────────────────────────
-- 5. INDEXES FOR PERFORMANCE
-- ─────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_jobs_poster_id ON public.jobs(poster_id);
CREATE INDEX IF NOT EXISTS idx_jobs_status ON public.jobs(status);
CREATE INDEX IF NOT EXISTS idx_jobs_created_at ON public.jobs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_jobs_location ON public.jobs(location);
CREATE INDEX IF NOT EXISTS idx_applications_job_id ON public.applications(job_id);
CREATE INDEX IF NOT EXISTS idx_applications_applicant_id ON public.applications(applicant_id);
CREATE INDEX IF NOT EXISTS idx_profiles_id ON public.profiles(id);

-- ─────────────────────────────────────────────
-- 6. STORAGE BUCKET (for profile photos)
-- ─────────────────────────────────────────────
INSERT INTO storage.buckets (id, name, public) VALUES ('profile-photos', 'profile-photos', true)
  ON CONFLICT (id) DO NOTHING;

-- Storage policy for profile photos
CREATE POLICY "Profile photos are publicly accessible" ON storage.objects
  FOR SELECT USING (bucket_id = 'profile-photos');

CREATE POLICY "Users can upload their own profile photo" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'profile-photos' AND
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- ─────────────────────────────────────────────
-- 7. SAMPLE DATA (Optional - for testing)
-- ─────────────────────────────────────────────
-- Uncomment below to add sample data

-- INSERT INTO public.profiles (id, name, email, location, role)
-- VALUES (
--   '00000000-0000-0000-0000-000000000001'::uuid,
--   'John Doe',
--   'john@example.com',
--   'Lilongwe',
--   'customer'
-- );

-- INSERT INTO public.jobs (poster_id, title, description, location, type, budget, is_urgent)
-- VALUES (
--   '00000000-0000-0000-0000-000000000001'::uuid,
--   'Need a plumber urgently',
--   'Burst pipe in my house needs fixing today',
--   'Lilongwe',
--   'One-time Task',
--   50000,
--   true
-- );

