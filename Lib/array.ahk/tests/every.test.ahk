assert.label("every")
array_even := [2,4,6]
array_odd := [1,3,5,7]

assert.label("every - Function object")
assert.true(array_even.every(func("fn_everyIsEven")))
assert.false(array_odd.every(func("fn_everyIsEven")))

fn_everyIsEven(o)
{
	if (mod(o, 2) = 0) {
		return true
	}
	return false
}

assert.label("every - Function object every odd")
assert.true(array_odd.every(func("fn_everyIsOdd")))

fn_everyIsOdd(o)
{
	if (mod(o, 2) = 0) {
		return false
	}
	return true
}

assert.label("every - Bound function object")
