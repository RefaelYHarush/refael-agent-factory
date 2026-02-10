# 🏭 Agent Factory

**Build Your AI Agent Army - No Code Required**

Create, manage, and deploy AI agents with a visual interface. Workflow designer, agent marketplace, and real-time analytics.

---

## 🚀 Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up Environment Variables

Copy `.env.local.example` to `.env.local`:

```bash
cp .env.local.example .env.local
```

Fill in your credentials:
- Supabase URL & Keys
- Anthropic API Key
- OpenAI API Key (optional, for fallback)

### 3. Run Database Migrations

In your Supabase project, run the migrations in order:

```sql
-- In Supabase SQL Editor:
001_users.sql
002_agents.sql
003_workflows.sql
004_executions.sql
005_marketplace.sql
006_reviews.sql
007_analytics.sql
008_api_keys.sql
```

Or use Supabase CLI:

```bash
supabase db push
```

### 4. Start Development Server

```bash
npm run dev
```

Visit: http://localhost:3000

---

## 📁 Project Structure

```
agent-factory/
├── app/                      # Next.js App Router
│   ├── (auth)/               # Auth pages (login, signup)
│   ├── (dashboard)/          # Main dashboard
│   │   ├── agents/           # Agent management
│   │   ├── workflows/        # Workflow designer
│   │   ├── marketplace/      # Agent store
│   │   ├── analytics/        # Performance metrics
│   │   └── settings/         # User settings
│   ├── api/                  # API routes
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx              # Landing page
├── components/
│   ├── agent-builder/        # Agent creation UI
│   ├── workflow-designer/    # Visual workflow builder
│   ├── ui/                   # Reusable UI components
│   └── layouts/              # Layout components
├── lib/
│   ├── agents/               # Agent runtime logic
│   ├── workflows/            # Workflow execution engine
│   ├── supabase/             # Database client & types
│   └── llm/                  # LLM integrations
├── supabase/
│   └── migrations/           # Database schema (8 files)
└── public/                   # Static assets
```

---

## 🗄 Database Schema

### Core Tables:
1. **users** - User profiles & plan info
2. **agents** - AI agent definitions
3. **workflows** - Multi-agent workflows
4. **executions** - Execution logs & metrics
5. **marketplace_items** - Published agents/workflows
6. **reviews** - User reviews & ratings
7. **analytics_events** - Usage tracking
8. **api_keys** - Programmatic access keys

---

## 🎨 Features

### ✅ Agent Builder
- Visual agent creator
- System prompt editor (Monaco)
- Model selection (Claude, GPT-4)
- Temperature & token controls
- Test sandbox

### 🔄 Workflow Designer
- Drag-and-drop canvas (React Flow)
- Connect agents visually
- Conditional branches
- Error handling
- Real-time execution

### 🏪 Agent Marketplace
- Browse & discover agents
- Categories & tags
- Ratings & reviews
- One-click install
- Publish your own

### 📊 Analytics
- Execution metrics
- Cost tracking
- Performance charts
- Success/failure rates
- Token usage

---

## 💰 Pricing

### Free Tier
- 100 executions/month
- 3 agents max
- 2 workflows max

### Pro ($29/mo)
- 10,000 executions/month
- Unlimited agents
- Unlimited workflows
- API access

### Enterprise ($99/mo)
- Unlimited executions
- Team collaboration
- Dedicated support
- SSO

---

## 🛠 Tech Stack

- **Frontend:** Next.js 16, React 19, TypeScript
- **Styling:** Tailwind CSS, shadcn/ui
- **Database:** Supabase (PostgreSQL)
- **Auth:** Supabase Auth
- **LLM:** Anthropic Claude, OpenAI
- **Workflow:** React Flow
- **Editor:** Monaco Editor
- **Charts:** Recharts
- **Hosting:** Vercel

---

## 📝 Development

### Scripts

```bash
npm run dev           # Start dev server
npm run build         # Build for production
npm run start         # Start production server
npm run lint          # Run ESLint
npm run type-check    # TypeScript validation
```

### Database

```bash
npm run db:generate-types   # Generate TypeScript types
npm run db:push             # Push migrations to Supabase
npm run db:reset            # Reset local database
```

---

## 🎯 Roadmap

### Phase 1: Foundation (Week 1)
- [x] Project setup
- [x] Database schema
- [ ] Auth flow
- [ ] Agent Builder UI
- [ ] Workflow Designer

### Phase 2: Core Features (Week 2)
- [ ] Execution engine
- [ ] Marketplace
- [ ] Analytics dashboard
- [ ] Testing
- [ ] Deploy to production

### Phase 3: Polish (Week 3+)
- [ ] API documentation
- [ ] User onboarding
- [ ] Video tutorials
- [ ] Community features

---

## 📚 Documentation

- [Agent Builder Guide](./docs/AGENT_BUILDER.md)
- [Workflow Designer Tutorial](./docs/WORKFLOW_DESIGNER.md)
- [API Reference](./docs/API.md)
- [Deployment Guide](./docs/DEPLOYMENT.md)

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

---

## 📄 License

MIT License - see [LICENSE](./LICENSE) for details.

---

**Built with ❤️ by Refael Harush**

🔗 [Documentation](https://agent-factory.dev) • [Discord](https://discord.gg/agent-factory) • [Twitter](https://twitter.com/refaelyharush)
