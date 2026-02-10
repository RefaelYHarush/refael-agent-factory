-- Workflows table
CREATE TABLE public.workflows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  trigger_type TEXT NOT NULL DEFAULT 'manual' CHECK (trigger_type IN ('manual', 'scheduled', 'webhook', 'event')),
  trigger_config JSONB DEFAULT '{}'::jsonb,
  steps JSONB NOT NULL DEFAULT '[]'::jsonb,
  -- steps format:
  -- [
  --   {
  --     "step": 1,
  --     "agent_id": "uuid",
  --     "title": "Step title",
  --     "description": "What this step does",
  --     "input_from_step": null | 1 | 2 ...,
  --     "conditions": {...},
  --     "timeout": 300,
  --     "retry": {"max_attempts": 3, "backoff": "exponential"}
  --   }
  -- ]
  is_active BOOLEAN NOT NULL DEFAULT false,
  is_public BOOLEAN NOT NULL DEFAULT false,
  marketplace_category TEXT CHECK (marketplace_category IN ('marketing', 'coding', 'research', 'automation', 'sales', 'support', 'content', 'data', 'other')),
  downloads_count INT NOT NULL DEFAULT 0,
  rating FLOAT CHECK (rating >= 0 AND rating <= 5),
  version TEXT NOT NULL DEFAULT '1.0.0',
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE public.workflows ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own workflows"
  ON public.workflows
  FOR SELECT
  USING (user_id = auth.uid() OR is_public = true);

CREATE POLICY "Users can create own workflows"
  ON public.workflows
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own workflows"
  ON public.workflows
  FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Users can delete own workflows"
  ON public.workflows
  FOR DELETE
  USING (user_id = auth.uid());

-- Triggers
CREATE TRIGGER update_workflows_updated_at
  BEFORE UPDATE ON public.workflows
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Indexes
CREATE INDEX idx_workflows_user_id ON public.workflows(user_id);
CREATE INDEX idx_workflows_is_public ON public.workflows(is_public);
CREATE INDEX idx_workflows_is_active ON public.workflows(is_active);
CREATE INDEX idx_workflows_trigger_type ON public.workflows(trigger_type);
CREATE INDEX idx_workflows_marketplace_category ON public.workflows(marketplace_category);
CREATE INDEX idx_workflows_created_at ON public.workflows(created_at DESC);
CREATE INDEX idx_workflows_rating ON public.workflows(rating DESC NULLS LAST);

-- Full-text search
CREATE INDEX idx_workflows_search ON public.workflows USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));
