assert.label("reverse")


assert.label("reverse - Reverse even sized int array")
assert.test([1,2,3,4,6,5].reverse(), [5,6,4,3,2,1])

assert.label("reverse - Reverse odd sized int array")
assert.test([1,2,3,4,5].reverse(), [5,4,3,2,1])

assert.label("reverse - Empty array")
assert.test([].reverse(), [])
