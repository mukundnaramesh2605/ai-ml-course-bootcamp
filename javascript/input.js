function factorial(n) {
    if (n < 0) return undefined; // Factorials aren't defined for negative numbers
    if (n === 0 || n === 1) return 1;
    return n * factorial(n - 1);
}

// Example usage:
console.log(factorial(3)); // Output: 120

function fibonacci(n) {
    if (n < 0) return undefined; // Fibonacci isn't defined for negative numbers
    if (n === 0) return 0;
    if (n === 1) return 1;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// Example usage:
console.log(fibonacci(10)); // Output: 55               

function isPrime(num) {
    if (num <= 1) return false; // 0 and 1 are not prime numbers
    for (let i = 2; i <= Math.sqrt(num); i++) {
        if (num % i === 0) return false; // If divisible by any number other than 1 and itself, it's not prime
    }
    return true; // If it passes the loop, it's a prime number
}

// Example usage:
console.log(isPrime(7)); // Output: true
console.log(isPrime(10)); // Output: false  
function reverseString(str) {
    return str.split('').reverse().join('');
}

// Example usage:
console.log(reverseString("Hello, World!")); // Output: "!dlroW ,olleH"         
function isPalindrome(str) {
    const cleanedStr = str.replace(/[^A-Za-z0-9]/g, '').toLowerCase();
    return cleanedStr === cleanedStr.split('').reverse().join('');
}

// Example usage:
console.log(isPalindrome("A man, a plan, a canal, Panama")); // Output: true
console.log(isPalindrome("Hello")); // Output: false        
function sumArray(arr) {
    return arr.reduce((acc, curr) => acc + curr, 0);
}

// Example usage:
console.log(sumArray([1, 2, 3, 4, 5])); // Output: 15   
function findMax(arr) {
    return Math.max(...arr);
}

// Example usage:
console.log(findMax([1, 2, 3, 4, 5])); // Output: 5
function findMin(arr) {
    return Math.min(...arr);
}

// Example usage:
console.log(findMin([1, 2, 3, 4, 5])); // Output: 1
function average(arr) {
    if (arr.length === 0) return undefined; // Avoid division by zero
    return sumArray(arr) / arr.length;
}

// Example usage:
console.log(average([1, 2, 3, 4, 5])); // Output: 3  
   
function countOccurrences(arr, value) {
    return arr.reduce((count, current) => (current === value ? count + 1 : count), 0);
}

// Example usage:
console.log(countOccurrences([1, 2, 3, 4, 5, 2], 2)); // Output: 2