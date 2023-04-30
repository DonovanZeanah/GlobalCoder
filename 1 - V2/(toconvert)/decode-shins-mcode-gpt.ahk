; Convert C++ code to Base64
code := "int main() { return 0; }"
base64 := CCodeToBase64(code)

; Convert Base64 back to C++ code
decoded := Base64ToCCode(base64)
MsgBox % "" base64encode("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")

Base64Encode(str) {
    ; Load Crypt32.dll
    crypt32 := DllCall("LoadLibrary", "str", "Crypt32.dll", "ptr")

    ; Get a handle to a CryptEncodeObject structure
    DllCall("Crypt32\CryptEncodeObject", "uint", 1, "str", "2.16.840.1.101.3.4.2.1", "ptr", 0, "uint*", len)

    ; Allocate memory for the structure
    p := DllCall("GlobalAlloc", "uint", 0, "uint", len, "ptr")

    ; Create the structure
    DllCall("Crypt32\CryptEncodeObject", "uint", 1, "str", "2.16.840.1.101.3.4.2.1", "ptr", 0, "ptr", p, "uint*", len)

    ; Convert the string to binary
    enc := DllCall("Crypt32\CryptStringToBinary", "str", str, "uint", StrLen(str), "uint", 1, "ptr", 0, "uint*", len, "ptr", 0, "ptr", 0)

    ; Allocate memory for the encoded data
    pEncoded := DllCall("GlobalAlloc", "uint", 0, "uint", len, "ptr")

    ; Encode the binary data
    DllCall("Crypt32\CryptBinaryToString", "ptr", enc, "uint", len, "uint", 1, "ptr", pEncoded, "uint*", len)

    ; Get the encoded data as a string
    encoded := StrGet(pEncoded, len, "UTF-8")

    ; Free memory
    DllCall("GlobalFree", "ptr", pEncoded)
    DllCall("GlobalFree", "ptr", p)
    DllCall("FreeLibrary", "ptr", crypt32)

    return encoded
}

Base64Decode(base64) {
    enc := ComObjCreate("System.Text.Encoding").GetEncoding("UTF-8")
    data := ComObjCreate("System.Array", StrLen(base64) * 0.75)
    len := DllCall("Crypt32\CryptStringToBinary", "str", base64, "uint", 0, "uint", 1, "ptr", 0, "uint*", 0, "ptr", 0, "ptr", 0)
    DllCall("Crypt32\CryptStringToBinary", "str", base64, "uint", 0, "uint", 1, "ptr", &data, "uint*", len, "ptr", 0, "ptr", 0)
    return enc.GetString(&data, len, "utf-8")
}

CCodeToBase64(code) {
    ; Convert string to binary data using UTF-8 encoding
    binary := StrPut(code, "UTF-8")
    
    ; Encode binary data as Base64 string
    base64 := Base64Encode(binary)
    
    return base64
}
Base64ToCCode(base64) {
    ; Decode Base64 string into binary data
    binary := Base64Decode(base64)
    
    ; Convert binary data to string using UTF-8 encoding
    code := StrGet(binary, "UTF-8")
    
    return code
}



/*
DecodeCode(base64String) {
    enc := ComObjCreate("System.Text.Encoding").GetEncoding("UTF-8")
    decoded := enc.GetString(ComObjArray(VarSetCapacity(bin, StrLen(base64String) / 4 * 3), true, base64String, "utf-8").Clone().ToArray())
    enc := ""
    lines := []
    Loop, Parse, decoded, `n
    {
        line := Trim(A_LoopField)
        if (line == "")
            continue
        if (RegExMatch(line, "^(.*) = {(.*?)}", m))
        {
            name := m1
            values := StrSplit(m2, ", ")
            result := name " = \"""
            Loop, % values.Length()
            {
                if (A_Index == 1)
                    result .= Chr("0x" . SubStr(values[A_Index], 3))
                else
                    result .= "\" . Chr("0x" . SubStr(values[A_Index], 3))
            }
            result .= "\"""
            lines.Insert(result, 1)
        }
        else
        {
            lines.Insert(line, 1)
        }
    }
    return lines.Join("`r`n")
}
base64String := "JHU9JDF8MTB8YmFzZTY0fENoYXJDbGFzczokMTB8aW5kZXg6JDEyMw=="
code := DecodeCode(base64String)
MsgBox % code



*/

