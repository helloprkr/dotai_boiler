# Components Example

This directory contains documentation and references for reusable UI components. These components serve as both examples and templates for consistent UI development across your project.

## Component Documentation Format

Each component should be documented with:

1. Purpose and use cases
2. Props and parameters
3. Examples of implementation
4. Design considerations
5. Accessibility features

## Example Component: Button

```jsx
// Button.tsx
import React from 'react';
import classNames from 'classnames';

export interface ButtonProps {
  /** The button's content */
  children: React.ReactNode;
  /** Button variant styles */
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  /** Button size */
  size?: 'sm' | 'md' | 'lg';
  /** Whether the button is disabled */
  disabled?: boolean;
  /** Click handler */
  onClick?: React.MouseEventHandler<HTMLButtonElement>;
  /** Additional CSS classes */
  className?: string;
}

export const Button = ({
  children,
  variant = 'primary',
  size = 'md',
  disabled = false,
  onClick,
  className,
  ...props
}: ButtonProps) => {
  const baseClasses = 'font-medium rounded focus:outline-none focus:ring-2 transition-colors';
  
  const variantClasses = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-300',
    secondary: 'bg-gray-600 text-white hover:bg-gray-700 focus:ring-gray-300',
    outline: 'border border-blue-600 text-blue-600 hover:bg-blue-50 focus:ring-blue-300',
    ghost: 'text-blue-600 hover:bg-blue-50 focus:ring-blue-300',
  };
  
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg',
  };
  
  const disabledClasses = disabled && 'opacity-50 cursor-not-allowed';
  
  const buttonClasses = classNames(
    baseClasses,
    variantClasses[variant],
    sizeClasses[size],
    disabledClasses,
    className
  );
  
  return (
    <button
      className={buttonClasses}
      disabled={disabled}
      onClick={onClick}
      {...props}
    >
      {children}
    </button>
  );
};
```

## Usage

```jsx
import { Button } from './components/Button';

export default function MyComponent() {
  return (
    <div>
      <Button variant="primary" size="lg" onClick={() => console.log('Clicked!')}>
        Primary Button
      </Button>
      
      <Button variant="outline" disabled>
        Disabled Outline Button
      </Button>
    </div>
  );
}
```

## Design Considerations

- Use consistent spacing and sizing across components
- Follow the project's color palette and typography
- Ensure components are fully responsive
- Support dark mode if required by the project