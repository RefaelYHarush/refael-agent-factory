-- ============================================
-- Agent Factory - Complete Database Setup
-- Run this in Supabase SQL Editor
-- ============================================

-- This file combines all 8 migrations into ONE
-- Just copy-paste this entire file and run it!

-- ============================================
-- 001: Users Table
-- ============================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  plan_type TEXT NOT NULL DEFAULT 'free' CHECK (plan_type IN ('free', 'pro', 'enterprise')),
  api_keys JSONB DEFAULT '{}'::jsonb,
  usage_limits JSONB DEFAULT '{"executions_per_month": 100, "agents_max": 3, "workflows_max": 2}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON public.users FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.users FOR UPDATE USING (auth.uid() = id);

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, username, full_name, avatar_url)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'username', SPLIT_PART(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'full_name', ''),
    COALESCE(NEW.raw_user_meta_data->>'avatar_url', '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE INDEX idx_users_username ON public.users(username);
CREATE INDEX idx_users_plan_type ON public.users(plan_type);

-- ============================================
-- 002: Agents Table
-- ============================================

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

ALTER TABLE public.agents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own agents"
  ON public.agents FOR SELECT USING (user_id = auth.uid() OR is_public = true);

CREATE POLICY "Users can create own agents"
  ON public.agents FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own agents"
  ON public.agents FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Users can delete own agents"
  ON public.agents FOR DELETE USING (user_id = auth.uid());

CREATE TRIGGER update_agents_updated_at
  BEFORE UPDATE ON public.agents
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE INDEX idx_agents_user_id ON public.agents(user_id);
CREATE INDEX idx_agents_is_public ON public.agents(is_public);
CREATE INDEX idx_agents_marketplace_category ON public.agents(marketplace_category);
CREATE INDEX idx_agents_created_at ON public.agents(created_at DESC);
CREATE INDEX idx_agents_rating ON public.agents(rating DESC NULLS LAST);
CREATE INDEX idx_agents_downloads ON public.agents(downloads_count DESC);
CREATE INDEX idx_agents_search ON public.agents USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- ============================================
-- 003: Workflows Table
-- ============================================

CREATE TABLE public.workflows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  trigger_type TEXT NOT NULL DEFAULT 'manual' CHECK (trigger_type IN ('manual', 'scheduled', 'webhook', 'event')),
  trigger_config JSONB DEFAULT '{}'::jsonb,
  steps JSONB NOT NULL DEFAULT '[]'::jsonb,
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

ALTER TABLE public.workflows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own workflows"
  ON public.workflows FOR SELECT USING (user_id = auth.uid() OR is_public = true);

CREATE POLICY "Users can create own workflows"
  ON public.workflows FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own workflows"
  ON public.workflows FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Users can delete own workflows"
  ON public.workflows FOR DELETE USING (user_id = auth.uid());

CREATE TRIGGER update_workflows_updated_at
  BEFORE UPDATE ON public.workflows
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE INDEX idx_workflows_user_id ON public.workflows(user_id);
CREATE INDEX idx_workflows_is_public ON public.workflows(is_public);
CREATE INDEX idx_workflows_is_active ON public.workflows(is_active);
CREATE INDEX idx_workflows_trigger_type ON public.workflows(trigger_type);
CREATE INDEX idx_workflows_marketplace_category ON public.workflows(marketplace_category);
CREATE INDEX idx_workflows_created_at ON public.workflows(created_at DESC);
CREATE INDEX idx_workflows_rating ON public.workflows(rating DESC NULLS LAST);
CREATE INDEX idx_workflows_search ON public.workflows USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- ============================================
-- 004: Executions Table
-- ============================================

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

ALTER TABLE public.executions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own executions"
  ON public.executions FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can create own executions"
  ON public.executions FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own executions"
  ON public.executions FOR UPDATE USING (user_id = auth.uid());

CREATE INDEX idx_executions_user_id ON public.executions(user_id);
CREATE INDEX idx_executions_workflow_id ON public.executions(workflow_id);
CREATE INDEX idx_executions_agent_id ON public.executions(agent_id);
CREATE INDEX idx_executions_status ON public.executions(status);
CREATE INDEX idx_executions_created_at ON public.executions(created_at DESC);
CREATE INDEX idx_executions_completed_at ON public.executions(completed_at DESC NULLS LAST);
CREATE INDEX idx_executions_user_status ON public.executions(user_id, status);
CREATE INDEX idx_executions_user_created ON public.executions(user_id, created_at DESC);

-- ============================================
-- 005: Marketplace Items Table
-- ============================================

CREATE TABLE public.marketplace_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  item_type TEXT NOT NULL CHECK (item_type IN ('agent', 'workflow')),
  item_id UUID NOT NULL,
  author_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL CHECK (category IN ('marketing', 'coding', 'research', 'automation', 'sales', 'support', 'content', 'data', 'other')),
  tags TEXT[] DEFAULT ARRAY[]::TEXT[],
  price FLOAT NOT NULL DEFAULT 0.0 CHECK (price >= 0),
  downloads INT NOT NULL DEFAULT 0,
  rating FLOAT CHECK (rating >= 0 AND rating <= 5),
  reviews_count INT NOT NULL DEFAULT 0,
  featured BOOLEAN NOT NULL DEFAULT false,
  verified BOOLEAN NOT NULL DEFAULT false,
  version TEXT NOT NULL DEFAULT '1.0.0',
  changelog TEXT,
  screenshots TEXT[] DEFAULT ARRAY[]::TEXT[],
  demo_video_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(item_type, item_id)
);

ALTER TABLE public.marketplace_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view marketplace items"
  ON public.marketplace_items FOR SELECT USING (true);

