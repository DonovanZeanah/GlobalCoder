; Power Toys extension for Minerva
; ================================
; Tested on PowerToys v0.64.1
;
; Available functions:
; - Always On Top
; - Color Picker
; - Fancy Zones
; - Measure Tool
; - Text Extractor

; Initial Variables

initPowerToys( configured := 0){
    if !ProcessExist("PowerToys.exe"){
        return 0
    }

    return configured
}

sendPowerToysKey(FeatureName){
    hk := getPowerToysKey(FeatureName)
    Send(hk)
}

;--------------------------------------
; Internal functions
ProcessExist(Name){
    ErrorLevel := ProcessExist(Name)
    return Errorlevel
}

getPowerToysKey(FeatureName){
    jsonSettings := Fileread(LocalAppData "\Microsoft\PowerToys\" FeatureName "\settings.json")

    settingsData := Jxon_Load(jsonSettings)

    ; hotkey setting path
    ; # AlwaysOnTop
    ;   - properties.hotkey.value
    ; # FancyZones
    ;   - properties.fancyzones_editor_hotkey.value
    ; # ColorPicker
    ;   - properties.ActivationShortcut
    ; # Measure Tool
    ;   - properties.ActivationShortcut
    ; # TextExtractor
    ;   - properties.ActivationShortcut
    Switch FeatureName
    {
    case "AlwaysOnTop":
        Ptr := settingsData.properties.hotkey.value

    case "FancyZones":
        Ptr := settingsData.properties.fancyzones_editor_hotkey.value

    default:
        Ptr := settingsData.properties.ActivationShortcut
    }

    ; Getting shortcut
    Shortcut := ""
    if IsObject(Ptr){
        if Ptr.win == "true"
            Shortcut := Shortcut . "#"
        if Ptr.ctrl == "true"
            Shortcut := Shortcut . "^"
        if Ptr.alt == "true"
            Shortcut := Shortcut . "!"
        if Ptr.shift == "true"
            Shortcut := Shortcut . "+"

        Shortcut := Shortcut . Chr(Ptr.code)
    }

    Return Shortcut
}