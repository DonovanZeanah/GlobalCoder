#Warn All, Off
Persistent

a := "
(
Shittyproj v.1.0.1
> Super shitty useless little project that does absolutely nothing.
> (C)2022 Gino Pilotino
> https://en.wikipedia.org/wiki/Loopin%27_Louie

Lorem ipsum dolor sit amet, consectetur 
adipiscing elit, sed do eiusmod tempor incididunt 
ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation 
ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate 
velit esse cillum dolore eu fugiat nulla pariatur.

Excepteur sint occaecat cupidatat non proident, sunt in 
culpa qui officia deserunt mollit anim id est laborum."
)"
a := ConfMan.GetConf("c:\test.ini", functest, functestobj)

a.WWWW :=
{
  WHAT  : "Nothing"
, WHO   : "No one" 
, WHERE : "Nowhere"
, WHEN  : "Never"
}

a.WWWW.SetOpts("OBJECT PARAMS")
a.WriteFile()

Msgbox a.functest()

a.ReadFile()

Msgbox a.functestobj()


functest(this, oRoot)
{
    return oRoot.WWWW.WHAT
}

functestobj(this, oRoot)
{
    return oRoot.WWWW.WHO.Value
}


; Simple auto-complete: any day of the week. Pun aside, this is a mostly functional example. Simply run the script and start typing today, press Tab to complete or press Esc to exit.
/*
WordList := "Monday`nTuesday`nWednesday`nThursday`nFriday`nSaturday`nSunday"
Suffix := ""
SacHook := InputHook("V", "{Esc}")
SacHook.OnChar := SacChar
SacHook.OnKeyDown := SacKeyDown
SacHook.KeyOpt("{Backspace}", "N")
SacHook.Start()
*/
;menu
; Create the popup menu by adding some items to it.



BuildTrayMenu()

;/========= Hotkeys
CapsLock::{
buildtraymenu()

TRAY.SHOW()
/*}

{
buildtraymenu()
MyMenu.Show()*/
}
;//=================

