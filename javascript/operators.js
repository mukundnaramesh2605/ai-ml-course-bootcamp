var first = 1
var second = 2
var third = 0
console.log(first || third) // 1
console.log(third || second) // 2
console.log(first && second) // 2
console.log(first && third) // 0

//comparison operators
var a = 5
var b = 10
console.log(a > b) // false
console.log(a < b) // true
console.log(a >= b) // false
console.log(a <= b) // true
console.log(a == b) // false
console.log(a != b) // true

//logical operators
var x = true
var y = false
console.log(x && y) // false
console.log(x || y) // true
console.log(!x) // false
console.log(!y) // true

//bitwise operators
var m = 5 // 0101 in binary
var n = 3 // 0011 in binary 
console.log(m & n) // 1 (0001 in binary)    
console.log(m | n) // 7 (0111 in binary)
console.log(m ^ n) // 6 (0110 in binary)
console.log(~m) // -6 (inverts bits of m)
console.log(m << 1) // 10 (0101 shifted left by 1)
console.log(m >> 1) // 2 (0101 shifted right by 1)  