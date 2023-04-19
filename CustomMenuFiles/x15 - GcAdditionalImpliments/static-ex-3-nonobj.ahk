global MyClass ;// Make 'MyClass' super-global

;// Another way of declaring a 'class' / prototype object
;// The advantage of the class syntax is it gets processed during 'compilation'.
;// Hence, error(s) are detected + other advantage(s) of pre-processing.
MyClass := {
(Join Q C
	"__Class":   "MyClass",
	"__Init":    "InitInstanceVars",
	"__New":     "Constructor",
	"__Get":     "Getter",
	"__Set":     "Setter",
	"class_var": "Value of class var" ;// equivalent to: static class_var := "Value of class var"
)}

;// create an instance of MyClass
instance1 := new MyClass

;// Class vars can be accessed by all instances of the class
;// But instance(s) do not have the key 'class_var', their
;// base object, MyClass, has the key.

;// What happens is, an unknown key is being accessed,
;// this triggers __Get (Getter), if the object (instance) has a base,
;// a look-up will occur to check if base (MyClass) has the key.
;// If the key exists in base, return its value
;// -> I may be wrong about the sequence of calls, but that's how I understand it
MsgBox % instance1.class_var ;// triggers Getter

;// Set instance property
;// This key and its value is unique to this instance only (in this case)
instance1.property := "Value of property"

;// Create another instance
instance2 := new MyClass

;// Instance vars can be accessed by all instances of the class
;// Same goes for class vars.
;// However the class object ('MyClass' in this case), cannot access
;// the instance var(s)
;// Altering the value of an instance var for a specific instance
;// does not affect its value for other instances. It behaves like
;// 'property' above.
MsgBox % instance2.instance_var

;// Here we see that 'property' key is unique to instance1
MsgBox % instance2.HasKey("property")
return

InitInstanceVars(this) {
	this.instance_var := "Value of instance var"
	MsgBox Instance var(s) created
}

Constructor(this, args*) {
	;// this.__Class will trigger Getter
	MsgBox % "Instance of class: " this.__Class " created"
}

Getter(this, key, p*) {
	MsgBox % "Unknown key being accessed: " key
}

Setter(this, key, val, p*) {
	MsgBox % "Setting value of unknown key: '" key "' to: '" val "'"
}