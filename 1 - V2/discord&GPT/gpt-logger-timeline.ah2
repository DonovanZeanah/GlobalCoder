logger := new Logger()
logger.Log("Program started.")
logger.Log("User clicked button.")
logger.Log("Program exited.")

timeline := new Timeline()
timeline.AddEvent("start", A_TickCount)
Sleep, 1000
timeline.AddEvent("middle", A_TickCount)
Sleep, 1000
timeline.AddEvent("end", A_TickCount)

startTime := timeline.GetEventTime("start")
middleTime := timeline.GetEventTime("middle")
endTime := timeline.GetEventTime("end



class Logger {
    __New() {
        this.logFile := "C:\log.txt"  ; change this to your desired log file path
    }
    
    Log(msg) {
        now := A_Now.Format("{yyyy}-{MM}-{dd} {HH}:{mm}:{ss}")
        logMsg := "[" . now . "] " . msg . "`n"
        FileAppend, %logMsg%, %this.logFile%
    }
}

class Timeline {
    __New() {
        this.events := []
    }
    
    AddEvent(name, time) {
        event := { "name": name, "time": time }
        this.events.push(event)
    }
    
    GetEventTime(name) {
        for i, event in this.events {
            if (event.name = name) {
                return event.time
            }
        }
        return 0  ; event not found
    }
}