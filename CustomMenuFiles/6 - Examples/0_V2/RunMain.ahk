#Requires AutoHotkey v2.0-a
#SingleInstance Force
#Include <Paths>
#Include <Win>
Run(Paths.Ptf["Keys"])

GroupAdd("Terminal", "Linux ahk_exe WindowsTerminal.exe")
GroupAdd("Terminal", "Cmd ahk_exe WindowsTerminal.exe")
GroupAdd("Terminal", "PowerShell ahk_exe WindowsTerminal.exe")
GroupAdd("Terminal", "Git Bash ahk_exe WindowsTerminal.exe")

win_RunAct("Discord ahk_exe Discord.exe",         Paths.Apps["Discord"],,,, "Updater")
win_RunAct("ahk_exe Spotify.exe",                 Paths.Apps["Spotify"])
win_RunAct("ahk_group Terminal",                  Paths.Apps["Terminal"])
win_RunAct("Google Chrome ahk_exe chrome.exe",    Paths.Apps["Google Chrome"])
win_RunAct("Visual Studio Code ahk_exe Code.exe", Paths.Apps["VS Code"])