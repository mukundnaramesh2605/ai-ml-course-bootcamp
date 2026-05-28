var first = 1
var second = 2
var third = 0
console.log(first || third) // 1
console.log(third || second) // 2
console.log(first && second) // 2
console.log(first && third) // 0