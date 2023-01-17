assert.label("slice")

array := [1,2,3,4,5]


assert.label("slice - No args")
assert.test(array.slice(), array)

assert.label("slice - Positive start")
assert.test(array.slice(3), [3,4,5])

assert.label("slice - Positive start & end")
assert.test(array.slice(2, 4), [2,3])

assert.label("slice - Negative start")
assert.test(array.slice(-3), [3,4,5])

assert.label("slice - Negative start & end")
assert.test(array.slice(-2, -1), [4])

assert.label("slice - Positive start & negative end")
assert.test(array.slice(2, -2), [2,3])

assert.label("slice - Negative start & positive end")
assert.test(array.slice(-4, 3), [2])

assert.label("slice - Empty array")
assert.test([].slice(), "")
