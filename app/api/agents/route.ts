import { NextResponse } from 'next/server';
import { createClient } from '@supabase/supabase-js';
import { nanoid } from 'nanoid';

// Use service role key for API routes to bypass RLS
const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

// GET /api/agents - List all agents
export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('userId'); // In production, get from auth session

    if (!userId) {
      return NextResponse.json(
        { error: 'User ID required' },
        { status: 401 }
      );
    }

    const { data: agents, error } = await supabaseAdmin
      .from('agents')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false });

    if (error) {
      throw error;
    }

    return NextResponse.json(agents);
  } catch (error: any) {
    console.error('GET /api/agents error:', error);
    return NextResponse.json(
      { error: error.message || 'Failed to fetch agents' },
      { status: 500 }
    );
  }
}

// POST /api/agents - Create new agent
export async function POST(request: Request) {
  try {
    const body = await request.json();

    // In production, get userId from auth session
    const userId = body.userId || '00000000-0000-0000-0000-000000000000';

    // Validate required fields
    if (!body.name || !body.system_prompt) {
      return NextResponse.json(
        { error: 'Name and system prompt are required' },
        { status: 400 }
      );
    }

    // Create agent
    const agentData = {
      id: nanoid(),
      user_id: userId,
      name: body.name,
      description: body.description || null,
      system_prompt: body.system_prompt,
      model: body.model || 'claude-sonnet-4.5',
      temperature: body.temperature ?? 0.7,
      max_tokens: body.max_tokens || 4096,
      icon: body.icon || '🤖',
      color: body.color || '#3b82f6',
      capabilities: body.capabilities || [],
      tools: body.tools || [],
      knowledge_base: body.knowledge_base || [],
      is_public: body.is_public || false,
      marketplace_category: body.marketplace_category || null,
      version: '1.0.0',
      metadata: body.metadata || {},
    };

    const { data: agent, error } = await supabaseAdmin
      .from('agents')
      .insert([agentData])
      .select()
      .single();

    if (error) {
      throw error;
    }

    return NextResponse.json(agent, { status: 201 });
  } catch (error: any) {
    console.error('POST /api/agents error:', error);
    return NextResponse.json(
      { error: error.message || 'Failed to create agent' },
      { status: 500 }
    );
  }
}
