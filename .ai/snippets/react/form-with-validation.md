# React Form with Validation

This snippet demonstrates a reusable form component with validation using React Hook Form and Zod.

## Component Structure

```tsx
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";

// Define the form schema using Zod
const formSchema = z.object({
  name: z.string().min(2, "Name must be at least 2 characters"),
  email: z.string().email("Please enter a valid email address"),
  password: z.string().min(8, "Password must be at least 8 characters"),
});

// Infer the type from the schema
type FormValues = z.infer<typeof formSchema>;

interface FormWithValidationProps {
  onSubmit: (values: FormValues) => void;
  defaultValues?: Partial<FormValues>;
}

export function FormWithValidation({ 
  onSubmit, 
  defaultValues = {
    name: "",
    email: "",
    password: "",
  }
}: FormWithValidationProps) {
  // Initialize the form
  const form = useForm<FormValues>({
    resolver: zodResolver(formSchema),
    defaultValues,
  });

  // Handle form submission
  const handleSubmit = form.handleSubmit(onSubmit);

  return (
    <Form {...form}>
      <form onSubmit={handleSubmit} className="space-y-6">
        <FormField
          control={form.control}
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Name</FormLabel>
              <FormControl>
                <Input placeholder="Enter your name" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" placeholder="Enter your email" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="password"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Password</FormLabel>
              <FormControl>
                <Input type="password" placeholder="Enter your password" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <Button type="submit" className="w-full">
          Submit
        </Button>
      </form>
    </Form>
  );
}
```

## Usage Example

```tsx
import { FormWithValidation } from "@/components/form-with-validation";
import { toast } from "@/components/ui/use-toast";

export default function SignupPage() {
  const handleSubmit = async (values) => {
    try {
      // Call your API or auth service here
      await signUpUser(values);
      
      toast({
        title: "Account created!",
        description: "You've successfully signed up.",
        variant: "success",
      });
    } catch (error) {
      toast({
        title: "Error",
        description: error.message || "Failed to create account",
        variant: "destructive",
      });
    }
  };

  return (
    <div className="max-w-md mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Sign Up</h1>
      <FormWithValidation onSubmit={handleSubmit} />
    </div>
  );
}
```

## Dependencies

This component requires the following packages:

```bash
npm install react-hook-form @hookform/resolvers zod
```

If you're using UI components from a library like shadcn/ui, you'll need those as well.

## Customization Options

### Additional Form Fields

To add more fields, extend the schema and form fields:

```tsx
// Extended schema
const formSchema = z.object({
  // ... existing fields
  age: z.number().min(18, "You must be at least 18 years old"),
  acceptTerms: z.boolean().refine(val => val === true, {
    message: "You must accept the terms and conditions",
  }),
});
```

### Field-Level Validation

For more complex validation:

```tsx
// Password confirmation
const formSchema = z.object({
  password: z.string().min(8),
  confirmPassword: z.string(),
}).refine(data => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"],
});
```

### Async Validation

For server-side validation:

```tsx
// Check if email is already in use
const checkEmailExists = async (email) => {
  const response = await fetch(`/api/check-email?email=${email}`);
  return response.json();
};

// In your component
const validateEmail = async (email) => {
  const { exists } = await checkEmailExists(email);
  if (exists) {
    return "Email is already in use";
  }
  return true;
};

// Use in form setup
form.register("email", { 
  validate: validateEmail 
});
```

## Best Practices

1. **Separate validation logic** from your component for better reusability
2. **Provide meaningful error messages** to guide users
3. **Use controlled inputs** for better form state management
4. **Add loading states** during form submission
5. **Handle errors gracefully** with user-friendly messages
6. **Use proper HTML5 input types** for better mobile experience
7. **Include ARIA attributes** for accessibility