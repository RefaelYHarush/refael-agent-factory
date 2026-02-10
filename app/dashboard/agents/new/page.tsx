'use client';

import { useRouter } from 'next/navigation';
import { AgentForm, type AgentFormData } from '@/components/agent-builder/AgentForm';
import { ArrowLeft } from 'lucide-react';
import Link from 'next/link';

export default function NewAgentPage() {
  const router = useRouter();

  const handleSave = async (data: AgentFormData) => {
    try {
      const response = await fetch('/api/agents', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error('Failed to create agent');
      }

      const agent = await response.json();

      // Redirect to agents list
      router.push('/dashboard/agents');
    } catch (error) {
      console.error('Error creating agent:', error);
      throw error;
    }
  };

  const handleTest = async (data: AgentFormData) => {
    // For now, just log the test
    console.log('Testing agent:', data);
    alert('Test functionality coming soon! 🚀');
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <Link
          href="/dashboard/agents"
          className="inline-flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground mb-4"
        >
          <ArrowLeft className="h-4 w-4" />
          Back to Agents
        </Link>
        <h1 className="text-3xl font-bold mb-2">Create Agent</h1>
        <p className="text-muted-foreground">
          Build a custom AI agent with your own instructions and configuration
        </p>
      </div>

      {/* Form */}
      <AgentForm
        onSave={handleSave}
        onTest={handleTest}
      />
    </div>
  );
}
