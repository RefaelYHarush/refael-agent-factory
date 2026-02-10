'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { ModelSelector } from './ModelSelector';
import { PromptEditor } from './PromptEditor';
import { AgentPreview } from './AgentPreview';
import { Save, Play, Sparkles } from 'lucide-react';

export interface AgentFormData {
  name: string;
  description: string;
  system_prompt: string;
  model: string;
  temperature: number;
  max_tokens: number;
  icon: string;
  color: string;
  capabilities: string[];
}

const DEFAULT_FORM_DATA: AgentFormData = {
  name: '',
  description: '',
  system_prompt: 'You are a helpful AI assistant.',
  model: 'claude-sonnet-4.5',
  temperature: 0.7,
  max_tokens: 4096,
  icon: '🤖',
  color: '#3b82f6',
  capabilities: [],
};

interface AgentFormProps {
  initialData?: Partial<AgentFormData>;
  onSave?: (data: AgentFormData) => Promise<void>;
  onTest?: (data: AgentFormData) => Promise<void>;
}

export function AgentForm({ initialData, onSave, onTest }: AgentFormProps) {
  const [formData, setFormData] = useState<AgentFormData>({
    ...DEFAULT_FORM_DATA,
    ...initialData,
  });
  const [isSaving, setIsSaving] = useState(false);
  const [isTesting, setIsTesting] = useState(false);

  const handleChange = (field: keyof AgentFormData, value: any) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  const handleSave = async () => {
    if (!formData.name.trim()) {
      alert('Please enter an agent name');
      return;
    }

    setIsSaving(true);
    try {
      await onSave?.(formData);
    } catch (error) {
      console.error('Failed to save agent:', error);
      alert('Failed to save agent');
    } finally {
      setIsSaving(false);
    }
  };

  const handleTest = async () => {
    setIsTesting(true);
    try {
      await onTest?.(formData);
    } catch (error) {
      console.error('Failed to test agent:', error);
      alert('Failed to test agent');
    } finally {
      setIsTesting(false);
    }
  };

  return (
    <div className="grid lg:grid-cols-2 gap-6">
      {/* Left: Form */}
      <div className="space-y-6">
        {/* Basic Info */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Sparkles className="h-5 w-5 text-blue-600" />
              Basic Information
            </CardTitle>
            <CardDescription>
              Give your agent a name and description
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="name">Agent Name *</Label>
              <Input
                id="name"
                placeholder="e.g., Content Strategist, SEO Optimizer"
                value={formData.name}
                onChange={(e) => handleChange('name', e.target.value)}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="description">Description</Label>
              <Textarea
                id="description"
                placeholder="Briefly describe what this agent does..."
                rows={3}
                value={formData.description}
                onChange={(e) => handleChange('description', e.target.value)}
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="icon">Icon</Label>
                <Input
                  id="icon"
                  placeholder="🤖"
                  maxLength={2}
                  value={formData.icon}
                  onChange={(e) => handleChange('icon', e.target.value)}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="color">Color</Label>
                <Input
                  id="color"
                  type="color"
                  value={formData.color}
                  onChange={(e) => handleChange('color', e.target.value)}
                />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Model & Parameters */}
        <Card>
          <CardHeader>
            <CardTitle>Model Configuration</CardTitle>
            <CardDescription>
              Choose the LLM model and parameters
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <ModelSelector
              value={formData.model}
              onChange={(value) => handleChange('model', value)}
            />

            <div className="space-y-2">
              <div className="flex justify-between">
                <Label htmlFor="temperature">Temperature</Label>
                <span className="text-sm text-muted-foreground">
                  {formData.temperature}
                </span>
              </div>
              <input
                id="temperature"
                type="range"
                min="0"
                max="1"
                step="0.1"
                value={formData.temperature}
                onChange={(e) => handleChange('temperature', parseFloat(e.target.value))}
                className="w-full"
              />
              <p className="text-xs text-muted-foreground">
                Higher = more creative, Lower = more focused
              </p>
            </div>

            <div className="space-y-2">
              <Label htmlFor="max_tokens">Max Tokens</Label>
              <Input
                id="max_tokens"
                type="number"
                min="100"
                max="200000"
                step="100"
                value={formData.max_tokens}
                onChange={(e) => handleChange('max_tokens', parseInt(e.target.value))}
              />
              <p className="text-xs text-muted-foreground">
                Maximum response length (100 - 200,000)
              </p>
            </div>
          </CardContent>
        </Card>

        {/* System Prompt */}
        <Card>
          <CardHeader>
            <CardTitle>System Prompt</CardTitle>
            <CardDescription>
              Define your agent's behavior and instructions
            </CardDescription>
          </CardHeader>
          <CardContent>
            <PromptEditor
              value={formData.system_prompt}
              onChange={(value) => handleChange('system_prompt', value)}
            />
          </CardContent>
        </Card>

        {/* Actions */}
        <div className="flex gap-3">
          <Button
            onClick={handleSave}
            disabled={isSaving}
            className="flex-1"
          >
            <Save className="mr-2 h-4 w-4" />
            {isSaving ? 'Saving...' : 'Save Agent'}
          </Button>
          <Button
            onClick={handleTest}
            disabled={isTesting}
            variant="outline"
            className="flex-1"
          >
            <Play className="mr-2 h-4 w-4" />
            {isTesting ? 'Testing...' : 'Test Agent'}
          </Button>
        </div>
      </div>

      {/* Right: Preview */}
      <div className="lg:sticky lg:top-6 lg:self-start">
        <AgentPreview agent={formData} />
      </div>
    </div>
  );
}
