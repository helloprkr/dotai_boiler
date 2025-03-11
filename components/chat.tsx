"use client";

import { useState } from "react";
import { generateChatCompletion } from "@/ai/actions/chat";

export function ChatInterface() {
  const [prompt, setPrompt] = useState("");
  const [response, setResponse] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    try {
      const result = await generateChatCompletion(prompt);
      setResponse(result || "No response received.");
    } catch (error) {
      setResponse("Error: Failed to generate response.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="max-w-md mx-auto p-4">
      <form onSubmit={handleSubmit}>
        <textarea
          value={prompt}
          onChange={(e) => setPrompt(e.target.value)}
          className="w-full p-2 border rounded"
          placeholder="Enter your prompt..."
          required
        />
        <button
          type="submit"
          className="mt-2 w-full px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
          disabled={isLoading}
        >
          {isLoading ? "Generating..." : "Submit"}
        </button>
      </form>
      {response && (
        <div className="mt-4 p-4 border rounded bg-gray-50">
          <h2 className="font-bold mb-2">Response:</h2>
          <p>{response}</p>
        </div>
      )}
    </div>
  );
} 