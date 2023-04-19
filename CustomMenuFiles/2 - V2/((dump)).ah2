#warn all, off


myObj := Object()
myObj.__Get := Func("GetProperties")
myObj.func := myFunc

while propName := myObj.func.__Get.NextProperty() {
    MsgBox "Property Name: " propName
}

GetProperties(obj, propName) {
    return obj.__GetProperties[propName]
}

myFunc() {
    ; function code here
}


/*In this example, myFunc() is defined as a function, and the __Get meta-method is set to a function object named GetProperties(). The __Get() method is called whenever a property of the myFunc() object is accessed.

The while loop is used to enumerate the properties of the function object. The NextProperty() method is called to get the next property name of the object. If there are no more properties, the loop exits.

The GetProperties() function is called by __Get() to retrieve the value of the requested property. In this example, GetProperties() returns the value of the __GetProperties object, which contains the properties of the function object.

Keep in mind that this method only works for object properties, not for variables or other values. Also note that this method may not be the most efficient way to enumerate object properties, especially for large objects with many properties.
*/




