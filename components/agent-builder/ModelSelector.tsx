'use client';

import { Label } from '@/components/ui/label';
import { Brain, Zap, DollarSign } from 'lucide-react';

const MODELS = [
  {
    id: 'claude-sonnet-4.5',
    name: 'Claude Sonnet 4.5',
    provider: 'Anthropic',
    description: 'Balanced performance and speed',
    icon: <Brain className="h-4 w-4" />,
    cost: '$3 / 1M tokens',
    maxTokens: 200000,
  },
  {
    id: 'claude-opus-4.6',
    name: 'Claude Opus 4.6',
    provider: 'Anthropic',
    description: 'Most capable, best for complex tasks',
    icon: <Brain className="h-4 w-4" />,
    cost: '$15 / 1M tokens',
    maxTokens: 200000,
  },
  {
    id: 'claude-haiku-4.5',
    name: 'Claude Haiku 4.5',
    provider: 'Anthropic',
    description: 'Fast and affordable',
    icon: <Zap className="h-4 w-4" />,
    cost: '$0.25 / 1M tokens',
    maxTokens: 200000,
  },
  {
    id: 'gpt-4o',
    name: 'GPT-4o',
    provider: 'OpenAI',
    description: 'OpenAI flagship model',
    icon: <Brain className="h-4 w-4" />,
    cost: '$2.5 / 1M tokens',
    maxTokens: 128000,
  },
  {
    id: 'gpt-4o-mini',
    name: 'GPT-4o Mini',
    provider: 'OpenAI',
    description: 'Small, fast, affordable',
    icon: <Zap className="h-4 w-4" />,
    cost: '$0.15 / 1M tokens',
    maxTokens: 128000,
  },
];

interface ModelSelectorProps {
  value: string;
  onChange: (value: string) => void;
}

export function ModelSelector({ value, onChange }: ModelSelectorProps) {
  return (
    <div className="space-y-2">
      <Label>Model</Label>
      <div className="grid gap-3">
        {MODELS.map((model) => {
          const isSelected = value === model.id;
          return (
            <button
              key={model.id}
              type="button"
              onClick={() => onChange(model.id)}
              className={`
                relative p-4 rounded-lg border-2 text-left transition-all
                ${
                  isSelected
                    ? 'border-blue-600 bg-blue-50 dark:bg-blue-950'
                    : 'border-gray-200 dark:border-gray-800 hover:border-gray-300 dark:hover:border-gray-700'
                }
              `}
            >
              <div className="flex items-start justify-between gap-3">
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 mb-1">
                    {model.icon}
                    <h4 className="font-semibold text-sm">{model.name}</h4>
                  </div>
                  <p className="text-xs text-muted-foreground mb-2">
                    {model.description}
                  </p>
                  <div className="flex items-center gap-4 text-xs text-muted-foreground">
                    <span className="flex items-center gap-1">
                      <DollarSign className="h-3 w-3" />
                      {model.cost}
                    </span>
                    <span>
                      {model.maxTokens.toLocaleString()} tokens
                    </span>
                  </div>
                </div>
                {isSelected && (
                  <div className="flex-shrink-0">
                    <div className="h-5 w-5 rounded-full bg-blue-600 flex items-center justify-center">
                      <svg
                        className="h-3 w-3 text-white"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={3}
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                    </div>
                  </div>
                )}
              </div>
            </button>
          );
        })}
      </div>
    </div>
  );
}
