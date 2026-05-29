function factorial(n) {
    if (n < 0) return undefined; // Factorials aren't defined for negative numbers
    if (n === 0 || n === 1) return 1;
    return n * factorial(n - 1);
}

// Example usage:
console.log(factorial(3)); // Output: 120
