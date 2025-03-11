# Supabase + Drizzle ORM + Server Actions Blueprint

## Overview

This blueprint provides a comprehensive guide for implementing a modern, type-safe backend architecture using Supabase as the database provider, Drizzle ORM for database interactions, and Next.js Server Actions for secure API endpoints.

## Core Technologies

- **Supabase**: Provides PostgreSQL database, authentication, and storage
- **Drizzle ORM**: Type-safe ORM with schema definition and migrations
- **Next.js Server Actions**: Server-side functions that can be called directly from client components
- **TypeScript**: End-to-end type safety across the entire stack
- **Zod**: Runtime validation for enhanced type safety

## Architecture Benefits

1. **Full Type Safety**: End-to-end TypeScript types from database to client
2. **Optimized Performance**: Server-side execution with client-side updates
3. **Enhanced Security**: Database logic runs on the server without exposing API endpoints
4. **Simplified Authentication**: Leverages Supabase Auth with minimal setup
5. **Schema Reliability**: Drizzle ensures schema consistency with migrations

## Implementation Steps

This blueprint is divided into sequential implementation steps:

1. [Setup Supabase Project](./01-setup-supabase.md)
2. [Configure Drizzle ORM](./02-setup-drizzle.md)
3. [Define Database Schema](./03-database-schema.md)
4. [Create Server Actions](./04-server-actions.md)
5. [Implement Authentication](./05-authentication.md)
6. [Build Client Components](./06-client-components.md)
7. [Deploy the Application](./07-deployment.md)

## Directory Structure

```
project/
├── src/
│   ├── app/
│   │   ├── api/
│   │   ├── [routes]/
│   ├── components/
│   ├── db/
│   │   ├── schema/
│   │   │   ├── auth.ts
│   │   │   ├── posts.ts
│   │   │   └── ...
│   │   ├── migrations/
│   │   ├── index.ts
│   │   ├── schema.ts
│   │   └── drizzle.config.ts
│   ├── lib/
│   │   ├── supabase/
│   │   │   ├── client.ts
│   │   │   └── server.ts
│   │   └── utils.ts
│   ├── actions/
│   │   ├── posts.ts
│   │   ├── users.ts
│   │   └── ...
│   └── types/
├── .env
├── .env.example
├── next.config.js
└── package.json
```

## Key Concepts

### Database Schema with Drizzle

```typescript
// src/db/schema/posts.ts
import { pgTable, text, timestamp, uuid } from 'drizzle-orm/pg-core';
import { users } from './auth';
import { relations } from 'drizzle-orm';

export const posts = pgTable('posts', {
  id: uuid('id').defaultRandom().primaryKey(),
  title: text('title').notNull(),
  content: text('content').notNull(),
  authorId: uuid('author_id').references(() => users.id).notNull(),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, {
    fields: [posts.authorId],
    references: [users.id],
  }),
}));
```

### Server Actions

```typescript
// src/actions/posts.ts
'use server'

import { revalidatePath } from 'next/cache';
import { z } from 'zod';
import { db } from '@/db';
import { posts } from '@/db/schema';
import { createServerClient } from '@/lib/supabase/server';

const PostSchema = z.object({
  title: z.string().min(3).max(100),
  content: z.string().min(10),
});

export async function createPost(formData: FormData) {
  const title = formData.get('title') as string;
  const content = formData.get('content') as string;
  
  // Validate input
  const result = PostSchema.safeParse({ title, content });
  if (!result.success) {
    return { error: result.error.format() };
  }
  
  // Get authenticated user
  const supabase = createServerClient();
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) {
    return { error: 'Not authenticated' };
  }
  
  // Create post in database
  await db.insert(posts).values({
    title,
    content,
    authorId: session.user.id,
  });
  
  // Revalidate the posts page
  revalidatePath('/posts');
  return { success: true };
}
```

## Getting Started

To start implementing this blueprint, follow the step-by-step guides in order, beginning with [Setup Supabase Project](./01-setup-supabase.md).

## Requirements

- Node.js 18+
- Next.js 14+
- Supabase account
- PostgreSQL knowledge (basic)
- TypeScript experience

## Resources

- [Supabase Documentation](https://supabase.io/docs)
- [Drizzle ORM Documentation](https://orm.drizzle.team/docs/overview)
- [Next.js Server Actions Documentation](https://nextjs.org/docs/app/building-your-application/data-fetching/server-actions)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [Zod Documentation](https://zod.dev/)