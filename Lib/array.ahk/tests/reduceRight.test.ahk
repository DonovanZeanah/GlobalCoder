assert.label("reduceRight")

names := ["tom", "jerry", "morty", "rick"]
myArray := [1,2,3,6,4,5]
nested_arrays := [[1,2], [3,4], [4,5]]
complex_array := [new Person(names[4], 22)
	, new Person(names[3], 51)
	, new Person(names[2], 15)
	, new Person(names[1], 55)]


assert.label("reduceRight - Add all values of array")
assert.equal(myArray.reduceRight(func("addition")), 21)

assert.label("reduceRight - Find maximum value of array")
assert.equal(myArray.reduceRight(func("maximum")), 6)

assert.label("reduceRight - Add all values of array to initial value")
assert.equal(myArray.reduceRight(func("addition"), 20), 41)

assert.label("reduceRight - Sum a property of all objects")
assert.equal(complex_array.reduceRight(func("objProp_addition").bind("age"), 0), 143)

assert.label("reduceRight - Copy a string property of all objects into an array")
assert.arrayEqual(complex_array.reduceRight(func("objProp_arrayPush").bind("name"), []), names)

assert.label("reduceRight - Concat nested arrays")
assert.arrayEqual(nested_arrays.reduceRight(func("reduce_nestedArray")), [4, 5, 3, 4, 1, 2])
