group.label("fill")
array := [0,0,0,0]

group.label("No args")
array.fill(1)
assert.test([1, 1, 1, 1], array)

group.label("Positive start")
array.fill(5, 2)
assert.test([1, 5, 5, 5], array)

group.label("Positive start & end")
array.fill("A", 1, 2)
assert.test(["A", "A", 5, 5], array)

group.label("Negative start")
array.fill(":D", -2)
assert.test(["A", "A", ":D", ":D"], array)

group.label("Negative start & end")
array.fill(1, -4, -2)
assert.test([1, 1, ":D", ":D"], array)
