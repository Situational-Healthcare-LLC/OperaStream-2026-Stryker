# OperaStream™ Clinical Collaboration Platform

A comprehensive healthcare collaboration platform for virtual nursing, clinical education, and multi-disciplinary care coordination.

---

## 🚀 FIRST TIME SETUP

**Your database needs to be set up before running the app.**

### Step 1: Create Database Tables (2 minutes)
**👉 Click here:** https://supabase.com/dashboard/project/vfsuqgusrawzqilgaayq/sql/new

Then:
1. Open `migration.sql` from this project
2. Copy ALL content
3. Paste into SQL editor
4. Click **RUN**

### Step 2: Add Sample Data (30 seconds)
```bash
node scripts/direct-seed.mjs
```

**See `SETUP_INSTRUCTIONS.md` for complete details and troubleshooting.**

---

## Features

- **Virtual Nursing Desktop** - Multi-patient monitoring with live camera feeds and real-time vitals
- **Clinical Systems Integration** - EHR, Labs, Radiology, PACS, and Pathology system viewers
- **Teams Integration** - Microsoft Teams-style video conferencing with clinical system sharing
- **Medical Rounds** - Schedule and conduct virtual rounds with multi-disciplinary teams
- **Clinical Search Engine** - Real-time PubMed search across 35+ million medical articles
- **Patient Photo Management** - Upload and manage patient photos with persistent storage
- **PACS Viewer** - Interactive medical imaging viewer with annotation tools
- **HIPAA Compliance** - Built-in security forms and audit logging

## Quick Start

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start development server:
   ```bash
   npm run dev
   ```

3. Build for production:
   ```bash
   npm run build
   ```

## Environment Variables

The application uses Supabase for database and storage. Environment variables are configured in `.env`:

- `VITE_SUPABASE_URL` - Your Supabase project URL
- `VITE_SUPABASE_ANON_KEY` - Your Supabase anonymous key

## Tech Stack

- **Frontend**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS
- **Database**: Supabase (PostgreSQL)
- **Storage**: Supabase Storage / LocalStorage fallback
- **Icons**: Lucide React

## Project Structure

```
src/
├── components/        # React components
├── contexts/          # React contexts (Auth)
├── data/              # Static data (patients, lab results)
├── hooks/             # Custom React hooks
├── lib/               # Library configurations (Supabase)
├── services/          # Business logic services
├── types/             # TypeScript type definitions
└── utils/             # Utility functions
```

## Key Components

- `TeamsMeetingInterface` - Main video conferencing interface
- `VirtualNursingDesktop` - Multi-patient monitoring dashboard
- `PACSViewer` - Medical imaging viewer with annotations
- `ClinicalSearchEngine` - PubMed research integration
- `PatientTile` - Patient information card with photo upload

## License

Proprietary
