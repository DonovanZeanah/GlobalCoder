class FuncArrayType extends Array {
    Call(params*) {
        ; Call a list of functions.
        for fn in this
            fn(params*)
    }
}

; Create an array of functions.
funcArray := FuncArrayType()
; Add some functions to the array (can be done at any point).
funcArray.Push(One)
funcArray.Push(Two)
; Create an object which uses the array as a method.
obj := {method: funcArray}
; Call the method (and consequently both One and Two).
obj.method("2nd")
; Call it as a function.
(obj.method)("1st", "2nd")

One(param1, param2) {
    ListVars
    MsgBox
}
Two(param1, param2) {
    ListVars
    MsgBox
}