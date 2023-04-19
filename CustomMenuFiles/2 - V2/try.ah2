#Requires AutoHotkey v2.0

MsgBox RunATP("
(
Hello <?= A_UserName ?>!

Alpha: <?= ctx.Alpha ?>
Bravo: <?= ctx.Bravo ?>
Charlie: <?= ctx.Charlie ?>

<? for i, v in ctx.Array.__Enum() {
	?>Value <?= i ?>: <?= v ?>
<? }
?>
Files in "<?= ctx.Dir ?>":
<? loop files ctx.Dir "\*" {
	?><?= A_LoopFilePath ?>: <?= A_LoopFileSizeKB ?>kb
<? }
?>
end
)", {
	Alpha: "A",
	Bravo: "B",
	Charlie: "C",
	Array: ["One", "Two", "Three"],
	Dir: A_WinDir "\System32\drivers\etc"
})

RunATP(input, context := {}, ahkPath := A_AhkPath) {
    Quote(text) => "'" StrReplace(StrReplace(StrReplace(StrReplace(StrReplace(text,
        "``", "````"), "`r", "``r"), "`n", "``n"), "'", "``'"), ";", "``;") "'"

    ; Convert template to AHK code
    code := "", pos := 1
    while foundPos := RegExMatch(input, "s)<\?\s*(.*?)\s*\?>", &match, pos)
        code .= (
            ; Preceding plaintext
            (foundPos <= pos ? "" : "atp.result .= " Quote(SubStr(input, pos, foundPos - pos)) "`n")
            ; Tag
            (match.1 ~= "^=" ? "atp.result .= (" SubStr(match.1, 2) ")`n" : match.1 "`n")
        ), pos := foundPos + match.Len
    if pos <= StrLen(input) ; Following plaintext
        code .= "atp.result .= " Quote(SubStr(input, pos)) "`n"

    ; Object to pass by COM
    atp := { context: context, result: "" }
    NumPut("Int64", 0x20400, "Int64", 0x46000000000000c0, IID_IDispatch := Buffer(16))
    lResult := DllCall("OleAcc\LresultFromObject", "Ptr", IID_IDispatch, "Ptr", 0, "Ptr", ObjPtr(atp), "Ptr")

    ; Run the sub-script
    try {
        exec := ComObject("WScript.Shell").Exec('"' ahkPath '" *')
        exec.StdIn.Write Format(
            '#NoTrayIcon`n'
            'atp := ((lResult) => (`n'
            '    NumPut("Int64", 0x20400, "Int64", 0x46000000000000c0, IID_IDispatch := Buffer(16)),`n'
            '    DllCall("oleacc\ObjectFromLresult", "Ptr", lResult, "Ptr", IID_IDispatch, "Ptr", 0, "Ptr*", &pObj := 0),`n'
            '    ComValue(9, pObj)`n'
            '))({}), ctx := atp.context`n'
            code,
            lResult)
        exec.StdIn.Close
        while exec.Status = 0
            Sleep 10
    } catch Any as e {
        DllCall "OleAcc\ObjectFromLresult", "Ptr", lResult, "Ptr", IID_IDispatch, "Ptr", 0, "Ptr*", ComValue(9, 0)
        throw e
    }

    return atp.result
}