assert.label("values")
array := []


assert.label("values - numbered index")
assert.test([1,2,3].values(), [1,2,3])
assert.test(["a","b","c"].values(), ["a","b","c"])

assert.label("values - character index")
array := []
array.insert("x", "a")
array.insert("y", "b")
array.insert("z", "c")
assert.test(array.values(), ["a","b","c"])
