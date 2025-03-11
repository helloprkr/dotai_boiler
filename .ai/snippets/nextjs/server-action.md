# Next.js Server Action Pattern

This snippet demonstrates a pattern for implementing server actions in Next.js with proper validation, error handling, and client-side integration.

## Server Action Implementation

```typescript
// app/actions/example.ts
'use server';

import { revalidatePath } from 'next/cache';
import { z } from 'zod';
import { auth } from '@/lib/auth';
import { prisma } from '@/lib/db';

// Define validation schema
const createItemSchema = z.object({
  title: z.string().min(3, 'Title must be at least 3 characters'),
  description: z.string().optional(),
  isPublic: z.boolean().default(false),
});

// Types based on the schema
export type CreateItemFormData = z.infer<typeof createItemSchema>;
export type CreateItemResult = 
  | { success: true; data: { id: string } }
  | { success: false; error: { message: string; fields?: Record<string, string[]> } };

/**
 * Server action to create a new item
 */
export async function createItem(
  formData: FormData | CreateItemFormData
): Promise<CreateItemResult> {
  try {
    // Authentication check
    const session = await auth();
    if (!session) {
      return {
        success: false,
        error: { message: 'You must be signed in to perform this action' }
      };
    }

    // Parse and validate input
    let validatedData: CreateItemFormData;
    
    // Handle both FormData and plain objects
    if (formData instanceof FormData) {
      validatedData = {
        title: formData.get('title') as string,
        description: formData.get('description') as string || undefined,
        isPublic: formData.get('isPublic') === 'true',
      };
    } else {
      validatedData = formData;
    }
    
    // Validate with Zod
    const result = createItemSchema.safeParse(validatedData);
    if (!result.success) {
      // Convert Zod errors to a more usable format
      const fieldErrors = result.error.flatten().fieldErrors;
      return {
        success: false,
        error: {
          message: 'Validation failed',
          fields: Object.fromEntries(
            Object.entries(fieldErrors).map(([key, value]) => [key, value || []])
          )
        }
      };
    }
    
    // Create item in database
    const item = await prisma.item.create({
      data: {
        ...result.data,
        userId: session.user.id,
      },
    });
    
    // Revalidate the items list path
    revalidatePath('/items');
    
    return {
      success: true,
      data: { id: item.id }
    };
  } catch (error) {
    console.error('Create item error:', error);
    return {
      success: false,
      error: { 
        message: error instanceof Error 
          ? error.message 
          : 'An unexpected error occurred' 
      }
    };
  }
}
```

## Client Component Integration

```tsx
// app/items/create-form.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { createItem, type CreateItemFormData } from '@/app/actions/example';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Textarea } from '@/components/ui/textarea';
import { Checkbox } from '@/components/ui/checkbox';
import { 
  Form, 
  FormControl, 
  FormField, 
  FormItem, 
  FormLabel, 
  FormMessage 
} from '@/components/ui/form';
import { toast } from '@/components/ui/use-toast';

// Define the form schema (should match the server schema)
const formSchema = z.object({
  title: z.string().min(3, 'Title must be at least 3 characters'),
  description: z.string().optional(),
  isPublic: z.boolean().default(false),
});

export function CreateItemForm() {
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  // Initialize the form
  const form = useForm<CreateItemFormData>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      title: '',
      description: '',
      isPublic: false,
    },
  });
  
  // Handle form submission
  const onSubmit = async (data: CreateItemFormData) => {
    setIsSubmitting(true);
    
    try {
      const result = await createItem(data);
      
      if (result.success) {
        toast({
          title: 'Item created',
          description: 'Your item has been created successfully.',
        });
        router.push(`/items/${result.data.id}`);
      } else {
        // Handle validation errors
        if (result.error.fields) {
          // Apply field errors to the form
          Object.entries(result.error.fields).forEach(([field, errors]) => {
            form.setError(field as any, { 
              type: 'server', 
              message: errors[0] 
            });
          });
        }
        
        toast({
          title: 'Error',
          description: result.error.message,
          variant: 'destructive',
        });
      }
    } catch (error) {
      toast({
        title: 'Error',
        description: 'An unexpected error occurred. Please try again.',
        variant: 'destructive',
      });
    } finally {
      setIsSubmitting(false);
    }
  };
  
  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">
        <FormField
          control={form.control}
          name="title"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Title</FormLabel>
              <FormControl>
                <Input placeholder="Enter title" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="description"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Description</FormLabel>
              <FormControl>
                <Textarea 
                  placeholder="Enter description (optional)" 
                  {...field} 
                  value={field.value || ''}
                />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="isPublic"
          render={({ field }) => (
            <FormItem className="flex flex-row items-start space-x-3 space-y-0">
              <FormControl>
                <Checkbox
                  checked={field.value}
                  onCheckedChange={field.onChange}
                />
              </FormControl>
              <div className="space-y-1 leading-none">
                <FormLabel>Make this item public</FormLabel>
              </div>
            </FormItem>
          )}
        />
        
        <Button type="submit" disabled={isSubmitting}>
          {isSubmitting ? 'Creating...' : 'Create Item'}
        </Button>
      </form>
    </Form>
  );
}
```

