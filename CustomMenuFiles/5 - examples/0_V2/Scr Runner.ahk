#ErrorStdOut 
#UseHook 
#Include <App>
#Include <ClipSend>
#Include <Links>
#Include <String>
#Include <Win>
#Include <Paths>
#Include <Char>
#Include <String-full>
#Include <Tools>
#Include <Script>
#Include <Global>
#Include <Other>
#Include <Get>
#Include <Channel>

#Hotstring EndChars `t


;Pasting random values
:X:radnum::ClipSend(RadNum())
:X:uclanr::ClipSend(GetRandomWord("english"))
:X:ilandh::ClipSend(GetRandomWord("russian"))
:X:chrs::ClipSend(GetStringOfRandChars(15))
:X:date::ClipSend(GetDate())
:X:time::ClipSend(GetDateAndTime())

;Terminal completions
:X:gh::ClipSend(Links["gh"])
:X:ghm::ClipSend(Links["ghm"])

;Github nicknames
:O:micha::Micha-ohne-el
:O:reiwa::rbstrachan
:O:me::Axlefublr

~f24:: {
   if !input := CleanInputBox().WaitForInput() {
      return false
   }

   static runner_commands := Map(
      ;Main
      "format table to array", () => ClipSend(str_FormatTableToArray(), ""),
      "remove comments",       () => str_RemoveLineComments(),
      "convert to json",       () => ClipSend(str_ConvertToJsonSnippet(str_GetSelection()), ""),

      "update",  () => GitHub.UpdateAhkLibraries(),
      "str len", () => Infos(str_GetSelection().Length),
      "startup", () => tool_StartupRun(),
      "shows",   () => Shows().GetList(),
      "rel",     () => Reload(),
      "track",   () => ClipSend(Spotify.GetCurrSong()),
      "kb",      () => KeyCodeGetter(),
      "eat",     () => EatingLogger(),
      "dt",      () => ClipSend(GetDateAndTime(), , false),

      ;Apps
      "sm",       Run.Bind(Paths.Apps["Sound mixer"]),
      "apps",     MainApps,
      "v1 docs",  () => win_RunAct("AutoHotkey Help",                     Paths.Apps["Ahk v1 docs"]),
      "davinci",  () => win_RunAct("Project Manager ahk_exe Resolve.exe", Paths.Apps["Davinci Resolve"]),
      "slack",    () => win_RunAct("Slack ahk_exe slack.exe",             Paths.Apps["Slack"]),
      "steam",    () => win_RunAct("ahk_exe steam.exe",                   Paths.Apps["Steam"], , "Steam - News"),
      "vpn",      () => win_RunAct("Proton VPN ahk_exe ProtonVPN.exe",    Paths.Apps["VPN"]),
      "fl",       () => win_RunAct("ahk_exe FL64.exe",                    Paths.Ptf["FL preset"]),
      "ds4",      () => win_RunAct("DS4Windows ahk_exe DS4Windows.exe",   Paths.Apps["DS4 Windows"]),
      "obs",      () => win_RunAct("OBS ahk_exe obs64.exe",               Paths.Apps["OBS"], , , Paths.OBSFolder),
      
      ;Gimp
      "gi ahk2",  () => win_RunAct(
         Gimp.exeTitle, Gimp.Presets["ahk second channel"],, 
         Gimp.toClose,, Gimp.exception
      ),
      "gi ahk", () => win_RunAct(
         Gimp.exeTitle, Gimp.Presets["ahk"],, 
         Gimp.toClose,, Gimp.exception
      ),
      "gi nvim", () => win_RunAct(
         Gimp.exeTitle, Gimp.Presets["nvim"],, 
         Gimp.toClose,, Gimp.exception
      ),

      ;Folders
      "ext",   () => win_RunAct_Folders(Paths.VsCodeExtensions),
      "prog",  () => win_RunAct_Folders(Paths.Prog),
      "saved", () => win_RunAct_Folders(Paths.SavedScreenshots),
      "main",  () => VsCode.WorkSpace("Main"),

      ;Video production
      "clean",    () => VsCode.CleanText(ReadFile(A_Clipboard)),
      "edit",     () => Video.EditScreenshot(),
      "video up", () => VsCode.VideoUp(),
      "dupl",     () => Video.DuplicateScreenshot(),
      "setup",    () => Davinci.Setup(),

   )

   try runner_commands[input].Call()
   catch Any {
      RegexMatch(input, "^(p|o|s|r|t|a|e|i|show|link|ep|delow|counter|gl|go|install|chrs|dd|down|drop|disc|sy|ts) (.+)", &result)
      static runner_regex := Map(

         "p",       (input) => ClipSend(Links[input], , false),
         "o",       (input) => RunLink(Links[input]),
         "s",       (input) => SoundPlay(Paths.Sounds "\" input ".mp3"),
         "r",       (input) => Spotify.NewRapper(input),
         "t",       (input) => (WriteFile(Paths.Ptf["Timer.txt"], input), Run(Paths.Ptf["Timer.ahk"])),
         "ts",      (input) => Timer(input, false),
         "a",       (input) => Spotify.FavRapper_Manual(input),
         "e",       (input) => Calculator(input),
         "i",       (input) => Infos(input),
         "show",    (input) => Shows().Run(input),
         "down",    (input) => Shows().Run(input, "downloaded"),
         "link",    (input) => Shows().SetLink(input),
         "ep",      (input) => Shows().SetEpisode(input),
         "dd",      (input) => Shows().SetDownloaded(input),
         "delow",   (input) => Shows().DeleteShow(input),
         "drop",    (input) => Shows().DeleteShow(input, true),
         "counter", (input) => Counter(input),
         "gl",      (input) => ClipSend(Git.Link(input), "", false),
         "go",      (input) => RunLink(Git.Link(input)),
         "install", (input) => Git.InstallAhkLibrary(input),
         "chrs",    (input) => ClipSend(GetStringOfRandChars(input)),
         "disc",    (input) => Spotify.NewDiscovery_Manual(input),
         "sy",      (input) => Symbol(input),

      )
      try runner_regex[result[1]].Call(result[2])
   }
}