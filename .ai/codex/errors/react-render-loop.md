# Error: React Render Loop

## Context
This error occurs when React components enter an infinite re-rendering cycle, typically caused by improperly configured state updates or effect dependencies.

## Symptoms
- Browser becomes unresponsive
- Console shows excessive renders warning
- High CPU usage
- Memory leaks
- Application crashes

## Root Causes
1. **Incorrect useEffect dependencies**
   - Missing dependencies in dependency array
   - Including unstable references in dependency array

2. **State updates in render phase**
   - Setting state directly in component body
   - Updating state in render without condition

3. **Props changing on every render**
   - Passing new object/array/function references on each render

## Solutions

### For useEffect Issues
```jsx
// ❌ Problematic code
useEffect(() => {
  fetchData();
}, [fetchData]); // fetchData is recreated each render

// ✅ Fixed with useCallback
const fetchData = useCallback(() => {
  // implementation
}, [/* stable dependencies */]);

useEffect(() => {
  fetchData();
}, [fetchData]);
```

### For State Updates in Render
```jsx
// ❌ Problematic code
function MyComponent() {
  const [count, setCount] = useState(0);
  setCount(count + 1); // ❌ Will cause infinite loop
  return <div>{count}</div>;
}

// ✅ Fixed with useEffect
function MyComponent() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    setCount(count + 1);
  }, []); // Empty dependency array means "run once"
  
  return <div>{count}</div>;
}
```

### For Unstable Props
```jsx
// ❌ Problematic code
function ParentComponent() {
  return <ChildComponent options={{foo: 'bar'}} />; // New object on every render
}

// ✅ Fixed with useMemo
function ParentComponent() {
  const options = useMemo(() => ({foo: 'bar'}), []);
  return <ChildComponent options={options} />;
}
```

## Prevention Strategies
1. Use React DevTools Profiler to identify excessive re-renders
2. Apply the React lint rule `react-hooks/exhaustive-deps`
3. Memoize objects, arrays, and functions with useMemo and useCallback
4. Use the React.memo HOC for components that render often but with the same props
5. For complex state updates, consider using useReducer instead of useState

## Related Resources
- [React Docs: useEffect](https://reactjs.org/docs/hooks-effect.html)
- [React Docs: Hooks FAQ](https://reactjs.org/docs/hooks-faq.html#performance-optimizations)
- [React Docs: useMemo](https://reactjs.org/docs/hooks-reference.html#usememo)