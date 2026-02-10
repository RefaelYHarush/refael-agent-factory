-- Executions table
CREATE TABLE public.executions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  workflow_id UUID REFERENCES public.workflows(id) ON DELETE SET NULL,
  agent_id UUID REFERENCES public.agents(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled', 'timeout')),
  input TEXT,
  output TEXT,
  steps_completed INT NOT NULL DEFAULT 0,
  steps_total INT NOT NULL DEFAULT 1,
  current_step JSONB,
  error_message TEXT,
  duration_ms INT,
  tokens_used INT NOT NULL DEFAULT 0,
  cost_usd FLOAT NOT NULL DEFAULT 0.0,
  metadata JSONB DEFAULT '{}'::jsonb,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.executions ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own executions"
  ON public.executions
  FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can create own executions"
  ON public.executions
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own executions"
  ON public.executions
  FOR UPDATE
  USING (user_id = auth.uid());

-- Indexes
CREATE INDEX idx_executions_user_id ON public.executions(user_id);
CREATE INDEX idx_executions_workflow_id ON public.executions(workflow_id);
CREATE INDEX idx_executions_agent_id ON public.executions(agent_id);
CREATE INDEX idx_executions_status ON public.executions(status);
CREATE INDEX idx_executions_created_at ON public.executions(created_at DESC);
CREATE INDEX idx_executions_completed_at ON public.executions(completed_at DESC NULLS LAST);

-- Composite indexes for analytics
CREATE INDEX idx_executions_user_status ON public.executions(user_id, status);
CREATE INDEX idx_executions_user_created ON public.executions(user_id, created_at DESC);
