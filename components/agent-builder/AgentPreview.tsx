'use client';

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Brain, Thermometer, Hash } from 'lucide-react';
import type { AgentFormData } from './AgentForm';

interface AgentPreviewProps {
  agent: AgentFormData;
}

export function AgentPreview({ agent }: AgentPreviewProps) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Preview</CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Agent Card Preview */}
        <div className="border-2 border-dashed rounded-lg p-6">
          <div className="flex items-start gap-4">
            <div
              className="w-12 h-12 rounded-lg flex items-center justify-center text-2xl flex-shrink-0"
              style={{ backgroundColor: agent.color + '20' }}
            >
              {agent.icon || '🤖'}
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="font-semibold text-lg mb-1">
                {agent.name || 'Untitled Agent'}
              </h3>
              <p className="text-sm text-muted-foreground">
                {agent.description || 'No description provided'}
              </p>
            </div>
          </div>
        </div>

        {/* Configuration Summary */}
        <div className="space-y-3">
          <h4 className="text-sm font-medium">Configuration</h4>

          <div className="space-y-2">
            <div className="flex items-center gap-3 text-sm">
              <Brain className="h-4 w-4 text-muted-foreground" />
              <span className="text-muted-foreground">Model:</span>
              <span className="font-mono text-xs">
                {agent.model}
              </span>
            </div>

            <div className="flex items-center gap-3 text-sm">
              <Thermometer className="h-4 w-4 text-muted-foreground" />
              <span className="text-muted-foreground">Temperature:</span>
              <span className="font-mono text-xs">
                {agent.temperature}
              </span>
            </div>

            <div className="flex items-center gap-3 text-sm">
              <Hash className="h-4 w-4 text-muted-foreground" />
              <span className="text-muted-foreground">Max Tokens:</span>
              <span className="font-mono text-xs">
                {agent.max_tokens.toLocaleString()}
              </span>
            </div>
          </div>
        </div>

        {/* System Prompt Preview */}
        <div className="space-y-3">
          <h4 className="text-sm font-medium">System Prompt</h4>
          <div className="bg-muted rounded-lg p-4 max-h-48 overflow-y-auto">
            <pre className="text-xs whitespace-pre-wrap font-mono">
              {agent.system_prompt || 'No system prompt defined'}
            </pre>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-2 gap-4 pt-4 border-t">
          <div className="text-center">
            <div className="text-2xl font-bold text-blue-600">
              {agent.system_prompt.length}
            </div>
            <div className="text-xs text-muted-foreground">
              Prompt Characters
            </div>
          </div>
          <div className="text-center">
            <div className="text-2xl font-bold text-green-600">
              ~{Math.ceil(agent.system_prompt.length / 4)}
            </div>
            <div className="text-xs text-muted-foreground">
              Estimated Tokens
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
