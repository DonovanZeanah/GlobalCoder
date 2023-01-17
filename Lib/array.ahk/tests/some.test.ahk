assert.label("some")

array := [1,2,3,4,5]


assert.label("some - Detect one even number")
assert.true(array.some(func("fn_someIsOdd")))

fn_someIsEven(o)
{
	if (mod(o, 2) = 0) {
		return true
	}
	return false
}

assert.label("some - Detect one odd number")
assert.true(array.some(func("fn_someIsOdd")))

fn_someIsOdd(o)
{
	if (mod(o, 2) = 0) {
		return false
	}
	return true
}

assert.label("some - Fails to find large enough number")
assert.false(array.some(func("fn_someGreaterThan")))

fn_someGreaterThan(o)
{
	if (o > 6) {
		return true
	}
	return false
}