
!t::
InputBox, inp, , string to search,, , , , , Font, Timeout, Default

t := findstring(inp,*.*,0,0)


findstring(inp,*.*,0,0)
;{


msgbox,% findstring(inp, "*.ahk")
; edit: changed pattern to filepattern to reduce "confusion".


findstring(string, filepattern = "*.*", rec = 0, case = 0){
    len := strlen(string)
    if (len = 0)
        return
    loop,% filepattern, 0,% rec
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