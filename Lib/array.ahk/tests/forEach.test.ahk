assert.label("forEach")

global forEach_sum := 0

nums := [1,2,3,4,5]
nums.forEach(func("fn_forEach_addToSum"))

group.label("forEach - Act on global variable for result")
assert.test(forEach_sum, 1+2+3+4+5)

; object scenario
objs := [{msg: "bye"}, {msg: "nope"}]
objs.forEach(func("fn_forEach_setMsgToHi"))
array := []

for i,obj in objs
	array.push(obj.msg)

group.label("forEach - Change property of each object")
assert.test(array, ["hi", "hi"])


fn_forEach_addToSum(int) {
	forEach_sum += int
}

fn_forEach_setMsgToHi(element, index, array) {
	array[index].msg := "hi"
}

group.label("forEach - Return undefined")
assert.test(array.forEach(func("fn_forEach_setMsgToHi")), "")
