assert.label("pop")

assert.label("pop - remove one element")
array := [1,2,3]
assert.test(array.pop(), 3)
assert.test(array, [1,2])
