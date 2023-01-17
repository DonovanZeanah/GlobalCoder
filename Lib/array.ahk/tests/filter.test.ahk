assert.label("filter")

array := [1,2,3,4,5,6]

assert.label("Collect even numbers")
assert.test(array.filter(func("fn_filterIsEven")), [2,4,6])
assert.label("Collect odd numbers")
assert.test(array.filter(func("fn_filterIsOdd")), [1,3,5])

fn_filterIsEven(o) {
	if (mod(o, 2) = 0) {
		return true
	}
	return false
}

fn_filterIsOdd(o) {
	if (mod(o, 2) = 0) {
		return false
	}
	return true
}
