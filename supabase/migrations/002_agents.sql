-- Agents table
CREATE TABLE public.agents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  system_prompt TEXT NOT NULL,
  capabilities TEXT[] DEFAULT ARRAY[]::TEXT[],
  model TEXT NOT NULL DEFAULT 'claude-sonnet-4.5' CHECK (model IN ('claude-sonnet-4.5', 'claude-opus-4.6', 'claude-haiku-4.5', 'gpt-4o', 'gpt-4o-mini')),
  temperature FLOAT NOT NULL DEFAULT 0.7 CHECK (temperature >= 0 AND temperature <= 1),
  max_tokens INT NOT NULL DEFAULT 4096 CHECK (max_tokens > 0 AND max_tokens <= 200000),
  tools JSONB DEFAULT '[]'::jsonb,
  knowledge_base JSONB DEFAULT '[]'::jsonb,
  icon TEXT DEFAULT '🤖',
  color TEXT DEFAULT '#3b82f6',
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
ALTER TABLE public.agents ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own agents"
  ON public.agents
  FOR SELECT
  USING (user_id = auth.uid() OR is_public = true);

CREATE POLICY "Users can create own agents"
  ON public.agents
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own agents"
  ON public.agents
  FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Users can delete own agents"
  ON public.agents
  FOR DELETE
  USING (user_id = auth.uid());

-- Triggers
CREATE TRIGGER update_agents_updated_at
  BEFORE UPDATE ON public.agents
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Indexes
CREATE INDEX idx_agents_user_id ON public.agents(user_id);
CREATE INDEX idx_agents_is_public ON public.agents(is_public);
CREATE INDEX idx_agents_marketplace_category ON public.agents(marketplace_category);
CREATE INDEX idx_agents_created_at ON public.agents(created_at DESC);
CREATE INDEX idx_agents_rating ON public.agents(rating DESC NULLS LAST);
CREATE INDEX idx_agents_downloads ON public.agents(downloads_count DESC);

-- Full-text search
CREATE INDEX idx_agents_search ON public.agents USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));
