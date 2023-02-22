GroupAdd("AutoHotkey_Help", "AutoHotkey Help")
GroupAdd("AutoHotkey_Help", "AutoHotkey v2 Help")

for key, value in Terminal.winTitles {
   GroupAdd("Terminal", value)
}

GroupAdd("Main", "Visual Studio Code ahk_exe Code.exe")
GroupAdd("Main", "ahk_group AutoHotkey_Help")
GroupAdd("Main", "ahk_exe Spotify.exe")
GroupAdd("Main", "Discord ahk_exe Discord.exe")
GroupAdd("Main", "Google Chrome ahk_exe chrome.exe")
GroupAdd("Main", "Telegram ahk_exe Telegram.exe")
GroupAdd("Main", "ahk_group Terminal")