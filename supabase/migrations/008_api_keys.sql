-- API keys table for programmatic access
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

-- Enable RLS
ALTER TABLE public.api_keys ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own API keys"
  ON public.api_keys
  FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can create own API keys"
  ON public.api_keys
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update own API keys"
  ON public.api_keys
  FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Users can delete own API keys"
  ON public.api_keys
  FOR DELETE
  USING (user_id = auth.uid());

-- Indexes
CREATE INDEX idx_api_keys_user_id ON public.api_keys(user_id);
CREATE INDEX idx_api_keys_key_hash ON public.api_keys(key_hash);
CREATE INDEX idx_api_keys_is_active ON public.api_keys(is_active);
CREATE INDEX idx_api_keys_last_used_at ON public.api_keys(last_used_at DESC NULLS LAST);

-- Function to validate API key
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

  -- Update last_used_at
  UPDATE public.api_keys
  SET
    last_used_at = NOW(),
    usage_count = usage_count + 1
  WHERE key_hash = key_hash_param;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
