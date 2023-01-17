assert.label("splice")


; test subgroup 1
array := ["a","b","c","d","e","f"]
spliced := array.splice(3)

assert.label("splice - array")
assert.test(array, ["a","b"])

assert.label("splice - Starting position only")
assert.test(spliced, ["c","d","e","f"])


; test subgroup 2
array := ["a","b","c","d","e","f"]
spliced := array.splice(3, 2)

assert.label("splice - array")
assert.test(array, ["a","b","e","f"])

assert.label("splice - Starting position with delete")
assert.test(spliced, ["c","d"])


; test subgroup 3
array := ["a","b","c","d","e","f"]
spliced := array.splice(3, 0)

assert.label("splice - array")
assert.test(array, ["a","b","c","d","e","f"])

assert.label("splice - Starting position no delete")
assert.test(spliced, [])


; test subgroup 4
array := ["a","b","c","d","e","f"]
spliced := array.splice(3, 2, "g", "h")

assert.label("splice - array")
assert.test(array, ["a","b","g","h","e","f"])

assert.label("splice - Starting position with delete and args")
assert.test(spliced, ["c","d"])


; test subgroup 5
array := ["a","b","c","d","e","f"]
spliced := array.splice(3, 0, "g", "h")

assert.label("splice - array")
assert.test(array, ["a","b","g","h","c","d","e","f"])

assert.label("splice - Starting position no delete and args")
assert.test(array.splice(3, 0, "test"), [])
