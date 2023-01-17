array.label("shift")

array := [1,2,3,4,5,6]

assert.label("shift - remove two elements")
array.shift()
assert.test(array, [2,3,4,5,6])
array.shift()
assert.test(array, [3,4,5,6])

assert.label("shift - blank array with no arguments")
assert.test([].shift(), "")

assert.label("shift - No arguments")
arr := []
assert.test(arr, [])
arr.shift()
assert.test(arr, [])
