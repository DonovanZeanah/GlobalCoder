SetBatchLines, -1
#SingleInstance, force
#NoTrayIcon
#Include %A_ScriptDir%\..\export.ahk

assert := new unittesting()
#Include %A_ScriptDir%\concat.test.ahk
#Include %A_ScriptDir%\every.test.ahk
#Include %A_ScriptDir%\fill.test.ahk
#Include %A_ScriptDir%\filter.test.ahk
#Include %A_ScriptDir%\find.test.ahk
#Include %A_ScriptDir%\findIndex.test.ahk
#Include %A_ScriptDir%\forEach.test.ahk
#Include %A_ScriptDir%\includes.test.ahk
#Include %A_ScriptDir%\indexOf.test.ahk
#Include %A_ScriptDir%\join.test.ahk
#Include %A_ScriptDir%\keys.test.ahk
#Include %A_ScriptDir%\lastIndexOf.test.ahk
#Include %A_ScriptDir%\map.test.ahk
#Include %A_ScriptDir%\pop.test.ahk
#Include %A_ScriptDir%\push.test.ahk
#Include %A_ScriptDir%\reduce.test.ahk
#Include %A_ScriptDir%\reduceRight.test.ahk
#Include %A_ScriptDir%\reverse.test.ahk
#Include %A_ScriptDir%\shift.test.ahk
#Include %A_ScriptDir%\slice.test.ahk
#Include %A_ScriptDir%\some.test.ahk
#Include %A_ScriptDir%\sort.test.ahk
#Include %A_ScriptDir%\splice.test.ahk
#Include %A_ScriptDir%\toString.test.ahk
#Include %A_ScriptDir%\unshift.test.ahk
#Include %A_ScriptDir%\values.test.ahk

assert.fullReport()

#Include %A_ScriptDir%\..\node_modules
#Include unit-testing.ahk\export.ahk

ExitApp



; common functions used in some tests
addition(a, b) {
	return a + b
}

subtract(a, b) {
	return a - b
}

multiply(a, b) {
	return a * b
}

isEven(num, prms*) {
	return (mod(num, 2) = 0)
}

isOdd(num, prms*) {
	return (mod(num, 2) = 1)
}

maximum(a, b) {
	return ((a > b) ? a : b)
}

complex_sort(get_fn, a, b) {
	aVal := get_fn.Call(a)
	bval := get_fn.Call(b)
	return aVal > bval ? 1 : aVal < bval ? -1 : 0
}

objProp_addition(prop, total, obj) {
	return total + obj[prop]
}

objProp_arrayPush(prop, array, obj) {
	array.push(obj[prop])
	return array
}

objProp_get(key, obj, prms*) {
	return obj[key]
}

reduce_nestedArray(previousValue, currentValue) {
	 return previousValue.concat(currentValue)
}


; classes used in some tests
class Person {

	__New(name, age) {
		this.name := name
		this.age := age
	}

	getName() {
		return this.name
	}
	
	getAge() {
		return this.age
	}
}
