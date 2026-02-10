-- Marketplace items table
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

-- Enable RLS
ALTER TABLE public.marketplace_items ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Anyone can view marketplace items"
  ON public.marketplace_items
  FOR SELECT
  USING (true);

CREATE POLICY "Authors can create marketplace items"
  ON public.marketplace_items
  FOR INSERT
  WITH CHECK (author_id = auth.uid());

CREATE POLICY "Authors can update own items"
  ON public.marketplace_items
  FOR UPDATE
  USING (author_id = auth.uid());

CREATE POLICY "Authors can delete own items"
  ON public.marketplace_items
  FOR DELETE
  USING (author_id = auth.uid());

-- Triggers
CREATE TRIGGER update_marketplace_items_updated_at
  BEFORE UPDATE ON public.marketplace_items
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Indexes
CREATE INDEX idx_marketplace_items_author_id ON public.marketplace_items(author_id);
CREATE INDEX idx_marketplace_items_item_type ON public.marketplace_items(item_type);
CREATE INDEX idx_marketplace_items_category ON public.marketplace_items(category);
CREATE INDEX idx_marketplace_items_featured ON public.marketplace_items(featured);
CREATE INDEX idx_marketplace_items_verified ON public.marketplace_items(verified);
CREATE INDEX idx_marketplace_items_downloads ON public.marketplace_items(downloads DESC);
CREATE INDEX idx_marketplace_items_rating ON public.marketplace_items(rating DESC NULLS LAST);
CREATE INDEX idx_marketplace_items_created_at ON public.marketplace_items(created_at DESC);
CREATE INDEX idx_marketplace_items_tags ON public.marketplace_items USING gin(tags);

-- Full-text search
CREATE INDEX idx_marketplace_items_search ON public.marketplace_items USING gin(to_tsvector('english', title || ' ' || COALESCE(description, '')));
