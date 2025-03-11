# Libraries Example

This directory contains documentation for libraries and utilities used in the project. These documents help AI assistants understand how to correctly implement and use various libraries within your codebase.

## Library Documentation Format

Each library document should include:

1. **Purpose**: What the library does and when to use it
2. **Installation**: How to add it to your project
3. **Basic Usage**: Common patterns and examples
4. **Advanced Features**: More complex implementations
5. **Best Practices**: Recommendations for effective use
6. **Common Pitfalls**: Issues to avoid

## Example: React Query Documentation

```markdown
# React Query

React Query is a data-fetching and state management library for React applications that provides tools for fetching, caching, synchronizing, and updating server state.

## Installation

```bash
npm install @tanstack/react-query
# or
yarn add @tanstack/react-query
```

## Basic Setup

```jsx
// _app.tsx or similar root component
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

// Create a client
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 60 * 1000, // 1 minute
      cacheTime: 5 * 60 * 1000, // 5 minutes
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

function MyApp({ Component, pageProps }) {
  return (
    <QueryClientProvider client={queryClient}>
      <Component {...pageProps} />
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
```

## Basic Query Example

```jsx
import { useQuery } from '@tanstack/react-query';

function fetchPosts() {
  return fetch('/api/posts').then(res => res.json());
}

function Posts() {
  const { isLoading, error, data, isFetching } = useQuery({
    queryKey: ['posts'],
    queryFn: fetchPosts,
  });

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div>
      <h1>Posts</h1>
      {isFetching && <div>Refreshing...</div>}
      <ul>
        {data.map(post => (
          <li key={post.id}>{post.title}</li>
        ))}
      </ul>
    </div>
  );
}
```

## Mutation Example

```jsx
import { useMutation, useQueryClient } from '@tanstack/react-query';

function addPost(newPost) {
  return fetch('/api/posts', {
    method: 'POST',
    body: JSON.stringify(newPost),
    headers: { 'Content-Type': 'application/json' },
  }).then(res => res.json());
}

function AddPost() {
  const queryClient = useQueryClient();
  
  const mutation = useMutation({
    mutationFn: addPost,
    onSuccess: () => {
      // Invalidate and refetch the posts query
      queryClient.invalidateQueries({ queryKey: ['posts'] });
    },
  });

  return (
    <form
      onSubmit={e => {
        e.preventDefault();
        mutation.mutate({ title: e.target.title.value });
        e.target.reset();
      }}
    >
      <input name="title" placeholder="Title" />
      <button type="submit" disabled={mutation.isPending}>
        {mutation.isPending ? 'Adding...' : 'Add Post'}
      </button>
    </form>
  );
}
```

## Best Practices

1. **Use query keys effectively**: Structure keys to enable targeted invalidation
2. **Set appropriate stale times**: Balance freshness vs. network requests
3. **Handle loading and error states**: Always provide feedback to users
4. **Use placeholder data**: Improve UX while waiting for query results
5. **Prefetch data**: Load data before it's needed when possible
```

## Usage

Reference these library documents in your AI conversations to ensure correct implementation patterns and avoid common pitfalls when working with external dependencies.