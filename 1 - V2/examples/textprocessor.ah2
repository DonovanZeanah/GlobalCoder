
processor1 := TextProcessor()

; Add text from key strokes
;processor1.AddTextFromKeyStrokes("Sample text from key strokes")

; Add text from clipboard
processor1.AddTextFromClipboard()

; Add text from screen OCR
;processor1.AddTextFromScreenOCR()

; Add text from a file
;processor1.AddTextFromFile("path/to/your/file.txt")

; Get the processed data array
/*data := processor1.GetData()
for word in data {
    MsgBox(word)
}*/

class TextProcessor {
    data := []

    ; Constructor
    __New() {
        this.data := []
    }

    ; Add text from key strokes
    AddTextFromKeyStrokes(text) {
        this.AddText(text)
    }

    ; Add text from clipboard
    AddTextFromClipboard() {
        if (text := ""){
        msgbox "empty"
        text := clipboard
        }
        msgbox text
        this.data.push(text)
        ;this.AddText(Clipboard)
    }

    ; Add text from screen OCR (using a hypothetical OCR function GetTextFromScreen())
    AddTextFromScreenOCR() {
        ocrText := GetTextFromScreen() ; Replace with an actual OCR function
        this.AddText(ocrText)
    }

    ; Add text from a file
    AddTextFromFile(filePath) {
        try fileText := FileRead(filePath)
        catch {
            ; Handle error if needed (e.g. file not found)
            return
        }
        this.AddText(fileText)
    }

    ; Private method to add text and handle duplicates
    AddText(text) {
        words := StrSplit(text, " ")
        wordsCount := words.Length()

        for index, word in words {
            ; Check for duplicates within a 2-word range
            Loop 5 {
                offset := A_Index - 3
                ; Check if index + offset is within the range of the data array
                if (index + offset > 0) && (index + offset <= wordsCount) {
                    partialWord := words[index + offset]
                    ; If the partial word is found in the data array, skip adding the current word
                    if this.IsWordInData(partialWord) {
                        continue 2
                    }
                }
            }

            ; Add the word to the data array
            this.data.Push(word)
        }
    }
}
