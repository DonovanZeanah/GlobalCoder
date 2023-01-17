assert.label("join")

array := [1,2,3,4,5]


assert.label("join - Join elements with newlines")
assert.test(array.join("`n"), "1`n2`n3`n4`n5")

assert.label("join - Join elements with commas")
assert.test(array.join(), "1,2,3,4,5")

assert.label("join - Empty array")
assert.test([].join(), "")
assert.test([].join(" "), "")
