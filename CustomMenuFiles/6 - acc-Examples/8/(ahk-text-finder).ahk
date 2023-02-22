
!t::
InputBox, folder, , string to search,, , , , , Font, Timeout, Default
InputBox, inp, , string to search,, , , , , Font, Timeout, Default

t := findstring(inp,folder "*.ahk", "R")


;findstring(inp,*.*,1,F)
;{


msgbox, % t
msgbox,% findstring(inp, folder "*.ahk", "R")
; edit: changed pattern to filepattern to reduce "confusion".

return 
findstring(string, filepattern = "*.*", rec = "R"){
    msgbox, % filepattern
    msgbox, % rec

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