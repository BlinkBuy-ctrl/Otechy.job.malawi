# Job Search Section - Standalone Repository

A production-ready job search and posting module extracted from BlinkBuy. This is a complete, self-contained React + TypeScript + Supabase application for browsing, searching, and posting jobs.

## Features

- **Job Listing & Search**: Browse all active jobs with real-time search, location, and job-type filtering
- **Job Details**: View full job information with applicant count and required skills
- **Job Posting**: Post new jobs with title, description, location, budget, and urgency flag
- **Job Applications**: Workers can apply with cover letter and proposed rate
- **Pagination**: Efficient pagination for large job listings
- **Responsive Design**: Mobile-first design with Tailwind CSS
- **Dark/Light Theme**: Built-in theme support with next-themes

## Tech Stack

- **Frontend**: React 19, TypeScript, Vite
- **Styling**: Tailwind CSS 4, shadcn/ui components
- **Routing**: Wouter (lightweight router)
- **State Management**: React Query (TanStack Query)
- **Backend**: Supabase (PostgreSQL + Auth)
- **Icons**: Lucide React

## Project Structure

```
src/
├── pages/
│   ├── jobs.tsx              # Job listing & search page
│   ├── job-detail.tsx        # Job detail & application page
│   └── post-job.tsx          # Job posting form
├── components/
│   ├── Layout.tsx            # App shell & navigation
│   ├── ui/                   # shadcn/ui components
│   └── ...
├── hooks/
│   └── useAuth.ts            # Authentication hook
├── lib/
│   ├── api.ts                # Supabase API wrapper
│   ├── supabase.ts           # Supabase client
│   └── auth.ts               # Auth utilities
├── App.tsx                   # Main app component
└── main.tsx                  # Entry point
```

## Setup Instructions

### 1. Clone & Install

```bash
git clone <this-repo>
cd job-search-section
npm install
# or
pnpm install
```

### 2. Configure Supabase

Create a `.env.local` file in the project root:

```env
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

Get these values from your Supabase dashboard: **Settings → API → Project URL & anon key**

### 3. Set Up Database Schema

Copy the SQL schema from `supabase/schema.sql` and run it in your Supabase SQL editor:

```bash
# In Supabase dashboard → SQL Editor → New Query
# Paste the contents of supabase/schema.sql and execute
```

This creates:
- `profiles` table (user profiles linked to Supabase Auth)
- `jobs` table (job listings)
- `applications` table (job applications)
- Triggers for automatic application count sync

### 4. Run Development Server

```bash
npm run dev
# or
pnpm dev
```

The app will be available at `http://localhost:5173`

## Usage

### Browsing Jobs

1. Navigate to `/jobs`
2. Use the search bar to find jobs by keyword
3. Filter by location and job type
4. Click a job card to view details

### Posting a Job

1. Click **"+ Post a Job"** button (requires login)
2. Fill in job details: title, description, location, budget, etc.
3. Mark as urgent if needed (2x visibility boost)
4. Click **"Post Job"** to publish

### Applying for a Job

1. View a job detail page
2. Click **"Apply Now"** (requires login as a worker)
3. Write a cover letter and optionally propose a rate
4. Submit your application

## Database Schema

### jobs table
```sql
CREATE TABLE jobs (
  id UUID PRIMARY KEY,
  poster_id UUID NOT NULL (references profiles),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  location TEXT NOT NULL,
  type TEXT (Full-time, Part-time, Contract, Freelance, One-time Task),
  budget NUMERIC,
  skills TEXT[] (array of skill tags),
  is_urgent BOOLEAN,
  application_count INT (auto-synced),
  status TEXT (open, closed, deleted),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### applications table
```sql
CREATE TABLE applications (
  id UUID PRIMARY KEY,
  job_id UUID NOT NULL (references jobs),
  applicant_id UUID NOT NULL (references profiles),
  cover_letter TEXT,
  proposed_rate NUMERIC,
  status TEXT (pending, accepted, rejected),
  created_at TIMESTAMP,
  UNIQUE(job_id, applicant_id)
);
```

## API Endpoints (via Supabase)

### GET /jobs
List all open jobs with optional filters
- Query params: `search`, `location`, `type`, `page`, `limit`
- Returns: `{ jobs: Job[], total: number }`

### GET /jobs/:id
Get a single job with applications
- Returns: Job object with nested applications

### POST /jobs
Create a new job (requires auth)
- Body: `{ title, description, location, type, budget, skills, is_urgent }`

### POST /jobs/:id/apply
Apply for a job (requires auth)
- Body: `{ cover_letter, proposed_rate }`

## Authentication

The app uses Supabase Auth with the following features:
- Email/password signup and login
- Google OAuth integration
- Session persistence
- Profile management

Users are automatically assigned a `role` (worker, customer, or both) during signup.

## Customization

### Colors & Theming

Edit `src/index.css` to customize the color palette:
- Primary color (accent)
- Background/foreground colors
- Border colors
- Semantic colors (success, destructive, etc.)

### UI Components

All UI components are from shadcn/ui and can be customized in `src/components/ui/`.

### Locations & Job Types

Edit the constants in `src/pages/jobs.tsx` and `src/pages/post-job.tsx`:
```typescript
const CITIES = ["Lilongwe", "Blantyre", ...];
const JOB_TYPES = ["Full-time", "Part-time", ...];
```

## Performance Optimizations

- **Caching**: Browser localStorage cache with TTL
- **Pagination**: Server-side pagination (10 items per page)
- **Lazy Loading**: Skeleton loaders during data fetch
- **Query Deduplication**: React Query handles request deduplication

## Deployment

### Vercel (Recommended)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

### Docker

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY . .
RUN npm install && npm run build
EXPOSE 3000
CMD ["npm", "run", "serve"]
```

### Other Platforms

The app is a static SPA (Single Page Application) and can be deployed to any static hosting:
- Netlify
- GitHub Pages
- AWS S3 + CloudFront
- Firebase Hosting

Build the app:
```bash
npm run build
```

The output will be in `dist/` directory.

## Troubleshooting

### "Not authenticated" error
- Ensure you're logged in before posting jobs or applying
- Check that your Supabase Auth is configured correctly

### Jobs not loading
- Verify `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` are correct
- Check browser console for network errors
- Ensure database schema is created in Supabase

### Timeout errors
- Check your internet connection
- Verify Supabase project is active
- Try again after a few seconds

## License

MIT

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Supabase documentation: https://supabase.com/docs
3. Check React Query docs: https://tanstack.com/query/latest

---

**Built with ❤️ using React, TypeScript, and Supabase**