## Server Component Integration

```tsx
// app/items/create/page.tsx
import { Suspense } from 'react';
import { CreateItemForm } from './create-form';

export const metadata = {
  title: 'Create Item',
  description: 'Create a new item',
};

export default function CreateItemPage() {
  return (
    <div className="container mx-auto py-10">
      <h1 className="text-2xl font-bold mb-6">Create New Item</h1>
      <Suspense fallback={<div>Loading form...</div>}>
        <CreateItemForm />
      </Suspense>
    </div>
  );
}
```

## Alternative Form Data Approach

```tsx
// Alternative approach using form action directly with FormData
'use client';

import { useRef } from 'react';
import { useFormState, useFormStatus } from 'react-dom';
import { createItem } from '@/app/actions/example';

// Create a client-side wrapper for the server action
const createItemWithFormData = async (
  prevState: any, 
  formData: FormData
) => {
  return createItem(formData);
};

function SubmitButton() {
  const { pending } = useFormStatus();
  return (
    <button type="submit" disabled={pending}>
      {pending ? 'Creating...' : 'Create Item'}
    </button>
  );
}

export function CreateItemFormWithFormData() {
  const formRef = useRef<HTMLFormElement>(null);
  const [result, formAction] = useFormState(createItemWithFormData, null);
  
  // Handle form reset on success
  if (result?.success && formRef.current) {
    formRef.current.reset();
  }
  
  return (
    <form ref={formRef} action={formAction}>
      {result?.success && <p className="text-green-500">Item created successfully!</p>}
      {result?.error && <p className="text-red-500">{result.error.message}</p>}
      
      <div>
        <label htmlFor="title">Title</label>
        <input
          id="title"
          name="title"
          type="text"
          required
          className="border p-2 w-full"
        />
        {result?.error?.fields?.title && (
          <p className="text-red-500">{result.error.fields.title[0]}</p>
        )}
      </div>
      
      <div className="mt-4">
        <label htmlFor="description">Description</label>
        <textarea
          id="description"
          name="description"
          className="border p-2 w-full"
        />
      </div>
      
      <div className="mt-4">
        <label className="flex items-center">
          <input type="checkbox" name="isPublic" value="true" />
          <span className="ml-2">Make this item public</span>
        </label>
      </div>
      
      <div className="mt-6">
        <SubmitButton />
      </div>
    </form>
  );
}
```

## Best Practices

1. **Validate on both client and server sides**
   - Client: Better user experience with immediate feedback
   - Server: Essential for security and data integrity

2. **Use TypeScript for shared types**
   - Ensure form data types match server action parameters
   - Create explicit return types for server actions

3. **Implement proper error handling**
   - Return structured error objects that can be easily processed by clients
   - Include field-level validation errors for forms

4. **Use Revalidation**
   - Call `revalidatePath()` to refresh data after mutations
   - Consider using `revalidateTag()` for more targeted cache invalidation

5. **Handle loading states**
   - Track submission state on the client
   - Disable form during submission to prevent multiple submissions

6. **Security considerations**
   - Always verify authentication in server actions
   - Validate input data thoroughly
   - Add rate limiting for public actions