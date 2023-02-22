
#SingleInstance, force


Function(1, 2, 3, 4, 5)
global wps := .0042 ; rate based on $15.00 / hour (a baseline figure)
home := new HQ(-33.406346189037116, -87.5944803458756) ;actual coords
home.Destination("Hardware", -33.23282225918211, -87.61325127705827) ;close-by hardware store coordinates
msgbox % home.hardware.dist "`n -created hq instance `n -used destination method `n mgsbox#: 1"
;suv := new car(16,home.hardware.miles)
suv := new car(16,home.hardware.dist)
suv.trip1 := suv.drive(suv.mpg, home.hardware.miles) ;using object method to return an object from a method of another object

MsgBox, % "3: `n " suv.trip1
data := new trip()
data.save(round(suv.trip1,2), home.hardware.name)

data.readfile()
MsgBox, % "5: `n " data.filepath
MsgBox, % "5: `n " data.path

;MsgBox, % "2: `n " data

;data.showfile(data.readfile())

;for k,v in data ;afile 
;MsgBox, % "4: `n " k "-" v



/*;HQ class 
msgbox % home.Hardware.Kilometers "`n [kilometer form]"
msgbox % home.Hardware.miles "`n [miles form]"
msgbox % home.hardware.dist
msgbox % suv.mpg ; hopefully 16

;working ; msgbox % suv.drive(suv.mpg, home.hardware.miles).twoway() ;using object method to return an object from a method of another object
msgbox % suv.drive(suv.mpg, home.hardware.miles) ;using object method to return an object from a method of another object
msgbox % "suv.trip1: `n trip1 then return AE: $" round(suv.trip1, 2)
*/






return

esc::exitapp





Function(number, numbers*) {
    for k,v in numbers
    MsgBox, % "3: `n " v
   ; numbers == [2, 3, 4, 5]
   return
}

class HQ {

    __New(lat, long) {
;automatically sets the first half of the total needed information for the destination() method upon creation.
        this.Lat := lat, this.Long := long
    }

    Destination(name, lat, long) {
; names a target locations and receives input for the last half of needed information

        object := this[name] := {name:name}
        static p := 0.017453292519943295  ;1 degree in radian
        object.Kilometers := 12742*ASin(Sqrt(0.5 - Cos((lat - this.Lat)*p)/2 + Cos(this.Lat*p)*Cos(lat*p)*(1 - Cos((long - this.Long)*p))/2))  ;Formula borrowed from Internet search
        object.Meters := object.Kilometers*1000  ;meters
        object.Miles := object.Kilometers/1.609344  ;miles
        object.Feet := object.Kilometers/0.0003048  ;feet
        object.Yards := object.Feet/3
        return object.dist := object.miles := Round(object.miles, 2) , object.destination := object.miles := Round(object.miles, 2)
    }
}

;class car extends hq
class car  {
    static ppg := 5.00 ;price per gallon
    static mph := 60 ; a practical nominal average

    __new(mpg, optvar := ""){
        this.mpg := mpg
        this.optvar := optvar
if (optvar != "") ;should work if optvar passed in
    {
        MsgBox, % "6: `n " optvar " `n was infact, true."
        this.drive(mpg, home.hardware.dist )
        return this
    }
    MsgBox, % "2: `n " home.destination
    return this
} 

    drive(mpg, distance){
        this.mpg := mpg 
        this.distance := distance
        gasamount := distance / mpg
        timeamount := round((distance / this.mph) * (60*60), 2) ;* wps
        ;timeamount := round(timeamount, 2 ) * 60 . " seconds" := round(timeamount, 2 ) * wps ;. " cents - worth in time "
        MsgBox, % "7: `n "gasamount " gallon of gas `n" gasamount * this.ppg " gas cash value `n" timeamount " seconds of driving `n" . temp := timeamount/60 " minutes of driving. `n " . "$ " . timeamountincash := round( timeamount * wps , 2) . " time converted to cash value."
       ;worked; result := (gasamount * this.ppg) + timeamount 
        ;first change; result := round((gasamount * this.ppg) + timeamount , 2)
        ;2nd; result := round((gasamount * this.ppg) + timeamount , 2)
        timeamountincash := round( timeamount * wps , 2)
        result := this.twoway((gasamount * this.ppg ) + timeamountincash )
        MsgBox, % "8: `n " result
        return result
        ;worked; return this.twoway(result) ;.round(result, 2) 


}        
    twoway(result){
        MsgBox, % "9: initial result `n " this.result := result
            result := result * 2
            return result

        }
}

class trip{
;readfile
;showfile
;[] addtofile
    __New(price := ""){
        ;static price :=
      
        
    }
    getpath(){

    }
    readfile(path := "\trips.txt"){
        if path != ""
        {
            filepath := "C:\Users\dkzea\OneDrive\Desktop" . path
            FileRead, Contents, % "C:\Users\dkzea\OneDrive\Desktop" . path ;A_Desktop "/Test.txt"
            StringReplace, Contents, Contents, `r,, All ; makes sure only `n separates the lines
            aFile := {}
           
            Loop, Parse, contents , `n
                {
                temp_arr := StrSplit(a_loopfield, ",") ;StrSplit(String, [Delimiters, OmitChars])
                afile[temp_arr [1]] := temp_arr[2] ;whatever temp_arr[1] is, becomes the key for afile i.e, afile[notepadLine1] := notepadLine2
                afile.path := "C:\Users\dkzea\OneDrive\Desktop" . path
                }
            return aFile
        }
        else 
        {
            MsgBox, % "0: `n it didn't read the file, path inside object method trip.readfile() is: " path 
        }
    }

    showfile(data){
        for k,v in data
        {
        MsgBox, % "4: `n " k "-" v
        eachvalue .= v
        total += v 
        }
        Gui,+AlwaysOnTop ;Sets the Gui as forward priority in the window hierarchy.
        Gui, Color, 000000 ;Sets the Gui color to black
        Gui, +Delimiterspace
        Gui, Add, DropDownList,, %total%
        Gui, Add, DropDownList,, %eachvalue%
        Gui, Add, Button, x5 y370 w290 gSaveExit, Save and Exit
        Gui, Show

        return total
    }
    save(price,location){
        MsgBox, % "0: `n " location
        MsgBox, % "0: `n " price
        return

        }
        total(){
            for k,v in data
        {
            MsgBox, % "4: `n " k "-" v
            eachvalue .= v
            total += v 
        }
        }
}
saveExit:
for k, v in obj
    for k,v in v
objList .= k "|" v "`n"
MsgBox, 262144, , % objList
FileAppend, %objList%, %A_ScriptDir%\%n% ToolsCount.txt
return