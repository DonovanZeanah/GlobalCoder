if _input ~= "2|3|4|5|6|8|9"
; or
if (_input ~= "2|3|4|5|6|8|9")

keys := { ""
    . v: "✅"
    , x: "❌"
    , a: "😀"
    , b: "😁"
    , c: "😂" }

Input _input, L1,, 2,3,4,5,6,7,8,9,v,a,b,c
if (ErrorLevel = "Match")
    Send % "{" A_PriorKey "}"
else if (_input ~= "[2-9]")
    Msgbox Triggered
else
    Send % "{BS}" keys[_input]