/*
res := ctob64()
msgbox, % "`n" res
CtoB64()
{
    clip := Clipboard
    if (clip = "")
        return

    ; Convert the C++ code to binary.
    bin := ""
    Loop, Parse, clip, `n
    {
        ; Remove whitespace from the beginning and end of the line.
        line := Trim(A_LoopField)

        ; Skip empty lines and lines that start with a comment.
        if (line = "" || SubStr(line, 1, 2) = "//")
            continue

        ; Convert the line to binary.
        bin .= StrPut(line . "`n", "UTF-8")
    }

    ; Encode the binary as Base64.
    enc := ComObjCreate("System.Text.Encoding").GetEncoding("UTF-8")
    b64 := enc.EncodeToString(bin)
    enc := ""

    return b64
}
B64toC(b64)
{
    ; Decode the Base64 string.
    enc := ComObjCreate("System.Text.Encoding").GetEncoding("UTF-8")
    bin := enc.DecodeBase64(b64)
    enc := ""

    ; Convert the binary to text.
    text := StrGet(bin, "UTF-8")
    bin := ""

    ; Format the text as C++ code.
    code := ""
    Loop, Parse, text, `n
    {
        ; Add whitespace at the beginning of the line.
        line := "    " . A_LoopField

        ; Remove whitespace from the end of the line.
        line := RTrim(line)

        ; Add a semicolon if the line doesn't already end with one.
        if (SubStr(line, -1) != ";")
            line .= ";"

        ; Add the line to the code.
        code .= line . "`n"
    }

    return code
}

*/







/*code := "32|TVqQAAMAAAAEAAAA//8AALgAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
p := Mcode(code)
if (p) {
    DllCall("VirtualProtect", "ptr", p, "UInt", 0, "UInt", 0x40, "UInt*", op) ; make memory executable
    DllCall("CallWindowProc", "ptr", p, "ptr", 0, "ptr", 0, "UInt", 0, "UInt", 0) ; execute the code
}

Mcode(str) {
    s := strsplit(str,"|")
    if (s.length() != 2)
        return
    if (!DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", 0, "uint*", pp, "ptr", 0, "ptr", 0))
        return
    p := DllCall("GlobalAlloc", "uint", 0, "ptr", pp, "ptr")
    if (this.bits)
        DllCall("VirtualProtect", "ptr", p, "ptr", pp, "uint", 0x40, "uint*", op)
    if (DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", p, "uint*", pp, "ptr", 0, "ptr", 0))
        return p
    DllCall("GlobalFree", "ptr", p)
}
*/
/*mcode := "#bits=32|207|0|174|76|203|87|16|0|0|208|134|141|0|0|0|198|5|68|9|0|0|108|142|16|32|35|0|0|0|0|109|87|41|130|0|0|0|0|49|192|32|16|0|0|0|0|16|245|0|0|0|0|0|0|0|0|12|41|17|215|124|238|201|10|110|8|69|4|210|68|100|63|226|84|67|90|120|181|181|220|223|214|57|67|233|58|63|177|97|180|142|52|68|218|78|200|2|232|223|206|73|116|12|150|175|49|120|247|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0"

result := DecodeMCode(mcode)
msgbox, % "result : `n " result

DecodeMcode(mcode) {
    decoded := ""
    Loop, Parse, mcode, `n
    {
        if (A_LoopField ~= "^\s*$")
            continue
        if (SubStr(A_LoopField, 1, 2) == "//")
            continue
        hex := ""
        Loop, Parse, A_LoopField, `t
        {
            if (A_Index == 1)
                continue
            hex .= "0x" . A_LoopField . ","
        }
        hex := SubStr(hex, 1, -2)
        decoded .= hex . ","
    }
    decoded := SubStr(decoded, 1, -2)
    count := StrLen(decoded) / 2
    output := "unsigned char shellcode[" . count . "] = {\r\n"
    Loop, Parse, decoded, `,
    {
        if (%A_Index% 16 == 1 && A_Index != 1)
            output .= "\r\n"
        output .= A_LoopField . ","
    }
    output := SubStr(output, 1, -2) . "\r\n};"
    return output
}

*/

