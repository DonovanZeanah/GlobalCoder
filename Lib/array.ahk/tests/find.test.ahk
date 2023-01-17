assert.label("find")

assert.label("find - Successful item lookup")
var := [1,2,3,4,5,6].find(func("fn_findGreaterThanFive"))
assert.test(var, 6)

assert.label("find - Unsuccessful item lookup")
var := [1,2,3].find(func("fn_findGreaterThanFive"))
assert.test(var, "")

fn_findGreaterThanFive(o)
{
	if (o > 5) {
		return o
	}
}
