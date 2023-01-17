array.label("unshift")

array := [1,2,3,4,5,6]

array.unshift("a", "b")
assert.label("unshift - Add two elements to start of array")
assert.test(array, ["a","b",1,2,3,4,5,6])

assert.label("unshift - blank array with no arguments")
assert.test([].unshift(), 0)

assert.label("unshift - No arguments")
arr := []
assert.test(arr, [])
arr.unshift()
arr.unshift(1)
assert.test(arr, [1])

assert.label("unshift - No arguments")
assert.test([].unshift(), 0)
