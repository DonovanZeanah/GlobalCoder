assert.label("includes")

array := [1,2,3,4,5]


assert.label("includes - No args")
assert.true(array.includes(3))

assert.label("includes - Positive fromIndex")
assert.true(array.includes(3, 2))

assert.label("includes - Negative fromIndex")
assert.true(array.includes(3, -4))

assert.label("includes - Negative fromIndex")
assert.false(array.includes(3, -1))
