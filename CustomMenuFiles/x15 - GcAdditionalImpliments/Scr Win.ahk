#Include <Win>
#Include <Global>
#Include <Links>
#Include <Tools\Info>
#Include <Press>
#Include <Paths>

#MaxThreadsBuffer true

#m::RunLink(Links["gmail"])
#sc33::RunLink(Links["ghm"])
#sc34::RunLink(Links["regex"])

#n::win_App("Monkeytype " Browser.exeTitle, Paths.Apps["Monkeytype"])

<!r::win_App("ahk_group Terminal",    Paths.Apps["Terminal"])
<!s::win_App(Spotify.winTitle,        Paths.Apps["Spotify"])
<!x::win_App("AutoHotkey v2 Help",    Paths.Apps["Ahk v2 docs"])
<!a::win_App(VsCode.winTitle,         Paths.Apps["VS Code"])
<!c::win_App(Browser.winTitle,        Paths.Apps["Google Chrome"])
<!q::win_App(Discord.winTitle,        Paths.Apps["Discord"],,,, "Updater")
<!t::win_App(Telegram.winTitle,       Paths.Apps["Telegram"])
<!z::win_App("OBS ahk_exe obs64.exe", Paths.Apps["OBS"],,, Paths.OBSFolder)

<!d::win_App_Folders("C:\", "Min")

<!v::win_App_Folders(Paths.Pictures, "Min")

<!Escape::GroupDeactivate("Main")

#MaxThreadsBuffer false