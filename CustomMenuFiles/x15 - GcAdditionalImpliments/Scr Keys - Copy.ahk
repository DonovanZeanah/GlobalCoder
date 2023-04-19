#Include <ScriptDirectives>

#SuspendExempt true
ScrollLock::scr_Reload()
+ScrollLock::scr_Suspend()
#ScrollLock::SystemReboot()
#Pause::SystemPowerDown()
Pause::scr_Test()
!Pause::scr_ExitTest()
#SuspendExempt false

#Include Scr Groups.ahk
#Include Scr Runner.ahk
#Include Scr App.ahk
#Include Scr Mouse.ahk
#Include Scr Win.ahk

;;SPECIAL
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;Alt + number sends the Unicode for a specific Symbol, making that work anywhere. These hotkeys only work in windows that are messengers
;🥺😋🤯😼😎😩🤤👉👈
#y::Symbol("pleading")
#u::Symbol("yum")
#i::Symbol("exploding head")
#o::Symbol("smirk cat")
#p::Symbol("sunglasses")
#sc1a::Symbol("weary")
#sc1b::Symbol("drooling")
#sc2b::Symbol(["finger right", "finger left"])
;😭🧐😳🤨🤔—💀
#6::Symbol("sob")
#7::Symbol("face with monocle")
#8::Symbol("flushed")
#9::Symbol("face with raised eyebrow")
#0::Symbol("thinking")
#-::Symbol("long dash", " ")
#=::Symbol("skull")
;😨😈💜🙄🤝🤷🤓
#F5::Symbol("fearful")
#F6::Symbol("smiling imp")
#F7::Symbol("purple heart")
#F8::Symbol("rolling eyes")
#F9::Symbol("handshake")
#F10::Symbol("shrug")
#F11::Symbol("nerd")

;;REMAPPED IN VSCODE
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#InputLevel 6
#HotIf !WinActive("Visual Studio Code ahk_exe Code.exe")
!Insert::Cut()
^j::Find()

!j::Send("{Down}")
!k::Send("{Up}")
!h::Send("{Left}")
!l::Send("{Right}")

^!h::Send("^{Left}")
^!l::Send("^{Right}")

#HotIf

;;BASE HOTKEYS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+^BackSpace::Send("^{Delete}")
#j::SelectAll()
#h::Paste()
#k::Copy()
Insert:: {
   if press_Hold()
      SelectAll()
}
#Insert::WinPaste()
+!Left::
#^j::Undo()
+!Right::
#^k::Redo()
!BackSpace::Delete
!Tab::Send("^!{Tab}")

;;FULL REMAPS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!Space::return
AppsKey::RCtrl

Launch_Media::return ;F1
Media_Play_Pause::return ;F2
; Media_Stop::return ;F3
Media_Prev::return ;F4
Media_Next::return ;F5
Volume_Mute::return ;F6
; Volume_Up::return ;F7
; Volume_Down::return ;F8
Launch_App1::return ;F9
Launch_Mail::return ;F10
Launch_App2::return ;F11
Browser_Home::return ;F12

NumpadMult::return
NumpadDiv::return
NumpadEnter::return

;;FUNCTIONAL
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
<+Escape::WindowsClock()
#Escape::Infos(GetWeather())

CapsLock::SomeLockHint("CapsLock")
!CapsLock::CloseButActually()
+CapsLock::Counter()

PrintScreen::Screenshot.Start()
#PrintScreen::Screenshot.FullScreenOut()

+!f::CoordGetter()
+!g::WindowGetter()
+!v::tool_RelativeCoordGetter()
^+s::Snake(20, 50, 1.7)
#f::Hider(0x171717)
#b::InternetSearch("Google").TriggerSearch()
RAlt::SoundPlay(Paths.Ptf["vine boom"])

;;MOVING
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Up::win_Maximize()
#Down::win_RestoreDown()
#Right::win_RestoreLeftRight("right")
#Left::win_RestoreLeftRight("left")

#!Up::
#!k::Send("{WheelUp}")
#!Down::
#!j::Send("{WheelDown}")
#!Right::
#!l::Send("{WheelRight}")
#!Left::
#!h::Send("{WheelLeft}")

>^Home::Volume_Up
>^End::Volume_Down
>^Insert::Volume_Mute
>^Delete::Media_Play_Pause
>^PgUp::Media_Prev
>^Pgdn::Media_Next

;;NUMLOCK
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
NumpadDown::scr_Reload()
!NumpadDown::scr_HardReload()
+NumpadDown::scr_Suspend()
#NumpadDown::SystemReboot()

NumpadPgDn::scr_Test()
!NumpadPgDn::scr_ExitTest()

NumpadLeft::Delete
NumpadClear::End
NumpadRight::PgDn
NumpadUp::Home
NumpadPgUp::PgUp

NumpadHome:: {
   if press_Hold()
      SelectAll()
}
#NumpadHome::WinPaste()
!NumpadHome::Cut()
^NumpadHome::Copy()
+NumpadHome::Paste()

NumpadIns & NumpadUp::Volume_Up
NumpadIns & NumpadClear::Volume_Down
NumpadIns & NumpadHome::Volume_Mute
NumpadIns & NumpadLeft::Media_Play_Pause
NumpadIns & NumpadPgUp::Media_Prev
NumpadIns & NumpadRight::Media_Next

NumLock::SomeLockHint("NumLock")

NumpadAdd::WheelUp
NumpadSub::WheelDown
+NumpadAdd::WheelLeft
+NumpadSub::WheelRight

Numpad0::0
Numpad1::1
Numpad2::2
Numpad3::3
Numpad4::4
Numpad5::5
Numpad6::6
Numpad7::7
Numpad8::8
Numpad9::9

#InputLevel 5
Info(A_AhkPath.Replace(Paths.AutoHotkey "\"))
