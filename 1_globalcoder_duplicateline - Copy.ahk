
;Consider this
;- most if not all text editors already have this functionality
;- implimenting it without autohotkey is braindead simple as is
;- why take the trouble

;by implimenting an interface (AHK) between yourself and (ANY) of your
;usual [computer] related task (and some physical), you are given yourself
;a hook into, ultimately, YOUR DATA, YOUR STATS, in real time.

;if I impliment an insert snippet functionality for c# code irrespective of 
;whatever editor im in; ultimately:

;I can say: I used this feature x number of times in 1 month, compared to my
;colleague who microsoft doc lookups the equivalent in a (timed by yourself)
;y number of seconds... saving, for ex, ( manhourwage/3600 ) * N times used * Y saved seconds

*NumpadAdd::
MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
Loop
{
    Sleep, 10
    if !GetKeyState("NumpadAdd", "P")  ; The key has been released, so break out of the loop.
        break
    ; ... insert here any other actions you want repeated.
    MouseClick, left,,, 3, 0, U  ; Release the mouse button.
    send, ^c
    send, {end}{enter}^v
    

}
;MouseClick, WhichButton [, X, Y, ClickCount, Speed, D|U, R]

MsgBox, % "0: `n 3clicked" clipboard
return