# TypeScript Utility Types

This snippet provides a collection of useful TypeScript utility types that can be reused across your projects.

## Basic Utility Types

```typescript
/**
 * Makes all properties of T optional
 */
type Partial<T> = {
  [P in keyof T]?: T[P];
};

/**
 * Makes all properties of T required
 */
type Required<T> = {
  [P in keyof T]-?: T[P];
};

/**
 * Makes all properties of T readonly
 */
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

/**
 * From T, pick a set of properties K
 */
type Pick<T, K extends keyof T> = {
  [P in K]: T[P];
};

/**
 * Exclude from T those types that are assignable to U
 */
type Exclude<T, U> = T extends U ? never : T;

/**
 * Extract from T those types that are assignable to U
 */
type Extract<T, U> = T extends U ? T : never;

/**
 * Omit K keys from T
 */
type Omit<T, K extends keyof any> = Pick<T, Exclude<keyof T, K>>;
```

## Advanced Utility Types

```typescript
/**
 * Constructs a type with all properties of T set to optional and possibly undefined
 */
type DeepPartial<T> = T extends object
  ? { [P in keyof T]?: DeepPartial<T[P]> }
  : T;

/**
 * Constructs a type with all properties of T set to readonly 
 * (including nested objects)
 */
type DeepReadonly<T> = T extends (infer R)[]
  ? ReadonlyArray<DeepReadonly<R>>
  : T extends object
  ? { readonly [K in keyof T]: DeepReadonly<T[K]> }
  : T;

/**
 * Returns a type with all properties of T except those in K
 */
type Without<T, K> = {
  [P in Exclude<keyof T, K>]: T[P];
};

/**
 * Creates a type that requires exactly one of the keys of T to be provided
 */
type ExactlyOne<T, Keys extends keyof T = keyof T> = {
  [K in Keys]: {
    [P in K]: T[P];
  } & {
    [P in Exclude<Keys, K>]?: never;
  };
}[Keys];

/**
 * Creates a type with non-nullable properties
 */
type NonNullableProperties<T> = {
  [P in keyof T]: NonNullable<T[P]>;
};

/**
 * Creates a record type with keys of type K and values of type T
 */
type Record<K extends keyof any, T> = {
  [P in K]: T;
};

/**
 * Creates a type from T where null and undefined have been removed
 */
type NonNullable<T> = T extends null | undefined ? never : T;
```

## Function Utility Types

```typescript
/**
 * Function parameter types
 */
type Parameters<T extends (...args: any) => any> = T extends (...args: infer P) => any ? P : never;

/**
 * Function return type
 */
type ReturnType<T extends (...args: any) => any> = T extends (...args: any) => infer R ? R : any;

/**
 * Instance type of a constructor function
 */
type InstanceType<T extends new (...args: any) => any> = T extends new (...args: any) => infer R ? R : any;

/**
 * Constructs a type with the properties of T except for those in type K
 */
type OmitThisParameter<T> = T extends (this: any, ...args: infer A) => infer R ? (...args: A) => R : T;
```

## React-specific Utility Types

```typescript
import React from 'react';

/**
 * Props with children
 */
type PropsWithChildren<P = {}> = P & { children?: React.ReactNode };

/**
 * Component props with ref
 */
type ComponentPropsWithRef<T extends React.ElementType> = React.ComponentPropsWithRef<T>;

/**
 * Component props without ref
 */
type ComponentPropsWithoutRef<T extends React.ElementType> = React.ComponentPropsWithoutRef<T>;

/**
 * Force props to be required
 */
type RequiredProps<T, K extends keyof T> = T & { [P in K]-?: T[P] };

/**
 * Make specific props optional
 */
type OptionalProps<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;
```

## Practical Custom Utility Types

```typescript
/**
 * Makes specific keys K of type T nullable (null or undefined)
 */
type Nullable<T, K extends keyof T> = Omit<T, K> & {
  [P in K]: T[P] | null | undefined;
};

/**
 * Creates a new type with the same properties as T, 
 * but with the types from U for any shared properties
 */
type Overwrite<T, U> = Pick<T, Exclude<keyof T, keyof U>> & U;

/**
 * Create a type that merges two interfaces, with the second one taking precedence for shared keys
 */
type Merge<T, U> = Omit<T, keyof U> & U;

/**
 * Creates a type that requires at least one of the keys of T to be provided
 */
type AtLeastOne<T, Keys extends keyof T = keyof T> = Partial<T> & {
  [K in Keys]: Required<Pick<T, K>>;
}[Keys];

/**
 * Create a discriminated union based on a property
 */
type DiscriminateUnion<T, K extends keyof T, V extends T[K]> = Extract<T, { [P in K]: V }>;

/**
 * Create an object type with specified keys and a common value type
 */
type ObjectWithKeys<K extends string | number | symbol, V> = {
  [P in K]: V;
};
```

## Usage Examples

```typescript
// Using DeepPartial for config objects
interface Config {
  server: {
    port: number;
    host: string;
    options: {
      timeout: number;
      secure: boolean;
    };
  };
  database: {
    url: string;
    credentials: {
      username: string;
      password: string;
    };
  };
}

// Only specify what we want to override
const partialConfig: DeepPartial<Config> = {
  server: {
    port: 8080,
    options: {
      secure: true
    }
  }
};

// Using ExactlyOne for mutual exclusion
interface PaymentMethod {
  creditCard?: {
    number: string;
    expiry: string;
    cvv: string;
  };
  paypal?: {
    email: string;
  };
  bankTransfer?: {
    accountNumber: string;
    routingNumber: string;
  };
}

// Ensure only one payment method is provided
type SinglePaymentMethod = ExactlyOne<PaymentMethod>;

const validPayment: SinglePaymentMethod = {
  creditCard: {
    number: '4111111111111111',
    expiry: '12/24',
    cvv: '123'
  }
};

// This would cause a type error:
// const invalidPayment: SinglePaymentMethod = {
//   creditCard: { number: '4111111111111111', expiry: '12/24', cvv: '123' },
//   paypal: { email: 'user@example.com' }
// };
```