#z::
BuildTrayMenu(thishotkey*){
	;MyMenu.Add(MenuItemName, Function-or-Submenu, Options)
	tray := A_TrayMenu ; For convenience.
	tray.delete ; Delete the standard items.
	tray.SetIcon(MenuItemName, FileName , IconNumber, IconWidth)

	;Command sub-menu
	Sub_menuCommand := Menu()
	Sub_menuCommand.add("&1", mymenuopt)
	Sub_menuCommand.add("&2", mymenuopt)
	Sub_menuCommand.add("&3", mymenuopt)
	Sub_menuCommand.add("&GC Menu", MyMenuopt)
	mymenuopt(itemname, itempos, mymenu){
		MsgBox "You selected " ItemName " (position " ItemPos ")"
	}

	;Settings sub-menu
	sub_MenuSettings := menu()
	sub_menuSettings.add("&Settings", mysettingsopt)
	sub_menuSettings.add("%view", mysettingsopt)
	mysettingsopt(itemname, itempos, mymenu){
		MsgBox "You selected " ItemName " (position " ItemPos ")"
	}
	
	sub_menuReference := menu()
	sub_MenuReference.add("&1", myrefsopt)
	sub_MenuReference.add("&2", myrefsopt)
	sub_MenuReference.add("&3", myrefsopt)
	myrefsopt(itemname, itempos, mymenuc){
		MsgBox "You selected " ItemName " (position " ItemPos ")"
	}

	;standard menu condensed into a toplevel 'node'
	Sub_menuStandard := Menu()
	Sub_menuStandard.AddStandard()

	



	;Submenu3 := Menu()
	;Submenu3.add "Reference", fn_Reference
	;Submenu3.add "Ref Menu", fn_RefMenu

	tray.add "&GlobalCoder", Sub_menuCommand
	tray.add "&Settings", Sub_menuSettings
	tray.add "&Reference", Sub_menuReference
	tray.add "&Legacy Menu", Sub_menuStandard

	MyMenu := menu()
	mymenu.add "&GlobalCoder", Sub_menuCommand
	mymenu.add "&Settings", Sub_menuSettings
	mymenu.add "&Reference", Sub_menuReference
	mymenu.add "&Legacy Menu", Sub_menuStandard
}
;quickabout, buildtraymenu,MenuHandler,
;/========= functions
QuickAbout(sTitle, sBody, sGuiOpts:="", sEditOpts:=""){
		; ----------------------------------------------------------------------------------------------------------------------
		; Function .....: Gui_QuickAbout
		; Description ..: Just a quick about GUI.
		; Parameters ...: sTitle    - GUI title.
		; ..............: sBody     - Content of the Edit control, a.k.a. the About field.
		; ..............: sGuiOpts  - GUI options.
		; ..............: sEditOpts - Edit control options.
		; AHK Version ..: AHK v2
		; Author .......: Cyruz  (http://ciroprincipe.info)
		; License ......: WTFPL - http://www.wtfpl.net/txt/copying/
		; Changelog ....: Dec. 31, 2022 - v0.1 - First version.
		; ..............: Jan, 18, 2023 - v0.1.1 - Merged EM_SETMARGINS SendMessage(s). Thanks iPhilip.
		; ----------------------------------------------------------------------------------------------------------------------
    Static oGuiAbout
         , nPosX  := 0
         , nPosY  := 0
         , nMarX  := 15
         , nMarY  := 15
         , nPadSx := 1
         , nPadRx := 1
         , nBtnSz := 100
         , nIcoId := 24
         , nIcoSz := 48
         , sIcoFi := "C:\Windows\System32\shell32.dll"
    
    Try WinExist("ahk_id " oGuiAbout.Hwnd)
    Catch
    {
        oGuiAbout := Gui(sGuiOpts, sTitle)
        oGuiAbout.OnEvent( "Close", (*) => (WinGetPos(&nPosX, &nPosY), oGuiAbout.Destroy()) )
        oGuiAbout.MarginX := nMarX, oGuiAbout.MarginY := nMarY
        
        oGuiAbout.Add("Picture", "w" nIcoSz " h-1 Icon" nIcoId, sIcoFi)
        
        ; *** We create a readonly Edit control without borders (-E0x200), we deselect its content and we
        ; *** hide the caret on creation. The caret must be hidden anytime the control gets keyboard focus.
        ; *** We use SendMessage to set left and right margin for the control.
        
        oEditCtrl := oGuiAbout.Add("Edit", sEditOpts " x+" nMarX " +Multi +ReadOnly -E0x200", sBody)
        ControlSend("{Up}", oEditCtrl.Hwnd), DllCall("HideCaret", "Ptr",oEditCtrl.Hwnd)
        oEditCtrl.OnEvent( "Focus", (*) => DllCall("HideCaret", "Ptr",oEditCtrl.Hwnd) )
        SendMessage(0xD3, 1 | 2, nPadSx | nPadRx << 16,, "ahk_id " oEditCtrl.Hwnd) ; EM_SETMARGINS = 0xD3
        
        (oGuiAbout.Add("Button", "w" nBtnSz " x+-" nBtnSz " y+" nMarY, "OK" ))
        .OnEvent( "Click", (*) => (WinGetPos(&nPosX, &nPosY), oGuiAbout.Destroy()) )
        
        oGuiAbout.Show(nPosX != 0 && nPosY != 0 ? "X" nPosX " Y" nPosY : "")
        Return
    }
    
    ; Activate/Flash if gui is visible. WS_VISIBLE = 0x10000000.
    (WinGetStyle("ahk_id " oGuiAbout.Hwnd) & 0x10000000) && WinActivate("ahk_id " oGuiAbout.Hwnd), oGuiAbout.Flash()
}


	;MyMenuBar := menubar()
	
/*
	MyMenu := menu()
		Sub1 := menu()
			Sub1.Add "Item A", Sub1MenuHandler

		Sub2 := menu()
			Sub2.Add "Item A", Sub2MenuHandler

		Sub3 := menu()
			Sub3.Add "Item A", Sub3MenuHandler	

MytrayMenu := Menu()
MyMenu.Add "Item 1", MenuHandler
MyMenu.Add "Item 2", MenuHandler
MyMenu.Add  ; Add a separator line.

; Create another menu destined to become a submenu of the above menu.
Submenu1 := Menu()
Submenu1.Add "Item A", MenuHandler
Submenu1.Add "Item B", MenuHandler

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
MyMenu.Add "My Submenu", SubmenuFirst
MyMenu.Add  ; Add a separator line below the submenu.
MyMenu.Add "Item 3", MenuHandler  ; Add another menu item beneath the submenu.
*/

Configuration(){
	g := gui()
	b := g.Add("Button", "w200", "About")
	b.OnEvent("Click", (*) => Gui_QuickAbout("My About", a, "", "w320 h200"))
	g.Show()
}
trayMenuHandler(ItemName, ItemPos, MyMenu) {
    MsgBox "You selected " ItemName " (position " ItemPos ")"
}
MenuHandler(Item, *) {
    MsgBox "You selected " Item
}
KeyWaitAny(Options:=""){
    ih := InputHook(Options)
    if !InStr(Options, "V")
        ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")  ; End
    ih.Start()
    ih.Wait()
    return ih.EndKey  ; Return the key name
}
KeyWaitCombo(Options:=""){
    ih := InputHook(Options)
    if !InStr(Options, "V")
        ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")  ; End
    ; Exclude the modifiers
    ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-E")
    ih.Start()
    ih.Wait()
    return ih.EndMods . ih.EndKey  ; Return a string like <^<+Esc
}
SacChar(ih, char){  ; Called when a character is added to SacHook.Input.{
    global Suffix := ""
    if RegExMatch(ih.Input, "`nm)\w+$", &prefix)
        && RegExMatch(WordList, "`nmi)^" prefix[0] "\K.*", &Suffix)
        Suffix := Suffix[0]
    
    if CaretGetPos(&cx, &cy)
        ToolTip Suffix, cx + 15, cy
    else
        ToolTip Suffix

    ; Intercept Tab only while we're showing a tooltip.
    ih.KeyOpt("{Tab}", Suffix = "" ? "-NS" : "+NS")
}
SacKeyDown(ih, vk, sc){
    if (vk = 8) ; Backspace
        SacChar(ih, "")
    else if (vk = 9) ; Tab
        Send "{Text}" Suffix
}
;//==================

; ----------------------------------------------------------------------------------------------------------------------
; Function .....: ConfMan
; Description ..: Ini files management class, implementing an object central storage and an interface dealing with the
; ..............: underlined classes. ConfMan.IniInterface filters and redirect requests and calls to ConfMan.IniRoot,
; ..............: ConfMan.IniSection and ConfMan.IniFuncs.
; ..............: IniRoot and IniSections are basically Maps objects where the property notation is translated to item 
; ..............: notation, allowing to define a complete "ini" file structure like an object literal.
; ..............: ConfMan is a static class. Do not instantiate, use the available public methods to interact with it.
; Pub. Method ..: ConfMan.GetConf(sFileName, funcs*)
; Description ..: It initializes the object central storage and returns a ConfMan.IniInterface object.
; Parameters ...: sFileName - "Ini" file full path. If the file itself is not existing, it can be created with
; ..............:             a write operation. If the path to the file is not valid, an error will be thrown.
; ..............: funcs*    - Variadic parameter allowing for a series of function objects to be injected into the
; ..............:             ConfMan.IniFunc class. Injected functions must accept 2 parameters: "this" and the
; ..............:             ConfMan.IniRoot object used to process all "ini" file sections.
; Return .......: ConfMan.IniInterface object to be used for all interactions.
; Pub. Method ..: ConfMan.DiscardStorage()
; Description ..: Discard all object central storage.
; Interface ....: ConfMan.IniInterface (instantiated objects will be referred next as "objInterface")
; Description ..: objInterface allow the user to configure the object representing the "ini" file with literal notation
; ..............: and address the contained sections with property and item notations. objInterface "shadows" the
; ..............: ConfMan.IniRoot object and allow to interact with the ConfMan.IniSection objects.
; Obj. Config ..: Use literal notation: { SECTION1: {key1: value, key2: value}, SECTION2: {key1: value, key2: value} }
; ..............: Each section can be accessed as objInterface.SECTION1 or objInterface["SECTION1"].
; ..............: Each section can be configured with the "SetOpts" method with the following "options" (boolean flags):
; ..............: LOCKED  - This section should not be overridden by any operation.
; ..............: NOWRITE - This section is not written to file.
; ..............: NOEXKEY - Extra section keys will not be added to the configuration object when reading the file.
; ..............: PARAMS  - This section can be overridden by command line parameters.
; ..............: OBJECT  - When reading or overriding this section, the value in the key:value pair will be replaced by
; ..............:           a simple object with the "Value" property set (eg: { Value: value }).
; ..............: *** Please note that a section cannot have both the LOCKED and PARAMS options set.
; Pub. Method ..: objInterface.ReadFile()
; Description ..: Read file content and override all sections with the option LOCKED unset with the relative key:value 
; ..............: pairs.
; Pub. Method ..: objInterface.WriteFile()
; Description ..: Truncate the ini file if existing and create a new "ini" file with the ConfMan.IniRoot object content.
; Pub. Method ..: objInterface.ParseParams()
; Description ..: Parse command line parameters and override all sections with the option LOCKED unset and with the
; ..............: option PARAM set. The command line parameters must follow the notation [SECTION]key=value. The
; ..............: [SECTION] part can be omitted if only 1 section is marked with the PARAM option. If the value contains
; ..............: spaces, it can be enclosed in double quotes, that will be removed at processing time. New lines can be
; ..............: specified with the AutoHotkey notation `n.
; Pub. Method ..: objInterface.Section.SetOpts(sOptions)
; Description ..: Allow to specify a space separated list of option for the section. If the option is not present in the
; ..............: list, it will be set to 0 (eg: "LOCKED OBJECT" will set LOCKED=1, PARAMS=0, OBJECT=1).
; Parameters ...: sOpts - Space separated list containing the allowed options (LOCKED, PARAMS, OBJECT).
; Pub. Method ..: objInterface.Section.GetOpt(sOpt)
; Description ..: Get the value of the desired section option.
; Parameters ...: sOpt - Option to be retrieved (LOCKED, PARAMS, OBJECT).
; AHK Version ..: AHK v2 x32/64 Unicode
; Author .......: cyruz - http://ciroprincipe.info
; License ......: WTFPL - http://www.wtfpl.net/txt/copying/
; Changelog ....: Jan. 17, 2023 - v0.0.1 - First version.
; ..............: Jan. 18, 2023 - v0.0.2 - Fixed object override when OBJECT option is set and an object is already set.
; ..............:                          Added the NOWRITE option.
; ..............: Jan. 19, 2023 - v0.0.3 - Fixed an issue with the ReadFile function where the "Default" property of the
; ..............:                          ConfMan.IniRoot object was requested if the read Key was not present in the
; ..............:                          ConfMan.IniSection object.
; ..............: Jan. 22, 2023 - v0.0.4 - Added the NOEXKEY option.
; Thanks .......: swagfag - https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75383
; ----------------------------------------------------------------------------------------------------------------------
; Class Diagram Description:
;
;  ┌───────┐
;  │ConfMan│
;  │       ├───────┬────────────────────────┬─────────────────────────┬──────────────────────┐
;  │Static │       │(parent)                │(parent)                 │(parent)              │(provide)
;  └───┬───┘       ▼                        ▼                         ▼                      ▼
;      │   ┌───────────────┐    ┌───────────────────────┐    ┌─────────────────┐    ┌ ─ ─ ─ ─ ─ ─ ─ ─ ┐        
;      │   │ConfMan.IniRoot│    │ConfMan.IniSection     │    │ConfMan.IniFuncs │    │Object Storage   │ 
;      │   │Extends Map    │◄───┤Extends ConfMan.IniRoot│    │                 │    │Map              │
;      │   │               │    │                       │    │Static           │    │Static Class Var.│ 
;      │   └───────────────┘    └───────────────────────┘    └─────────────────┘    └ ─ ─ ─ ─ ─ ─ ─ ─ ┘
;      │           ▲                        ▲                         ▲                      ▲
;      │           │(shadow)                │(shadow)                 │(forward calls)       │
;      │           └────────────────────────┼─────────────────────────┘                      │
;      │                                    │                                                │
;      │                         ┌──────────┴──────────┐                                     │
;      │(parent - return)        │ConfMan.IniInterface │      (store ConfMan.IniRoot objects)│
;      └────────────────────────►│Extends Buffer       ├─────────────────────────────────────┘
;                                │Interface            │
;                                └─────────────────────┘
;
; ----------------------------------------------------------------------------------------------------------------------

class ConfMan
{
    ; Object central storage.
    ; This will be instantiated as a Map().
    static objStor := ""
    static Call(params*){
        throw Error("This is a static class. Please use <ConfMan.GetConf(sFileName)> to get an object.")
    }
    ; MAIN METHOD - Returns a ConfMan.IniInterface object after central storage initialization.
    static GetConf(sFileName, funcs*){
        (!IsObject(ConfMan.objStor)) && ConfMan.objStor := Map()     
        return ConfMan.IniInterface(sFileName, funcs*)
    }
    ; Completely discard all central storage content.
    static DiscardStorage() => ConfMan.objStor := ""
    
	    ; Collection of functions working on IniRoot objects.
	    ; Custom functions can be injected, each function must accept 2 parameters:
	    ; 1. this (to be ignored, it will be the ConfMan.IniInterface object).
	    ; 2. oRoot (the ConfMan.IniRoot object to process all ConfMan.IniSection objects).


	    
    class IniFuncs{
        static Call(params*)
        {
            throw Error("Static class.")
        }
        
        static ReadFile(oRoot)
        {
            sFileName := oRoot.__GetProp("FILENAME")
            
            if !FileExist(sFileName)
               throw Error("File not existing.", sFileName)
               
            sIniFile := IniRead(sFileName)
            loop parse, sIniFile, "`n"
            {
                if oRoot.Has(A_LoopField)
                {
                    if oRoot[A_LoopField].__GetProp("OPT_LOCKED")
                        continue
                    
                    sSectionName    := A_LoopField
                    sSectionContent := IniRead(sFileName, sSectionName)
                    bObject         := oRoot[A_LoopField].__GetProp("OPT_OBJECT")
                    bNoKeys         := oRoot[A_LoopField].__GetProp("OPT_NOEXKEY")
                    
                    loop parse, sSectionContent, "`n"
                    {
                        ; Match oM.1 = KEY / oM.2 = VALUE
                        if RegExMatch(A_LoopField, "S)^\s*(\w+)\s*\=\s*(.*)\s*$", &oM:=0)
                        {
                            if bNoKeys && !oRoot[sSectionName].Has(oM.1)
                                continue
                                
                            oM.2 := ConfMan.IniFuncs.__UnescapeNewLine(oM.2)
                            if bObject
                                (oRoot[sSectionName].Has(oM.1) && IsObject(oRoot[sSectionName][oM.1]))
                               ? oRoot[sSectionName][oM.1].Value := oM.2
                               : oRoot[sSectionName][oM.1] := { Value: oM.2 }
                            else oRoot[sSectionName][oM.1] := oM.2
                            bUpdated := 1
                        }
                    }
                }
            }
            
            return IsSet(bUpdated) ? 1 : 0
        }
        
        static WriteFile(oRoot)
        {
            sFileName := oRoot.__GetProp("FILENAME")
            
            try
            {
                f := FileOpen(sFileName, "w")
                for sec,cont in oRoot
                {
                    if cont.__GetProp("OPT_NOWRITE")
                        continue
                    f.WriteLine("[" sec "]")
                    for k,v in cont
                    {   ; If our IniSection key:value pair value is an object, get its "Value" property.
                        (IsObject(v) && v.HasOwnProp("Value")) && v := v.Value
                        f.WriteLine(k "=" ConfMan.IniFuncs.__EscapeNewLine(v))
                    }
                }
            }
            catch Error as e
                throw e
            finally
                (IsSet(f)) && f.Close()
            
            return 1
        }

        static ParseParams(oRoot)
        {
            ; Take note of the sections marked with the PARAMS option.
            sParamSec := "", nCount := 0
            for sec,cont in oRoot
                if cont.__GetProp("OPT_PARAMS")
                    sParamSec := sec, nCount++

            if !nCount
                throw ValueError("No section has been marked with the PARAMS option.")
            
            loop A_Args.Length
            {
                ; Match oM.1 = SECTION / oM.2 = KEY / oM.3 = VALUE
                if RegExMatch(A_Args[A_Index], "S)^(?:\[([^\[\]]+)\])*([\w]+)\=(.+)$", &oM:=0)
                {
                    ; Throw if:
                    ; * There are multiple sections marked to be overridden by parameters but none has been specified.
                    ; * A section has been specified but it does not exists or it is not marked to be overridden.
                    
                    if oM.1 == "" && nCount > 1
                        throw ValueError("Multiple section marked with PARAMS option but none has been specified.")
                    if oM.1 != "" && (!oRoot.Has(oM.1) || !oRoot[oM.1].__GetProp("OPT_PARAMS"))
                        throw ValueError("Section [" oM.1 "] does not exists or is not marked with PARAMS option.")
                    
                    ; If we have only one section marked with PARAMAS option we can avoid the
                    ; [SECTION] part in the command line parameter, so we perform this assignment.
                    (oM.1 == "") && oM.1 := sParamSec
                    
                    ; Do not throw if the section is marked with the NOEXKEY option, just skip the key.
                    if oRoot[oM.1].__GetProp("OPT_NOEXKEY") && !oRoot[oM.1].Has(oM.2)
                        continue
                    
                    ; Remove surrounding double quotes if present and unescape new lines.
                    (InStr(oM.3, "`"", 1) = 1) && (InStr(oM.3, "`"",, -1) = StrLen(oM.3)) && oM.3 := SubStr(oM.3, 2, -1)
                    oM.3 := ConfMan.IniFuncs.__UnescapeNewLine(oM.3)
                    
                    ; Perform the assignment.
                    if oRoot[oM.1].__GetProp("OPT_OBJECT")
                        (IsObject(oRoot[oM.1][oM.2]))
                       ? oRoot[oM.1][oM.2].Value := oM.3
                       : oRoot[oM.1][oM.2] := { Value: oM.3 }
                    else oRoot[oM.1][oM.2] := oM.3
                }
                else throw ValueError("Wrong parameter format: " A_Args[A_Index])
            }
        }
        
        static __EscapeNewLine(sText)   => StrReplace(sText, "`n", "``n")
        static __UnescapeNewLine(sText) => StrReplace(sText, "``n", "`n")
    }
    ; Implements a "Ini" file root.
    ; It manages __Get and __Set request blending the property and item notation.
    ; It defines the "Props" dynamic property and getters/setters to manage object properties.
    class IniRoot extends Map{    
        __New(params*)
        {
            if Mod(params.Length, 2) != 0
                throw ValueError("Constructor parameters are property,value pairs.")

            ; We use DefineProp to bypass __Get & __Set.
            this.DefineProp("Props", { Value: Map() })
            this.__SetProps(params*)
            
            super.__New()
            return this
        }
        
        ; Return an item, even if a property has been requested.
        __Get(name, params)
        {
            if this.Has(name)
                return params.Length > 0 ? this[name][params*] : this[name]
            else throw PropertyError("Key not found: " name)
        }
        
        ; Set an item, even if the property notation has been used.
        __Set(name, params, value) => params.Length > 0 ? this[name][params*] := value : this[name] := value
        
        ; We want the user to interact with "properties" only through methods.
        ; Due to the ConfMan.IniInterface object "shadowing" the ConfMan.IniRoot object and 
        ; forwarding method calls to the outer class, these methods will be accessible only if 
        ; using its "Root" prop (eg: <Root.Root.__GetProp("FILENAME")>).
        ; These same methods can, instead, be called directly on ConfMan.IniSection objects
        ; (eg: <Root["section"].__GetProp("NAME")> or <Root.section.__GetProp("NAME")>).
        
        __GetProp(name)        => this.Props[name]
        __GetProps()           => this.Props
        __SetProp(name, value) => this.Props[name] := value
        __SetProps(params*)
        {
            tmp := Map(), idx := 1
            Loop params.Length//2
            {
                prop := params[idx]
                tmp[prop] := params[idx+1]
                idx += 2
            }
            
            if !tmp.Has("FILENAME")
                throw ValueError("IniRoot objects need at least a FILENAME property.")
            
            if !FileExist(RegExReplace(tmp["FILENAME"], "[^\\]+$"))
                throw ValueError("File path not valid: " tmp["FILENAME"])
            
            this.Props := tmp
        }
    }
    ; Implements a "Ini" file section.
    ; ConfMan.IniSection class extends ConfMan.IniRoot adding the management of section options.
    ; ConfMan.IniSection "options" are boolean flags built on top of ConfMan.IniRoot properties.
    class IniSection extends ConfMan.IniRoot{
        __New(params*) => super.__New(params*)
        
        ; Override the __SetProps method to enforce specific checks.
        __SetProps(params*)
        {
            tmp := Map(), idx := 1
            Loop params.Length//2
            {
                prop := params[idx]
                tmp[prop] := params[idx+1]
                idx += 2
            }
            
            if !tmp.Has("NAME")
                throw ValueError("IniSection objects need at least a NAME property.")  
                
            this.Props := tmp
        }
        
        ; Build on top of __GetProp, to return a single option.
        GetOpt(sOpt) => this.__GetProp("OPT_" sOpt)
        
        ; Build on top of __SetProp to set a list of section options.
        ; If it's present in the string, set the relative option to 1, otherwise to 0.
        SetOpts(sOpts)
        {
            if InStr(sOpts, "LOCKED") && InStr(sOpts, "PARAMS")
                throw ValueError("IniSection objects can't be locked and overridden by parameters.")            

            for k in this.__GetProps()
                (RegExMatch(k, "OPT_([\w]+)", &oM:=0)) && this.__SetProp(k, InStr(sOpts, oM.1) ? 1 : 0)
        }
    }
    ; Acts as a proxy for all object interactions dispatching calls/requests to the sibling/parent classes.
    class IniInterface extends Buffer{
        __New(sFileName, funcs*)
        {
            ; "Inject" the function objects in the ConfMan.IniFuncs class if there are any.
            ; Each function must declare two parameters: "this" and the IniRoot object.
            loop funcs.Length
            {
                if IsObject(funcs[A_Index]) && funcs[A_Index].HasMethod()
                    ConfMan.IniFuncs.DefineProp(funcs[A_Index].name, { Call: funcs[A_Index] })
                else throw ValueError("funcs* items must be function objects.")
            }
            
            ; Initialize the Buffer properties.
            super.__New()
            
            ; We use the Buffer "Ptr" property as Map key for our objects central storage.
            ; That object will be removed at this object release by the __Delete meta function.
            ConfMan.objStor[this.Ptr] := ConfMan.IniRoot("FILENAME", sFileName)
            
            ; Define the Root property to have a ready access to the IniRoot object in the storage.
            this.DefineProp("Root", { Value: ConfMan.objStor[this.Ptr] })
            return this
        }
        
        ; Remove the object from the central storage.
        __Delete() => (IsObject(this.Root)) && ConfMan.objStor.Delete(this.Ptr)
        
        ; Forward method calls to the IniFuncs class.
        __Call(name, params) => ConfMan.IniFuncs.%name%(this.Root)
        
        ; Forward property requests to the IniRoot object.
        __Get(name, params) => this.Root.__Get(name, params)
        
        ; Create a "translation" layer that allows only selected operations. More specifically:
        ; * Allow <Root["section"]["key"] := value> notation.
        ; * Allow defining sections with the literal notation, translating properties to items:
        ;   <Root.section := { key1: value, ..., keyN: value }>
        
        __Set(name, params, value)
        {            
            ; Disallow setting non-object properties but only if there are no parameters [] in the call.
            ; This to allow item notation assignments for simple key:value pairs that will be managed next.
            
            if !params.Length && !IsObject(value)
                throw ValueError("IniRoot properties can be only objects defined with literal notation.")
            
            ; Disallow Root["section"]["param1",..,"paramN"] calls.
            if params.Length > 1
                throw PropertyError("IniSection properties are simple key:value pairs.")
            
            ; Create the IniSection object as IniRoot item in the central storage, if not present.
            (!this.Root.Has(name)) && this.Root[name] := ConfMan.IniSection( "NAME",        name
                                                                           , "OPT_LOCKED",  0
                                                                           , "OPT_NOWRITE", 0
                                                                           , "OPT_NOEXKEY", 0
                                                                           , "OPT_PARAMS",  0
                                                                           , "OPT_OBJECT",  0 )
            
            ; Allow item notation assignments (eg: <Root["section"]["key"] := value>).
            if params.Length
                return this.Root[name][params*] := value
            
            ; Translate object literal notation into item notation.
            for k,v in value.OwnProps()
                this.Root[name][k] := v
            
            ; Return for assignments chain.
            return this.Root[name]
        }
        
        ; Redirect __Item calls to __Get & __Set (eg: Root["section"]).
        __Item[params]
        {
            get => this.__Get(params, [])
            set => this.__Set(params, [], value)
        }
    }
}

/* Test Code:

#Include <Class_ConfMan>

a := ConfMan.GetConf("c:\test.ini", functest, functestobj)

a.WWWW :=
{
  WHAT  : "Nothing"
, WHO   : "No one" 
, WHERE : "Nowhere"
, WHEN  : "Never"
}

a.WWWW.SetOpts("OBJECT PARAMS")
a.WriteFile()

Msgbox a.functest()

a.ReadFile()

Msgbox a.functestobj()


functest(this, oRoot)
{
    return oRoot.WWWW.WHAT
}

functestobj(this, oRoot)
{
    return oRoot.WWWW.WHO.Value
}

*/

;/======== InputHook
;MsgBox KeyWaitAny()
; Same again, but don't block the key.
;MsgBox KeyWaitAny("V")
; Waits for any key in combination with Ctrl/Alt/Shift/Win.
;MsgBox KeyWaitCombo()

/*
InputHook := InputHook(Options, EndKeys, MatchList)
Parameters
Options
Type: String

A string of zero or more of the following letters (in any order, with optional spaces in between):

B: Sets BackspaceIsUndo to false, which causes Backspace to be ignored.

C: Sets CaseSensitive to true, making MatchList case sensitive.

I: Sets MinSendLevel to 1 or a given value, causing any input with send level below this value to be ignored. For example, I2 would ignore any input with a level of 0 (the default) or 1, but would capture input at level 2.

L: Length limit (e.g. L5). The maximum allowed length of the input. When the text reaches this length, the Input is terminated and EndReason is set to the word Max (unless the text matches one of the MatchList phrases, in which case EndReason is set to the word Match). If unspecified, the length limit is 1023.

Specifying L0 disables collection of text and the length limit, but does not affect which keys are counted as producing text (see VisibleText). This can be useful in combination with OnChar, OnKeyDown, KeyOpt or EndKeys.

M: Modified keystrokes such as Ctrl+A through Ctrl+Z are recognized and transcribed if they correspond to real ASCII characters. Consider this example, which recognizes Ctrl+C:

CtrlC := Chr(3) ; Store the character for Ctrl-C in the CtrlC var.
ih := InputHook("L1 M")
ih.Start()
ih.Wait()
if (ih.Input = CtrlC)
    MsgBox "You pressed Control-C."
Note: The characters Ctrl+A through Ctrl+Z correspond to Chr(1) through Chr(26). Also, the M option might cause some keyboard shortcuts such as Ctrl+← to misbehave while an Input is in progress.

T: Sets Timeout (e.g. T3 or T2.5).

V: Sets VisibleText and VisibleNonText to true. Normally, the user's input is blocked (hidden from the system). Use this option to have the user's keystrokes sent to the active window.

*: Wildcard. Sets FindAnywhere to true, allowing matches to be found anywhere within what the user types.

E: Handle single-character end keys by character code instead of by keycode. This provides more consistent results if the active window's keyboard layout is different to the script's keyboard layout. It also prevents key combinations which don't actually produce the given end characters from ending input; for example, if @ is an end key, on the US layout Shift+2 will trigger it but Ctrl+Shift+2 will not (if the E option is used). If the C option is also used, the end character is case-sensitive.

EndKeys
Type: String

A list of zero or more keys, any one of which terminates the Input when pressed (the end key itself is not written to the Input buffer). When an Input is terminated this way, EndReason is set to the word EndKey and the EndKey property is set to the name of the key.

The EndKeys list uses a format similar to the Send function. For example, specifying {Enter}.{Esc} would cause either Enter, ., or Esc to terminate the Input. To use the braces themselves as end keys, specify {{} and/or {}}.

To use Ctrl, Alt, or Shift as end-keys, specify the left and/or right version of the key, not the neutral version. For example, specify {LControl}{RControl} rather than {Control}.

Although modified keys such as Alt+C (!c) are not supported, non-alphanumeric characters such as ?!:@&{} by default require the Shift key to be pressed or not pressed depending on how the character is normally typed. If the E option is present, single character key names are interpreted as characters instead, and in those cases the modifier keys must be in the correct state to produce that character. When the E and M options are both used, Ctrl+A through Ctrl+Z are supported by including the corresponding ASCII control characters in EndKeys.

An explicit key code such as {vkFF} or {sc001} may also be specified. This is useful in the rare case where a key has no name and produces no visible character when pressed. Its virtual key code can be determined by following the steps at the bottom fo the key list page.

MatchList
Type: String

A comma-separated list of key phrases, any of which will cause the Input to be terminated (in which case EndReason will be set to the word Match). The entirety of what the user types must exactly match one of the phrases for a match to occur (unless the * option is present). In addition, any spaces or tabs around the delimiting commas are significant, meaning that they are part of the match string. For example, if MatchList is ABC , XYZ, the user must type a space after ABC or before XYZ to cause a match.

Two consecutive commas results in a single literal comma. For example, the following would produce a single literal comma at the end of string: string1,,,string2. Similarly, the following list contains only a single item with a literal comma inside it: single,,item.

Because the items in MatchList are not treated as individual parameters, the list can be contained entirely within a variable. For example, MatchList might consist of List1 "," List2 "," List3 -- where each of the variables contains a large sub-list of match phrases.

Input Stack
Any number of InputHook objects can be created and in progress at any time, but the order in which they are started affects how input is collected.

When each Input is started (by the Start method), it is pushed onto the top of a stack, and is removed from this stack only when the Input is terminated. Keyboard events are passed to each Input in order of most recently started to least. If an Input suppresses a given keyboard event, it is passed no further down the stack.

Sent keystrokes are ignored if the send level of the keystroke is below the InputHook's MinSendLevel. In such cases, the keystroke may still be processed by an Input lower on the stack.

Multiple InputHooks can be used in combination with MinSendLevel to separately collect both sent keystrokes and real ones.

InputHook Object
The InputHook function returns an InputHook object, which has the following methods and properties.

Methods:
KeyOpt: Sets options for a key or list of keys.
Start: Starts collecting input.
Stop: Terminates the Input and sets EndReason to the word Stopped.
Wait: Waits until the Input is terminated (InProgress is false).
General Properties:
EndKey: Returns the name of the end key which was pressed to terminate the Input.
EndMods: Returns a string of the modifiers which were logically down when Input was terminated.
EndReason: Returns an EndReason string indicating how Input was terminated.
InProgress: Returns true if the Input is in progress and false otherwise.
Input: Returns any text collected since the last time Input was started.
Match: Returns the MatchList item which caused the Input to terminate.
OnEnd: Retrieves or sets the function object which is called when Input is terminated.
OnChar: Retrieves or sets the function object which is called after a character is added to the input buffer.
OnKeyDown: Retrieves or sets the function object which is called when a notification-enabled key is pressed.
OnKeyUp: Retrieves or sets the function object which is called when a notification-enabled key is released.
Option Properties:
BackspaceIsUndo: Controls whether Backspace removes the most recently pressed character from the end of the Input buffer.
CaseSensitive: Controls whether MatchList is case sensitive.
FindAnywhere: Controls whether each match can be a substring of the input text.
MinSendLevel: Retrieves or sets the minimum send level of input to collect.
NotifyNonText: Controls whether the OnKeyDown and OnKeyUp callbacks are called whenever a non-text key is pressed.
Timeout: Retrieves or sets the timeout value in seconds.
VisibleNonText: Controls whether keys or key combinations which do not produce text are visible (not blocked).
VisibleText: Controls whether keys or key combinations which produce text are visible (not blocked).
*/
;// Funcs, Arrays, map








;EQUIVALENT FUNCS

sumfn := Sum(a, b) => a + b


Sum1(a, b) {
    return a + b
}
sumfn := Sum

;arr
veg := ["Asparagus", "Broccoli", "Cucumber"]
Loop veg.Length
    MsgBox veg[A_Index]

    users := Array()
users.Push A_UserName
MsgBox users[1]

/*

class Array extends Object
An Array object contains a list or sequence of values.

Values are addressed by their position within the array (known as an array index), where position 1 is the first element.

Arrays are often created by enclosing a list of values in brackets. For example:

veg := ["Asparagus", "Broccoli", "Cucumber"]
Loop veg.Length
    MsgBox veg[A_Index]
A negative index can be used to address elements in reverse, so -1 is the last element, -2 is the second last element, and so on.

Attempting to use an array index which is out of bounds (such as zero, or if its absolute value is greater than the Length of the array) is considered an error and will cause an IndexError to be thrown. The best way to add new elements to the array is to call InsertAt or Push. For example:

users := Array()
users.Push A_UserName
MsgBox users[1]
An array can also be extended by assigning a larger value to Length. This changes which indices are valid, but Has will show that the new elements have no value. Elements without a value are typically used for variadic calls or by variadic functions, but can be used for any purpose.

"ArrayObj" is used below as a placeholder for any Array object, as "Array" is the class itself.

In addition to the methods and property inherited from Object, Array objects have the following predefined methods and properties.

Table of Contents
Static Methods:
Call: Creates a new Array containing the specified values.
Methods:
Clone: Returns a shallow copy of an array.
Delete: Removes the value of an array element, leaving the index without a value.
Get: Returns the value at a given index, or a default value.
Has: Returns true if the specified index is valid and there is a value at that position.
InsertAt: Inserts one or more values at a given position.
Pop: Removes and returns the last array element.
Push: Appends values to the end of an array.
RemoveAt: Removes items from an array.
__New: Appends items. Equivalent to Push.
__Enum: Enumerates array elements.
Properties:
Length: Retrieves or sets the length of an array.
Capacity: Retrieves or sets the current capacity of an array.
Default: Defines the default value returned when an element with no value is requested.
__Item: Retrieves or sets the value of an array element.
*/



;map
clrs := Map()
clrs["Red"] := "ff0000"
clrs["Green"] := "00ff00"
clrs["Blue"] := "0000ff"
for clr in Array("Blue", "Green")
    MsgBox clrs[clr]



;//================ ;ternary


ProductIsAvailable := (Color = "Red")
    ? false  ; We don't have any red products, so don't bother calling the function.
    : ProductIsAvailableInColor(Product, Color)

;//================ continuation
myarray := [
  "item 1",
  "item 2",
]
MsgBox(
    "The value of item 2 is " myarray[2],
    "Title",
    "ok iconi"
    )
;================
    myarray :=  ; The assignment operator causes continuation.
[  ; Brackets enclose the following two lines.
  "item 1",
  "item 2",
]
;===========

;================
Var := "
(
A line of text.
By default, the hard carriage return (Enter) between the previous line and this one will be stored.
	This line is indented with a tab; by default, that tab will also be stored.
Additionally, "quote marks" are automatically escaped when appropriate.
)"

; EXAMPLE #2:
FileAppend "
(
Line 1 of the text.
Line 2 of the text. By default, a linefeed (`n) is present between lines.
)", A_Desktop "\My File.txt"
/*
In the examples above, a series of lines is bounded at the top and bottom by a pair of parentheses.
 This is known as a continuation section.
 Notice that any code after the closing parenthesis
  is also joined with the other lines (without any delimiter),
   but the opening and closing parentheses are not included.
 */
;//================ ini

; iniwrite
IniWrite Value, Filename, Section, Key
IniWrite Pairs, Filename, Section

; iniread
Value := IniRead("C:\Temp\myfile.ini", "section2", "key")
MsgBox "The value is " Value











;//================ fileexist, append, dir, folder/file
FileAppend "Another line.`n", "C:\My Documents\Test.txt"

; Shows a message box if the D drive does exist.

if FileExist("D:\")
    MsgBox "The drive exists."
; Shows a message box if at least one text file does exist in a directory.

if FileExist("D:\Docs\*.txt")
    MsgBox "At least one .txt file exists."
; Shows a message box if a file does not exist.

if not FileExist("C:\Temp\FlagFile.txt")
    MsgBox "The target file does not exist."
; Demonstrates how to check a file for a specific attribute.

if InStr(FileExist("C:\My File.txt"), "H")
    MsgBox "The file is hidden."

; folder
;============================================
; Shows a message box if a folder does exist.

if DirExist("C:\Windows")
    MsgBox "The target folder does exist."
; Shows a message box if at least one program folder does exist.

if DirExist("C:\Program*")
    MsgBox "At least one program folder exists."
; Shows a message box if a folder does not exist.

if not DirExist("C:\Temp")
    MsgBox "The target folder does not exist."
; Demonstrates how to check a folder for a specific attribute.

if InStr(DirExist("C:\System Volume Information"), "H")
    MsgBox "The folder is hidden."

;//================ Instr, strsplit
MsgBox InStr("123abc789", "abc") ; Returns 4
Haystack := "The Quick Brown Fox Jumps Over the Lazy Dog"
Needle := "Fox"
If InStr(Haystack, Needle)
    MsgBox "The string was found."
Else
    MsgBox "The string was not found."
;================

TestString := "This is a test."
word_array := StrSplit(TestString, A_Space, ".")  ; Omits periods.
MsgBox "The 4th word is " word_array[4]

;//================ strsplit
colors := "red,green,blue"
For index, color in StrSplit(colors, ",")
  MsgBox "Color number " index " is " color

;//================ regexmatch
MsgBox RegExMatch("xxxabc123xyz", "abc.*xyz")
MsgBox RegExMatch("abc123", "i)^ABC")
MsgBox RegExMatch("abcXYZ123", "abc(.*)123", &SubPat)



;//================ strreplace
;Removes all CR+LF's from the clipboard contents.

A_Clipboard := StrReplace(A_Clipboard, "`r`n")


;Replaces all spaces with pluses.

NewStr := StrReplace(OldStr, A_Space, "+")

;Removes all blank lines from the text in a variable.

Loop
{
    MyString := StrReplace(MyString, "`r`n`r`n", "`r`n",, &Count)
    if (Count = 0)  ; No more replacements needed.
        break
}
;//================ func object, bondfunc
class FuncArrayType extends Array {
    Call(params*) {
        ; Call a list of functions.
        for fn in this
            fn(params*)
    }
}

; Create an array of functions.
funcArray := FuncArrayType()
; Add some functions to the array (can be done at any point).
funcArray.Push(One)
funcArray.Push(Two)
; Create an object which uses the array as a method.
obj := {method: funcArray}
; Call the method (and consequently both One and Two).
obj.method("2nd")
; Call it as a function.
(obj.method)("1st", "2nd")

One(param1, param2) {
    ListVars
    MsgBox
}
Two(param1, param2) {
    ListVars
    MsgBox
}

;BoundFunc Object Acts like a function, but just passes predefined parameters to another function.
;There are two ways that BoundFunc objects can be created:

;By calling the Func.Bind method, which binds parameter values to a function.
;By calling the ObjBindMethod function, which binds parameter values and a method name to a target object.
;BoundFunc objects can be called as shown in the example below. When the BoundFunc is called, it calls the function or method to which it is bound, passing a combination of bound parameters and the caller's parameters. Unbound parameter positions are assigned positions from the caller's parameter list, left to right. For example:

fn := RealFn.Bind(1)  ; Bind first parameter only
fn(2)      ; Shows "1, 2"
fn.Call(3) ; Shows "1, 3"

fn := RealFn.Bind( , 1)  ; Bind second parameter only
fn(2)      ; Shows "2, 1"
fn.Call(3) ; Shows "3, 1"
fn(, 4)    ; Error: 'a' was omitted

RealFn(a, b, c:="c") {
    MsgBox a ", " b
}
;ObjBindMethod can be used to bind to a method even when it isn't possible to retrieve a reference to the method itself. For example:

Shell := ComObject("Shell.Application")
RunBox := ObjBindMethod(Shell, "FileRun")
; Show the Run dialog.
RunBox


;For a more complex example, see SetTimer.

;Other properties and methods are inherited from Func, but do not reflect the properties of the target function or method (which is not required to be implemented as a function). The BoundFunc acts as an anonymous variadic function with no other formal parameters, similar to the fat arrow function below:

Func_Bind(fn, bound_args*) {
    return (args*) => (args.InsertAt(1, bound_args*), fn(args*))
}
;//======================================