CREATE POLICY "Authors can create marketplace items"
  ON public.marketplace_items FOR INSERT WITH CHECK (author_id = auth.uid());

CREATE POLICY "Authors can update own items"
  ON public.marketplace_items FOR UPDATE USING (author_id = auth.uid());

CREATE POLICY "Authors can delete own items"
  ON public.marketplace_items FOR DELETE USING (author_id = auth.uid());

CREATE TRIGGER update_marketplace_items_updated_at
  BEFORE UPDATE ON public.marketplace_items
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE INDEX idx_marketplace_items_author_id ON public.marketplace_items(author_id);
CREATE INDEX idx_marketplace_items_item_type ON public.marketplace_items(item_type);
CREATE INDEX idx_marketplace_items_category ON public.marketplace_items(category);
CREATE INDEX idx_marketplace_items_featured ON public.marketplace_items(featured);
CREATE INDEX idx_marketplace_items_verified ON public.marketplace_items(verified);
CREATE INDEX idx_marketplace_items_downloads ON public.marketplace_items(downloads DESC);
CREATE INDEX idx_marketplace_items_rating ON public.marketplace_items(rating DESC NULLS LAST);
CREATE INDEX idx_marketplace_items_created_at ON public.marketplace_items(created_at DESC);
CREATE INDEX idx_marketplace_items_tags ON public.marketplace_items USING gin(tags);
CREATE INDEX idx_marketplace_items_search ON public.marketplace_items USING gin(to_tsvector('english', title || ' ' || COALESCE(description, '')));

-- ============================================
-- 006: Reviews Table
-- ============================================

CREATE TABLE public.reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  marketplace_item_id UUID NOT NULL REFERENCES public.marketplace_items(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  helpful_count INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(marketplace_item_id, user_id)
);

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view reviews"
  ON public.reviews FOR SELECT USING (true);

CREATE POLICY "Authenticated users can create reviews"
  ON public.reviews FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reviews"
  ON public.reviews FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own reviews"
  ON public.reviews FOR DELETE USING (auth.uid() = user_id);

CREATE TRIGGER update_reviews_updated_at
  BEFORE UPDATE ON public.reviews
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE OR REPLACE FUNCTION public.update_marketplace_item_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.marketplace_items
  SET
    rating = (
      SELECT AVG(rating)::FLOAT
      FROM public.reviews
      WHERE marketplace_item_id = COALESCE(NEW.marketplace_item_id, OLD.marketplace_item_id)
    ),
    reviews_count = (
      SELECT COUNT(*)
      FROM public.reviews
      WHERE marketplace_item_id = COALESCE(NEW.marketplace_item_id, OLD.marketplace_item_id)
    )
  WHERE id = COALESCE(NEW.marketplace_item_id, OLD.marketplace_item_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_review_change
  AFTER INSERT OR UPDATE OR DELETE ON public.reviews
  FOR EACH ROW EXECUTE FUNCTION public.update_marketplace_item_rating();

CREATE INDEX idx_reviews_marketplace_item_id ON public.reviews(marketplace_item_id);
CREATE INDEX idx_reviews_user_id ON public.reviews(user_id);
CREATE INDEX idx_reviews_rating ON public.reviews(rating);
CREATE INDEX idx_reviews_created_at ON public.reviews(created_at DESC);
CREATE INDEX idx_reviews_helpful_count ON public.reviews(helpful_count DESC);

-- ============================================
-- 007: Analytics Events Table
-- ============================================

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

ALTER TABLE public.analytics_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own analytics"
  ON public.analytics_events FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert own analytics"
  ON public.analytics_events FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE INDEX idx_analytics_events_user_id ON public.analytics_events(user_id);
CREATE INDEX idx_analytics_events_event_type ON public.analytics_events(event_type);
CREATE INDEX idx_analytics_events_agent_id ON public.analytics_events(agent_id);
CREATE INDEX idx_analytics_events_workflow_id ON public.analytics_events(workflow_id);
CREATE INDEX idx_analytics_events_created_at ON public.analytics_events(created_at DESC);
CREATE INDEX idx_analytics_events_user_created ON public.analytics_events(user_id, created_at DESC);
CREATE INDEX idx_analytics_events_user_type ON public.analytics_events(user_id, event_type);
CREATE INDEX idx_analytics_events_success ON public.analytics_events(success, created_at DESC);

-- ============================================
-- 008: API Keys Table
-- ============================================

CREATE TABLE public.api_keys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  key_hash TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  last_used_at TIMESTAMPTZ,
  usage_count INT NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.api_keys ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own API keys"
  ON public.api_keys FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can create own API keys"
  ON public.api_keys FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own API keys"
  ON public.api_keys FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Users can delete own API keys"
  ON public.api_keys FOR DELETE USING (user_id = auth.uid());

CREATE INDEX idx_api_keys_user_id ON public.api_keys(user_id);
CREATE INDEX idx_api_keys_key_hash ON public.api_keys(key_hash);
CREATE INDEX idx_api_keys_is_active ON public.api_keys(is_active);
CREATE INDEX idx_api_keys_last_used_at ON public.api_keys(last_used_at DESC NULLS LAST);

CREATE OR REPLACE FUNCTION public.validate_api_key(key_hash_param TEXT)
RETURNS TABLE(user_id UUID, is_valid BOOLEAN) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ak.user_id,
    (ak.is_active AND u.plan_type IS NOT NULL) AS is_valid
  FROM public.api_keys ak
  JOIN public.users u ON u.id = ak.user_id
  WHERE ak.key_hash = key_hash_param;

  UPDATE public.api_keys
  SET
    last_used_at = NOW(),
    usage_count = usage_count + 1
  WHERE key_hash = key_hash_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================
-- DONE! All 8 migrations complete
-- ============================================
