-- Analytics events table
CREATE TABLE public.analytics_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  execution_id UUID REFERENCES public.executions(id) ON DELETE SET NULL,
  event_type TEXT NOT NULL CHECK (event_type IN ('agent_run', 'workflow_started', 'workflow_completed', 'step_completed', 'step_failed', 'agent_created', 'workflow_created', 'marketplace_download')),
  agent_id UUID REFERENCES public.agents(id) ON DELETE SET NULL,
  workflow_id UUID REFERENCES public.workflows(id) ON DELETE SET NULL,
  duration_ms INT,
  tokens_used INT,
  cost_usd FLOAT,
  success BOOLEAN,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.analytics_events ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own analytics"
  ON public.analytics_events
  FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can insert own analytics"
  ON public.analytics_events
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Indexes
CREATE INDEX idx_analytics_events_user_id ON public.analytics_events(user_id);
CREATE INDEX idx_analytics_events_event_type ON public.analytics_events(event_type);
CREATE INDEX idx_analytics_events_agent_id ON public.analytics_events(agent_id);
CREATE INDEX idx_analytics_events_workflow_id ON public.analytics_events(workflow_id);
CREATE INDEX idx_analytics_events_created_at ON public.analytics_events(created_at DESC);

-- Composite indexes for common queries
CREATE INDEX idx_analytics_events_user_created ON public.analytics_events(user_id, created_at DESC);
CREATE INDEX idx_analytics_events_user_type ON public.analytics_events(user_id, event_type);
CREATE INDEX idx_analytics_events_success ON public.analytics_events(success, created_at DESC);

-- Partitioning by month (for scalability)
-- This will be useful when we have lots of data
-- CREATE TABLE analytics_events_y2026m02 PARTITION OF analytics_events
--   FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
