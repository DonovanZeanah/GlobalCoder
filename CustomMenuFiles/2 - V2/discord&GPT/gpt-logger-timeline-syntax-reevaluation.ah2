
logger := new Logger()
logger.Log("Program started.")
logger.Log("User clicked button.")
logger.Log("Program exited.")

timeline := new Timeline()
timeline.AddEvent("start", A_TickCount)
Sleep(1000)
timeline.AddEvent("middle", A_TickCount)
Sleep(1000)
timeline.AddEvent("end", A_TickCount)

startTime := timeline.GetEventTime("start")
middleTime := timeline.GetEventTime("middle")
endTime := timeline.GetEventTime("end")

MsgBox("Start time:" startTime "`nMiddle time:" middleTime "`nEnd time:" endTime)

class Logger {
    __New() {
    }
    
    Log(msg) {
        now := DateTime.Now
        logMsg := "[" . now.ToString("{yyyy}-{MM}-{dd} {HH}:{mm}:{ss}") . "] " . msg . "`n"
        File.Append(this.logFile, logMsg)
    }
}

class Timeline {
    __New() {
        this.events := []
    }
    
    AddEvent(name, time) {
        event := { name: name, time: time }
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
