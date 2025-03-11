# AI Actions Example

This directory contains automated actions that AI assistants can perform or reference. These actions can be scripts, workflows, or predefined operations that enhance AI-assisted development.

## Creating New Actions

To create a new action, follow these steps:

1. Create a new file with a descriptive name
2. Define the action's purpose and usage
3. Provide clear implementation instructions
4. Document any required parameters or inputs

## Example: Prompt Enhancement Action

This action demonstrates how AI can help improve prompts for better context and clarity.

```javascript
// Example action implementation
async function enhancePrompt(basePrompt) {
  const enhancements = [
    "relevant code context",
    "specific requirements",
    "error details if applicable",
    "expected outcome"
  ];
  
  let enhancedPrompt = basePrompt + "\n\nPlease include:";
  
  for (const item of enhancements) {
    if (!basePrompt.toLowerCase().includes(item.toLowerCase())) {
      enhancedPrompt += `\n- ${item}`;
    }
  }
  
  return enhancedPrompt;
}
```

## Usage

Reference this action in your AI sessions to improve the quality of your prompts and achieve better assistance from AI tools.