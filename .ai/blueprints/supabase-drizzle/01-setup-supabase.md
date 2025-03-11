# Step 1: Setup Supabase Project

This guide will walk you through setting up a Supabase project and configuring it for your application.

## 1. Create a Supabase Project

1. Go to [Supabase](https://supabase.com) and sign in to your account.
2. Click on "New Project" to create a new project.
3. Fill in the required details:
   - **Organization**: Select or create an organization
   - **Name**: Enter a project name (this will be part of the API URL)
   - **Database Password**: Set a strong password for the Postgres database
   - **Region**: Select the region closest to your users
4. Click "Create New Project" and wait for the project to be provisioned (this may take a few minutes).

## 2. Get API Keys and URLs

Once your project is created:

1. Go to the project dashboard.
2. Navigate to "Settings" > "API" in the sidebar.
3. You will find these important credentials:
   - **Project URL**: The base URL for API requests
   - **anon public**: The anonymous API key for client-side requests
   - **service_role**: The service role key for server-side requests (keep this secure!)

## 3. Configure Environment Variables

Create or update your `.env.local` file with Supabase credentials:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

Make sure to add these variables to your `.env.example` file as well (without actual values) to guide other developers.

## 4. Install Supabase Client

Install the Supabase JavaScript client:

```bash
npm install @supabase/supabase-js
# or
yarn add @supabase/supabase-js
# or
pnpm add @supabase/supabase-js
```

## 5. Create Supabase Client Helpers

Create a utility file to initialize the Supabase client:

**Client-side initialization (`src/lib/supabase/client.ts`):**

```typescript
import { createClient } from '@supabase/supabase-js';
import { Database } from '@/types/supabase';

// These environment variables are set in the build environment
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

// Create a singleton Supabase client for client-side usage
export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey);
```

**Server-side initialization (`src/lib/supabase/server.ts`):**

```typescript
import { createClient } from '@supabase/supabase-js';
import { cookies } from 'next/headers';
import { Database } from '@/types/supabase';

// Create a Supabase client for server-side usage
export function createServerClient() {
  const cookieStore = cookies();
  
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
  const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
  
  return createClient<Database>(supabaseUrl, supabaseAnonKey, {
    cookies: {
      get(name) {
        return cookieStore.get(name)?.value;
      },
      set(name, value, options) {
        cookieStore.set({ name, value, ...options });
      },
      remove(name, options) {
        cookieStore.set({ name, value: '', ...options });
      },
    },
  });
}
```

## 6. Create a Database Types Placeholder

Create a placeholder for the database types that will be generated later:

**Create `src/types/supabase.ts`:**

```typescript
export type Database = {
  // These types will be populated later when we generate them
  // from the actual database schema
};
```

## 7. Test the Connection

Create a simple test to verify that the connection is working:

```typescript
// src/app/api/test-connection/route.ts
import { createServerClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';

export async function GET() {
  try {
    const supabase = createServerClient();
    const { data, error } = await supabase.from('_test').select('*').limit(1);
    
    if (error) {
      return NextResponse.json({ error: error.message }, { status: 500 });
    }
    
    return NextResponse.json({ success: true, message: 'Connection successful' });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to connect to Supabase' },
      { status: 500 }
    );
  }
}
```

## Next Steps

Now that you have set up your Supabase project and configured the client, you can proceed to the next step: [Configure Drizzle ORM](./02-setup-drizzle.md) to set up your database schema and migrations.

## Troubleshooting

- **Connection Issues**: Verify that your environment variables are correctly set and accessible
- **CORS Errors**: Ensure your project's URL is added to the allowed origins in Supabase settings
- **Authentication Errors**: Check that you're using the correct API keys for client and server-side operations

## Resources

- [Supabase JavaScript Client Documentation](https://supabase.com/docs/reference/javascript/introduction)
- [Supabase Auth Helpers for Next.js](https://supabase.com/docs/guides/auth/auth-helpers/nextjs)
- [Environment Variables in Next.js](https://nextjs.org/docs/basic-features/environment-variables)