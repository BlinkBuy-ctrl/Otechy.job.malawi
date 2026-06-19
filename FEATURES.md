# Job Search Section - Features Overview

## Core Features

### 1. Job Listing & Search
- **Browse all active jobs** with real-time search functionality
- **Filter by location** - Select from 28 Malawian cities
- **Filter by job type** - Full-time, Part-time, Contract, Freelance, One-time Task
- **Pagination** - Browse through large job listings efficiently
- **Responsive design** - Works on mobile, tablet, and desktop

### 2. Job Details
- **Complete job information** including:
  - Job title and description
  - Location and job type
  - Budget (if specified)
  - Required skills
  - Urgency flag (2x visibility boost)
  - Application count
  - Posted time (relative, e.g., "2 days ago")
- **Posted by section** - View poster information and verification status
- **Application section** - Apply directly from the job detail page

### 3. Job Posting
- **Comprehensive job form** with fields for:
  - Job title (required)
  - Detailed description (required)
  - Required skills (comma-separated tags)
  - Location selection (required)
  - Job type selection
  - Budget (optional)
  - Urgent flag toggle
- **Form validation** - Real-time feedback on required fields
- **Error handling** - User-friendly error messages
- **Loading states** - Visual feedback during submission

### 4. Job Applications
- **Apply for jobs** with:
  - Cover letter (required)
  - Proposed rate (optional)
- **Application tracking** - See your applications and their status
- **Unique constraint** - Prevent duplicate applications for the same job
- **Automatic application count** - Jobs show real-time application count

### 5. User Authentication
- **Email/password signup and login**
- **Google OAuth integration** (optional)
- **Session persistence** - Stay logged in across sessions
- **Role-based access** - Worker, Customer, or Both roles
- **Profile management** - Edit your profile information

### 6. Performance Optimizations
- **Browser caching** - Reduce API calls with intelligent caching
- **Pagination** - Load 10 jobs per page
- **Lazy loading** - Skeleton loaders during data fetch
- **Query deduplication** - React Query handles request deduplication
- **Indexed database** - Fast queries on large datasets

### 7. Responsive Design
- **Mobile-first** - Optimized for all screen sizes
- **Touch-friendly** - Large tap targets for mobile users
- **Adaptive layout** - Adjusts to different screen widths
- **Dark/Light theme** - Built-in theme support

## Technical Features

### Database
- **PostgreSQL** via Supabase
- **Row-level security (RLS)** - Secure data access
- **Automatic triggers** - Application count syncing
- **Indexes** - Optimized query performance

### Frontend
- **React 19** - Latest React features
- **TypeScript** - Type-safe code
- **Vite** - Fast build tool
- **Tailwind CSS** - Utility-first styling
- **shadcn/ui** - Pre-built components
- **Wouter** - Lightweight routing
- **React Query** - Server state management

### API
- **Supabase REST API** - Real-time database access
- **Timeout handling** - 7-second request timeout
- **Error handling** - User-friendly error messages
- **Abort signals** - Cancel in-flight requests

## Data Model

### Jobs Table
```
- id (UUID, primary key)
- poster_id (UUID, references profiles)
- title (text, required)
- description (text, required)
- location (text, required)
- type (text, enum)
- budget (numeric, optional)
- skills (text array)
- is_urgent (boolean)
- application_count (int, auto-synced)
- status (text, enum: open/closed/deleted)
- created_at (timestamp)
- updated_at (timestamp)
```

### Applications Table
```
- id (UUID, primary key)
- job_id (UUID, references jobs)
- applicant_id (UUID, references profiles)
- cover_letter (text)
- proposed_rate (numeric, optional)
- status (text, enum: pending/accepted/rejected)
- created_at (timestamp)
- unique constraint: (job_id, applicant_id)
```

### Profiles Table
```
- id (UUID, primary key, references auth.users)
- name (text)
- email (varchar)
- phone (varchar)
- location (text)
- role (text, enum: worker/customer/both/admin)
- is_verified (boolean)
- rating (numeric)
- jobs_completed (int)
- created_at (timestamp)
- updated_at (timestamp)
```

## API Endpoints

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

## Security Features

- **Row-level security (RLS)** - Database-level access control
- **Authentication required** - For posting jobs and applying
- **Session persistence** - Secure cookie-based sessions
- **CORS protection** - Supabase handles CORS
- **Input validation** - Form validation on client and server
- **Timeout protection** - 7-second request timeout

## Customization Options

### Locations
Edit `CITIES` array in `src/pages/jobs.tsx` and `src/pages/post-job.tsx`

### Job Types
Edit `JOB_TYPES` array in the same files

### Colors & Theme
Edit CSS variables in `src/index.css`

### UI Components
Customize shadcn/ui components in `src/components/ui/`

### API Wrapper
Extend `src/lib/api.ts` for custom endpoints

## Future Enhancement Ideas

- [ ] Job favorites/bookmarks
- [ ] Saved searches
- [ ] Email notifications
- [ ] Job recommendations
- [ ] Skills matching
- [ ] Rating and reviews
- [ ] Payment integration
- [ ] Admin dashboard
- [ ] Analytics
- [ ] Bulk job import
- [ ] Job expiry automation
- [ ] Spam detection
- [ ] Messaging between poster and applicant
- [ ] Video interviews
- [ ] Job templates

## Performance Metrics

- **First Contentful Paint (FCP)**: < 2s
- **Largest Contentful Paint (LCP)**: < 3s
- **Cumulative Layout Shift (CLS)**: < 0.1
- **Time to Interactive (TTI)**: < 4s
- **Page load time**: < 3s (on 4G)

## Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Mobile browsers (iOS Safari 14+, Chrome Android 90+)

## Accessibility

- **WCAG 2.1 Level AA** compliant
- **Keyboard navigation** - All features accessible via keyboard
- **Screen reader support** - Semantic HTML and ARIA labels
- **Color contrast** - WCAG AA compliant contrast ratios
- **Focus indicators** - Visible focus rings on all interactive elements

---

**For detailed setup instructions, see [SETUP.md](./SETUP.md)**
**For quick start, see [QUICK_START.md](./QUICK_START.md)**
