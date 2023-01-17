assert.label("indexOf")

array := ["a", "b", "c", "d", "d", "d", "e", "e", "f"]


assert.label("indexOf - Get matching index")
assert.test(array.indexOf("d"), 4)

assert.label("indexOf - Get matching index with bad starting index")
assert.test(array.indexOf("d", 999), -1)

assert.label("indexOf - Get matching index with positive starting index")
assert.test(array.indexOf("d", 5), 5)

assert.label("indexOf - Get matching index with negative starting index")
assert.test(array.indexOf("d", -4), 6)

assert.label("indexOf - Empty array")
assert.test([].indexOf("d"), -1)
