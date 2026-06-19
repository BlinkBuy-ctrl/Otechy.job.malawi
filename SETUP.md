# Job Search Section - Complete Setup Guide

This guide will walk you through setting up the job search section from scratch.

## Prerequisites

- Node.js 18+ installed
- npm or pnpm package manager
- A Supabase account (free at https://supabase.com)

## Step 1: Create a Supabase Project

1. Go to https://supabase.com and sign up or log in
2. Click **"New Project"**
3. Fill in the project details:
   - **Name**: e.g., "Job Search"
   - **Database Password**: Create a strong password
   - **Region**: Choose your region
4. Click **"Create new project"** and wait for it to initialize (2-3 minutes)

## Step 2: Get Your Supabase Credentials

1. Once your project is created, go to **Settings → API**
2. Copy the following values:
   - **Project URL** (looks like `https://xxxxx.supabase.co`)
   - **anon public** key (under "Project API keys")
3. Keep these safe — you'll need them in the next step

## Step 3: Set Up the Database Schema

1. In your Supabase project, go to **SQL Editor**
2. Click **"New Query"**
3. Open the file `supabase/schema.sql` from this repository
4. Copy the entire contents and paste it into the SQL editor
5. Click **"Run"** to execute all the SQL commands
6. Wait for the schema to be created (should complete in a few seconds)

**What was created:**
- `profiles` table (user profiles)
- `jobs` table (job listings)
- `applications` table (job applications)
- Automatic triggers and indexes for performance

## Step 4: Clone and Install Dependencies

```bash
# Clone the repository (or download the zip)
git clone <repository-url>
cd job-search-section

# Install dependencies
npm install
# or if you use pnpm
pnpm install
```

## Step 5: Configure Environment Variables

1. Create a file named `.env.local` in the project root
2. Add your Supabase credentials:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

Replace `your-project-id` and `your-anon-key-here` with the values from Step 2.

**Example:**
```env
VITE_SUPABASE_URL=https://abcdefghijklmnop.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Step 6: Run the Development Server

```bash
npm run dev
# or
pnpm dev
```

The app will start at `http://localhost:5173`

## Step 7: Test the Application

### Create a Test Account

1. Open the app in your browser
2. Click **"Sign Up"** or **"Register"**
3. Create an account with:
   - Email: `test@example.com`
   - Password: any password
   - Name: `Test User`
   - Role: Choose "Customer" (to post jobs) or "Worker" (to apply)

### Post a Test Job

1. Log in with your test account
2. Click **"+ Post a Job"**
3. Fill in the form:
   - **Title**: "Test Job - Plumbing Repair"
   - **Description**: "Need a plumber to fix a burst pipe"
   - **Location**: Select your location
   - **Type**: "One-time Task"
   - **Budget**: 50000
4. Click **"Post Job"**

### Browse Jobs

1. Click **"Find Work"** or navigate to `/jobs`
2. You should see your test job in the list
3. Click on it to view the details
4. If logged in as a worker, click **"Apply Now"** to test the application flow

## Troubleshooting

### "Not authenticated" Error

**Problem**: Getting "Not authenticated" when trying to post a job or apply

**Solution**:
- Make sure you're logged in
- Check that your Supabase Auth is enabled (it should be by default)
- Try logging out and logging back in

### "Jobs not loading" or Empty List

**Problem**: The jobs page shows "No jobs found" even though you posted one

**Solution**:
1. Check that the database schema was created successfully:
   - Go to Supabase → SQL Editor
   - Run: `SELECT * FROM public.jobs;`
   - You should see your posted job
2. Verify your `.env.local` credentials are correct
3. Check the browser console for errors (F12 → Console tab)
4. Make sure the job status is "open" (not "closed" or "deleted")

### Timeout Errors

**Problem**: Getting "Request timed out" errors

**Solution**:
- Check your internet connection
- Verify your Supabase project is active (check Supabase dashboard)
- Try again after a few seconds
- If the problem persists, check Supabase status page

### CORS Errors

**Problem**: Getting CORS errors in the browser console

**Solution**:
- This usually means Supabase is blocking the request
- Go to Supabase → Settings → API → CORS
- Add your development URL: `http://localhost:5173`
- For production, add your production domain

## Project Structure

```
job-search-section/
├── src/
│   ├── pages/
│   │   ├── jobs.tsx              # Job listing page
│   │   ├── job-detail.tsx        # Job detail & apply page
│   │   └── post-job.tsx          # Job posting form
│   ├── components/
│   │   ├── Layout.tsx            # App shell
│   │   └── ui/                   # UI components
│   ├── hooks/
│   │   └── useAuth.ts            # Auth hook
│   ├── lib/
│   │   ├── api.ts                # API wrapper
│   │   ├── supabase.ts           # Supabase client
│   │   └── auth.ts               # Auth utilities
│   ├── App.tsx                   # Main app
│   └── main.tsx                  # Entry point
├── supabase/
│   └── schema.sql                # Database schema
├── public/                        # Static assets
├── index.html                     # HTML template
├── package.json                   # Dependencies
├── tsconfig.json                  # TypeScript config
├── vite.config.ts                # Vite config
├── .env.local                     # Environment (create this)
└── README.md                      # Project readme
```

## Available Scripts

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run serve

# Type check
npm run typecheck
```

## Deployment

### Deploy to Vercel (Recommended)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

### Deploy to Netlify

```bash
# Install Netlify CLI
npm i -g netlify-cli

# Deploy
netlify deploy --prod --dir=dist
```

### Deploy to GitHub Pages

1. Build the project: `npm run build`
2. Push the `dist/` folder to your GitHub Pages branch
3. Enable GitHub Pages in your repository settings

## Next Steps

1. **Customize Locations**: Edit the `CITIES` array in `src/pages/jobs.tsx` and `src/pages/post-job.tsx`
2. **Customize Job Types**: Edit the `JOB_TYPES` array in the same files
3. **Add More Fields**: Extend the `jobs` table in Supabase and update the form
4. **Style the App**: Modify `src/index.css` to customize colors and fonts
5. **Add Features**: Implement job favorites, saved searches, notifications, etc.

## Support & Resources

- **Supabase Docs**: https://supabase.com/docs
- **React Documentation**: https://react.dev
- **Tailwind CSS**: https://tailwindcss.com
- **TypeScript**: https://www.typescriptlang.org

## License

MIT

---

**Need help?** Check the README.md for more information or review the troubleshooting section above.
