;*******************************************************
;If you're new to Objects, take a look at our Objects / Classes course
; https://the-Automator.com/Objects
;**************************************
#Requires AutoHotkey v2.0-beta
var input = document.querySelector("._7uiwk._qy55y")
var ev = document.createEvent('Event')
ev.initEvent('keypress')
ev.which = ev.keyCode = 13
input.dispatchEvent(ev)