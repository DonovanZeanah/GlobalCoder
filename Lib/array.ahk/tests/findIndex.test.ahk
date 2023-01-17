assert.label("findIndex")

array := [10,22,"ca",334,45,"d"]
array2 := [10,22,123,334,45,"d"]


assert.label("Successful item lookup")
assert.test(3, array.findIndex(func("fn_findIndex")))

assert.label("Unsuccessful item lookup")
assert.test(-1, array2.findIndex(func("fn_findIndex")))

fn_findIndex(o)
{
	if (o == "ca") {
		return true
	}
}
