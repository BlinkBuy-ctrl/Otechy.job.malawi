# Quick Start - 5 Minutes

Get the job search section running in 5 minutes.

## 1. Supabase Setup (2 min)

1. Go to https://supabase.com → Sign up → Create a new project
2. Go to **Settings → API** and copy:
   - Project URL
   - anon key
3. Go to **SQL Editor** → **New Query**
4. Copy all SQL from `supabase/schema.sql` and run it

## 2. Install & Configure (2 min)

```bash
npm install
```

Create `.env.local`:
```
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

## 3. Run (1 min)

```bash
npm run dev
```

Open http://localhost:5173

## Done! 🎉

- Sign up with an email
- Post a job or browse existing jobs
- Apply for jobs

For detailed setup, see [SETUP.md](./SETUP.md)
