assert.label("keys")
array := []


assert.label("keys - numbered index")
assert.test([1,2,3].keys(), [1,2,3])
assert.test(["a","b","c"].keys(), [1,2,3])

assert.label("keys - character index")
array := []
array.insert("a", 1)
array.insert("b", 1)
array.insert("c", 1)
assert.test(array.keys(), ["a","b","c"])
