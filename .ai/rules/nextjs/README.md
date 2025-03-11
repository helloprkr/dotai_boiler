# Next.js Rules

This directory contains rules and best practices for Next.js development. These guidelines help maintain code quality, consistency, and performance throughout your Next.js applications.

## Application Structure

1. **Directory organization**
   - Follow the App Router structure (`app/` directory)
   - Group related routes under common parent folders
   - Use route groups (parentheses) for logical organization without affecting URL
   - Use private folders (underscore) for shared route components

2. **Component separation**
   - Keep page components focused on composition and data fetching
   - Extract UI components to separate files or a components directory
   - Create layout components for shared UI structure
   - Separate client and server components clearly

3. **File naming conventions**
   - Use kebab-case for page routes and folders
   - Use PascalCase for component files
   - Use camelCase for utility functions and hooks
   - Follow Next.js special file conventions (`page.tsx`, `layout.tsx`, etc.)

## Server vs Client Components

1. **Server Component usage**
   - Use Server Components by default for all components
   - Keep components server-side when they:
     - Fetch data
     - Access backend resources directly
     - Use sensitive information
     - Don't require interactivity or browser APIs
   - Explicitly mark client components with the `'use client'` directive

2. **Client Component usage**
   - Use Client Components when you need:
     - Interactivity and event listeners
     - State and lifecycle effects
     - Browser-only APIs
     - Custom hooks
   - Keep client components as small and focused as possible
   - Pass server-fetched data to client components as props

3. **Data Composition Pattern**
   - Fetch data in server components
   - Pass data down to client components
   - Create focused data fetching boundaries
   - Leverage React's component tree for data organization

## Data Fetching

1. **Server Component data fetching**
   - Use native `fetch` with `cache` and `next` options
   - Prefer direct database access in server components
   - Implement concurrent data fetching using Promise.all
   - Handle errors gracefully with try/catch

2. **React Server Actions**
   - Use Server Actions for form submissions and mutations
   - Implement proper validation and error handling
   - Use `revalidatePath` or `revalidateTag` for cache invalidation
   - Mark server action files or functions with `'use server'`

3. **Client-side data fetching**
   - Use SWR or React Query for client-side data fetching
   - Implement optimistic updates for better UX
   - Handle loading and error states consistently
   - Use appropriate caching strategies

## Routing and Navigation

1. **Route organization**
   - Design URL structure for clarity and SEO
   - Use dynamic routes for parameter-based pages
   - Implement catch-all routes for flexible paths
   - Use parallel routes for complex layouts

2. **Navigation**
   - Use `<Link>` component for client-side navigation
   - Implement prefetching strategies for performance
   - Use `useRouter` for programmatic navigation
   - Handle loading states during navigation

3. **Layouts**
   - Create nested layouts for consistent UI
   - Implement loading UI with `loading.tsx`
   - Create error boundaries with `error.tsx`
   - Use templates for repeated layout patterns that require remounting

## Performance

1. **Code splitting**
   - Leverage automatic code splitting by route
   - Use dynamic imports for conditional components
   - Implement lazy loading for below-the-fold content
   - Set appropriate loading priorities

2. **Image optimization**
   - Always use `next/image` for images
   - Set appropriate sizes, quality, and layout
   - Use modern image formats and responsive sources
   - Implement proper loading strategies (eager/lazy)

3. **Font optimization**
   - Use `next/font` for web fonts
   - Implement font subsetting
   - Load critical fonts early
   - Use appropriate font display strategies

4. **Metadata and SEO**
   - Implement proper metadata for all pages
   - Create dynamic metadata based on page content
   - Use structured data for rich results
   - Implement proper canonical URLs

## Example Patterns

### Server Component Data Fetching

```tsx
// app/products/[id]/page.tsx
import { notFound } from 'next/navigation';
import { ProductDetails } from '@/components/product-details';
import { getProduct } from '@/lib/products';

export async function generateMetadata({ params }) {
  const product = await getProduct(params.id);
  if (!product) return notFound();
  
  return {
    title: product.name,
    description: product.description,
  };
}

export default async function ProductPage({ params }) {
  const product = await getProduct(params.id);
  if (!product) return notFound();
  
  return <ProductDetails product={product} />;
}
```

### Server Action

```tsx
// app/actions/create-product.ts
'use server';

import { revalidatePath } from 'next/cache';
import { z } from 'zod';
import { db } from '@/lib/db';

const ProductSchema = z.object({
  name: z.string().min(3),
  price: z.number().positive(),
  description: z.string().optional(),
});

export async function createProduct(formData: FormData) {
  const validatedFields = ProductSchema.safeParse({
    name: formData.get('name'),
    price: Number(formData.get('price')),
    description: formData.get('description'),
  });
  
  if (!validatedFields.success) {
    return { error: validatedFields.error.flatten() };
  }
  
  try {
    const product = await db.product.create({
      data: validatedFields.data,
    });
    
    revalidatePath('/products');
    return { success: true, data: product };
  } catch (error) {
    return { error: 'Failed to create product' };
  }
}
```

### Client Component Form

```tsx
// components/product-form.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { createProduct } from '@/app/actions/create-product';

export function ProductForm() {
  const router = useRouter();
  const [error, setError] = useState('');
  
  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    
    const formData = new FormData(event.target);
    const result = await createProduct(formData);
    
    if (result.error) {
      setError(result.error.message || 'Something went wrong');
      return;
    }
    
    router.push(`/products/${result.data.id}`);
  }
  
  return (
    <form onSubmit={handleSubmit}>
      {error && <p className="text-red-500">{error}</p>}
      <input name="name" placeholder="Product name" required />
      <input name="price" type="number" placeholder="Price" required />
      <textarea name="description" placeholder="Description" />
      <button type="submit">Create Product</button>
    </form>
  );
}
```

## Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [App Router Documentation](https://nextjs.org/docs/app)
- [React Server Components](https://nextjs.org/docs/getting-started/react-essentials)
- [Next.js GitHub Repository](https://github.com/vercel/next.js)
- [Vercel Blog](https://vercel.com/blog)