/*mybase64String := "VVdWU4PsRItEJGSLTCRYi1wkXItUJGCJRCQ4i0QkXA+3SQiLWwSLOIn4iXwkMMH4EIlEJDxmOcEPhpwFAACLRCRYD7dACmY5+A+GiwUAAIn9D7f/iUwkCMHtECn4iXwkDCnpiUQkLIlMJCCE0g+EWgEAAIXbD4SVAgAAi0QkLIXAD458AgAAi0QkCMdEJDQAAAAAx0QkKAAAAADB4AKJbCQEiUQkFI0ErQAAAACJRCQYD7bCicWLRCQghcAPjiYCAACLRCQ0x0QkHAAAAACJRCQkjbYAAAAAi3wkDIX/D4S0AAAAi0QkJIt8JFzHRCQQAAAAAIlEJAiQjbQmAAAAAIt0JASF9nRxMcmNtgAAAACLXI8Igfv////+dlSLdCRYjQSNAAAAAAMGi3QkCIsEMInewf4QicLB+hAPttKJFCSJ8g+28osUJCnyidbB/h8x8inyOeoPj3UBAAAPtsQPtt8p2Jkx0CnQOcUPjGABAACDwQE5TCQEdZeDRCQQAYtMJBSLRCQQAUwkCAN8JBg5RCQMD4Vo////gHwkOAAPhCQEAAAPt0QkPIt8JBwPt1QkMGbR6AH4ZtHqweAQD7fSA0QkKIPERFsB0F5fXcOF2w+E0wIAAIXAD44mAQAAx0QkFAAAAACJLCSLbCRYi0wkIIXJD46UAgAAx0QkEAAAAADrMo22AAAAAItNAI0cBoHi////AIsMmYHh////ADnKdFuDRCQQAYtEJBA5RCQgD4RYAgAAi1QkDIXSdFfHRCQEAAAAAIsEJIXAdDmL"
decodedString := DecodeBase64(myBase64String)
MsgBox % decodedString

DecodeBase64(base64String)
{
    base64 := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    output := ""
    bytes := []
    charCount := 0

    For i, char In StrSplit(base64String)
    {
        value := InStr(base64, char) - 1
        If value >= 0
        {
            charCount++
            bytes.Push(value)
            If Mod(charCount, 4) = 0
            {
                output .= Chr(bytes[1] << 2 | bytes[2] >> 4)
                If bytes.Length() > 2
                {
                    output .= Chr(bytes[2] << 4 | bytes[3] >> 2)
                    If bytes.Length() > 3
                        output .= Chr(bytes[3] << 6 | bytes[4])
                }
                bytes := []
            }
        }
    }

    Return output
}

*/

/*
msgbox, % "result: `n" DecodeBase64(encodedString)
DecodeBase64(encodedString) {
    base64Decode := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    decodedString := ""
    modulus := 0
    value := 0
    for i, char in StrSplit(encodedString, "") {
        index := InStr(base64Decode, char) - 1
        if (index >= 0) {
            value := (value << 6) | index
            modulus := Mod(modulus + 1, 4)
            if (modulus = 0) {
                decodedString .= Chr(value >> 16) Chr(value >> 8 & 0xFF) Chr(value & 0xFF)
                value := 0
            }
        }
    }
    if (modulus = 2) {
        decodedString .= Chr(value >> 10)
    } else if (modulus = 3) {
        decodedString .= Chr(value >> 16) Chr(value >> 8 & 0xFF)
    }
    return decodedString
}
*/

/*DecodeBase64(encodedString)
{
    global
    If !isobject(base64)
        base64 := ComObjCreate("System.Text.Encoding").GetEncoding("UTF-8")

    bytes := base64.DecodeString(encodedString)
    If !IsObject(bytes)
        Return ""

    decoded := ""
    loop % bytes.maxindex()
    {
        decoded .= Chr(bytes[A_Index])
    }
    return decoded
}

InputBox, encodedString, Base64 Decoder, Enter the encoded string to decode:
decodedString := base64decode(encodedString, "UTF-8")
;decodedString := DecodeBase64(encodedString)
MsgBox, %decodedString%
*/

;======================================================================
/*InputBox, inputString, Enter a string to decode, , 300, 200
decodedString := StrReplace(inputString, "|", "")
decodedString := DecodeBase64(decodedString)
FileAppend, %decodedString%, output.txt
Run, notepad.exe output.txt

DecodeBase64(base64String) {
    ; Create a ComObject for decoding base64
    decoder := ComObjCreate("MSXML2.DOMDocument.6.0")
    ; Set the base64 data as the node value
    decoder.documentElement.dataType := "bin.base64"
    decoder.documentElement.text := base64String
    ; Return the decoded binary data as a string
    return decoder.documentElement.nodeTypedValue
}

*/