# Flux + Replicate Integration Blueprint

## Overview

This blueprint provides a comprehensive guide for implementing an AI image generation workflow using Flux for UI components and Replicate for AI model inference. This architecture enables you to create applications with powerful image generation capabilities while maintaining a clean, component-based structure.

## Core Technologies

- **Flux**: Component library for building consistent UI interfaces
- **Replicate**: Platform for running AI models in the cloud
- **Next.js**: React framework for server components and API routes
- **TypeScript**: End-to-end type safety
- **Cloudinary**: Image storage and transformation

## Architecture Benefits

1. **Separation of Concerns**: Clean separation between UI, business logic, and AI model inference
2. **Optimized Performance**: Efficient handling of large image data and asynchronous processes
3. **Type Safety**: End-to-end TypeScript typing for model inputs/outputs
4. **Flexible Model Selection**: Easy swapping between different image generation models
5. **Progressive Enhancement**: Graceful degradation when AI services are unavailable

## Implementation Steps

This blueprint is divided into sequential implementation steps:

1. [Setup Flux Components](./01-setup-flux.md)
2. [Configure Replicate API](./02-setup-replicate.md)
3. [Create Image Generation Form](./03-image-generation-form.md)
4. [Implement Server-Side Generation](./04-server-generation.md) 
5. [Display and Manage Results](./05-results-display.md)
6. [Add Image Storage](./06-image-storage.md)
7. [Deploy the Application](./07-deployment.md)

## Directory Structure

```
project/
├── src/
│   ├── app/
│   │   ├── api/
│   │   │   └── generate/
│   │   │       └── route.ts
│   │   ├── generate/
│   │   │   └── page.tsx
│   │   └── gallery/
│   │       └── page.tsx
│   ├── components/
│   │   ├── ui/
│   │   │   ├── button.tsx
│   │   │   ├── form.tsx
│   │   │   └── ...
│   │   ├── generate-form.tsx
│   │   ├── image-display.tsx
│   │   └── model-selector.tsx
│   ├── lib/
│   │   ├── replicate.ts
│   │   ├── cloudinary.ts
│   │   └── utils.ts
│   ├── types/
│   │   └── models.ts
│   └── config/
│       └── models.ts
├── .env
├── .env.example
├── next.config.js
└── package.json
```

## Key Concepts

### Replicate API Integration

```typescript
// src/lib/replicate.ts
import Replicate from 'replicate';

export type ModelConfig = {
  version: string;
  input: Record<string, any>;
};

export const models = {
  sdxl: {
    version: 'stability-ai/sdxl:39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b',
    input: {
      width: 1024,
      height: 1024,
      prompt: '',
      refine: 'expert_ensemble_refiner',
      scheduler: 'K_EULER',
      lora_scale: 0.6,
      num_outputs: 1,
      guidance_scale: 7.5,
      apply_watermark: false,
      high_noise_frac: 0.8,
      negative_prompt: '',
      prompt_strength: 0.8,
      num_inference_steps: 25,
    },
  },
  // Other models...
};

export async function generateImage(
  modelId: keyof typeof models,
  customInput: Partial<typeof models[typeof modelId]['input']>
) {
  const replicate = new Replicate({
    auth: process.env.REPLICATE_API_TOKEN!,
  });

  const model = models[modelId];
  const input = { ...model.input, ...customInput };

  const output = await replicate.run(model.version, { input });
  return output;
}
```

### Image Generation Form

```typescript
// src/components/generate-form.tsx
'use client';

import { useState } from 'react';
import { zodResolver } from '@hookform/resolvers/zod';
import { useForm } from 'react-hook-form';
import { z } from 'zod';
import { Button } from '@/components/ui/button';
import { Form, FormControl, FormField, FormItem, FormLabel } from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Slider } from '@/components/ui/slider';
import { ModelSelector } from './model-selector';

const formSchema = z.object({
  prompt: z.string().min(3, 'Prompt must be at least 3 characters'),
  negativePrompt: z.string().optional(),
  model: z.enum(['sdxl', 'midjourney', 'dalle']),
  width: z.number().min(512).max(1024),
  height: z.number().min(512).max(1024),
  numOutputs: z.number().min(1).max(4),
  guidanceScale: z.number().min(1).max(20),
});

type FormValues = z.infer<typeof formSchema>;

interface GenerateFormProps {
  onSubmit: (values: FormValues) => Promise<void>;
  isGenerating: boolean;
}

export function GenerateForm({ onSubmit, isGenerating }: GenerateFormProps) {
  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      prompt: '',
      negativePrompt: '',
      model: 'sdxl',
      width: 1024,
      height: 1024,
      numOutputs: 1,
      guidanceScale: 7.5,
    },
  });

  const handleSubmit = async (values: FormValues) => {
    await onSubmit(values);
  };

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-6">
        {/* Form fields... */}
        <Button 
          type="submit" 
          disabled={isGenerating} 
          className="w-full"
        >
          {isGenerating ? 'Generating...' : 'Generate Image'}
        </Button>
      </form>
    </Form>
  );
}
```

## Getting Started

To start implementing this blueprint, follow the step-by-step guides in order, beginning with [Setup Flux Components](./01-setup-flux.md).

## Requirements

- Node.js 18+
- Next.js 14+
- Replicate API key
- Cloudinary account (optional)
- TypeScript experience

## Resources

- [Replicate API Documentation](https://replicate.com/docs)
- [Flux Documentation](https://flux.org/docs)
- [Next.js Documentation](https://nextjs.org/docs)
- [Cloudinary Documentation](https://cloudinary.com/documentation)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)