# TypeScript Rules

This directory contains rules and best practices for TypeScript development. These guidelines help maintain code quality, consistency, and type safety throughout your project.

## Core TypeScript Rules

1. **Use strict type checking**
   - Enable `strict: true` in tsconfig.json
   - Avoid using `any` type except in specific justified cases
   - Use `unknown` instead of `any` when type is truly unknown

2. **Properly type function parameters and return values**
   - Always specify parameter types
   - Define return types for non-trivial functions
   - Use `void` for functions that don't return a value

3. **Leverage TypeScript's type system**
   - Use interfaces for object shapes
   - Use type aliases for complex types or unions
   - Use generics for reusable components and functions
   - Prefer discriminated unions for state management

4. **Null and undefined handling**
   - Use optional parameters and properties with `?`
   - Use nullish coalescing (`??`) and optional chaining (`?.`)
   - Avoid explicit `null` or `undefined` checks when possible

5. **Type narrowing and assertions**
   - Use type guards (`typeof`, `instanceof`, property checks)
   - Use assertion functions for complex validations
   - Limit use of type assertions (`as Type`) to special cases

## React-specific TypeScript Rules

1. **Component props and state typing**
   - Define explicit interfaces for component props
   - Use descriptive names for prop interfaces (e.g., `ButtonProps`)
   - Make props optional when they have default values
   - Use React's built-in types for events and refs

2. **Functional components typing**
   - Use `React.FC<Props>` or directly type the function
   - Explicitly type `children` when needed
   - Use proper event types for handlers

3. **Hooks typing**
   - Provide type parameters to hooks (`useState<string>('')`)
   - Use `useRef<HTMLDivElement>(null)` for DOM references
   - Define explicit return types for custom hooks

## Example Type Definitions

```typescript
// Interface for object shapes
interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
  settings?: UserSettings;
  lastLogin: Date;
}

// Type alias for union types
type ID = string | number;

// Generic type
type Result<T> = {
  data: T;
  error: null;
} | {
  data: null;
  error: Error;
};

// Discriminated union
type Action = 
  | { type: 'INCREMENT'; payload: number }
  | { type: 'DECREMENT'; payload: number }
  | { type: 'RESET' };

// React component props interface
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary' | 'outlined';
  disabled?: boolean;
  size?: 'sm' | 'md' | 'lg';
  children?: React.ReactNode;
}
```

## Best Practices

1. **Type safety**
   - Never use `@ts-ignore` or `@ts-nocheck` without justification
   - Document type workarounds with comments
   - Write unit tests that verify type behavior

2. **Type imports and exports**
   - Use `import type` for type-only imports
   - Export types and interfaces when they're used across modules
   - Group type imports separately from value imports

3. **Type documentation**
   - Use JSDoc comments for public functions and interfaces
   - Document complex types with examples
   - Explain non-obvious type constraints

4. **Type organization**
   - Keep related types in the same file
   - Create dedicated type files for shared types
   - Consider using namespaces for organizing related types

## Advanced Type Patterns

1. **Mapped types**
   - Use mapped types to transform existing types
   - Create readonly or partial versions of types
   - Generate derived types with consistent transformations

2. **Conditional types**
   - Use conditional types for type-level logic
   - Extract specific types from unions or tuples
   - Create types that adapt based on input type parameters

3. **Template literal types**
   - Use template literal types for string manipulation
   - Create string unions from existing types
   - Enforce specific string formats at the type level

## Resources

- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [React TypeScript Cheatsheet](https://react-typescript-cheatsheet.netlify.app/)
- [TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)