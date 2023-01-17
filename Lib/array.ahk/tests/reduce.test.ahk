assert.label("reduce")

names := ["tom", "jerry", "morty", "rick"]
array := [1,2,3,6,4,5]
nested_arrays := [[1,2], [3,4], [4,5]]
complex_array := [new Person(names[1], 22)
	, new Person(names[2], 51)
	, new Person(names[3], 15)
	, new Person(names[4], 55)]


assert.label("reduce - Add all values of array")
assert.equal(array.reduce(func("addition")), 21)

assert.label("reduce - Find maximum value of array")
assert.equal(array.reduce(func("maximum")), 6)

assert.label("reduce - Add all values of array to initial value")
assert.equal(array.reduce(func("addition"), 20), 41)

assert.label("reduce - Sum a property of all objects")
assert.equal(complex_array.reduce(func("objProp_addition").bind("age"), 0), 143)

assert.label("reduce - Copy a string property of all objects into an array")
assert.test(complex_array.reduce(func("objProp_arrayPush").bind("name"), []), names)

assert.label("reduce - Concat nested arrays")
assert.test(nested_arrays.reduce(func("reduce_nestedArray")), [1, 2, 3, 4, 4, 5])
