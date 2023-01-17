assert.label("map")

arrayInt := [1, 5, 10]
arrayObj := [{"name": "bob", "age": 22}, {"name": "tom", "age": 51}]


assert.label("map - Double integer values")
assert.test(arrayInt.map(func("multiply").bind(2)), [2, 10, 20])

assert.label("map - Strip object down to single property")
assert.test(arrayObj.map(func("objProp_get").bind("name")), ["bob", "tom"])
