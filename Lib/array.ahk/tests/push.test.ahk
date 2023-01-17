assert.label("push")


assert.label("push - add one element")
array := [1,2,3]
assert.test(array.push(4), 4)
assert.test(array, [1,2,3,4])

assert.label("push - add multiple elements")
array := [1,2,3]
assert.test(array.push(4, 5), 5)
assert.test(array, [1,2,3,4,5])

assert.label("push - empty array")
array := []
assert.test(array.push(1, 2, 3), 3)
assert.test(array, [1,2,3])

assert.label("push - empty array, empty argument")
array := []
assert.test(array.push(), 0)
assert.test(array, [])