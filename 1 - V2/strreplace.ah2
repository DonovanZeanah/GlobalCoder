sentence := "The cat is cute, and the cat is playful."
newSentence := StrReplace(sentence, "cat", "dog")
MsgBox(newSentence) ; Output: "The dog is cute, and the dog is playful."

text := "R3m0v3_Numb3rs"
newText := StrReplace(text, "3", "")
MsgBox(newText) ; Output: "Rm0v_Numb0rs"

text := "This    is    a    sentence    with    multiple    spaces."
newText := StrReplace(text, "  ", " ")
MsgBox(newText) ; Output: "This is a sentence with multiple spaces."

text := "This is a sentence.//This is another sentence.//This is the last sentence."
newText := StrReplace(text, "//", "`n")
MsgBox(newText)

