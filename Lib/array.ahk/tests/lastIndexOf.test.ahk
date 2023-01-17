assert.label("lastIndexOf")

array := ["a", "b", "c", "d", "d", "d", "e", "e", "f"]


assert.label("lastIndexOf - Get matching last index")
assert.test(array.lastIndexOf("d"), 6)

assert.label("lastIndexOf - Get matching last index with bad starting index")
assert.test(array.lastIndexOf("d", 999), -1)

assert.label("lastIndexOf - Get matching last index with positive starting index")
assert.test(array.lastIndexOf("d", 3), 6)

assert.label("lastIndexOf - Get matching last index with negative starting index")
assert.test(array.lastIndexOf("d", -5), 6)
