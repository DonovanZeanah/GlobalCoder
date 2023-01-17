assert.label("toString")


; test subgroup 1
array := ["a","b","c","d","e","f"]

assert.label("toString - string")
assert.test(array.toString(), "a,b,c,d,e,f")

assert.label("toString - Empty array")
assert.test([].toString(), "")
