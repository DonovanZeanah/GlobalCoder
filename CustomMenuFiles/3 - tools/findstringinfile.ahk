
!t::
InputBox, folder, , folder path no ending'/',, , , , , Font, Timeout, d:\(github)\globalcoder\gc\globalcoder
InputBox, inp, , string to search,, , , , , Font, Timeout, Default
inputbox, rec ,, (F)iles(D)irs(R)ecurse Options,, ,,,, F

class querybuilder(){
    static folder := {}
    static String := {}
    static options := {}

    __new(){
InputBox, folder, , folder path no ending'/',, , , , , Font, Timeout, d:\(github)\globalcoder\gc\globalcoder
InputBox, inp, , string to search,, , , , , Font, Timeout, Default
inputbox, rec ,, (F)iles(D)irs(R)ecurse Options,, ,,,, F
this.folder := folder
this.string := folder 
this.options := options
    }
}


t := findstring(inp,folder "\*.ahk", rec)


;findstring(inp,*.*,1,F)
;{


msgbox, % t
msgbox, % findstring(inp, folder "*.ahk", "R")
; edit: changed pattern to filepattern to reduce "confusion".

return 
findstring(string, filepattern = "*.*", rec = "FDR"){
    ;msgbox, % filepattern
    ;msgbox, % rec

    len := strlen(string)
    if (len = 0)
        return
    loop, files, % filepattern, % rec
    {
        fileread, x,% a_loopfilefullpath
        if (pos := instr(x, string, case)){
            positions .= a_loopfilefullpath "|" pos
            while(pos := instr(x, string, case, pos+len))
                positions .= "|" pos
            positions .= "`n"
        }
    }
    return, positions
}