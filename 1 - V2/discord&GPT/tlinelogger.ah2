class Logger {
    fileObj := {}
    
    __New() {
        this.fileObj := FileOpen(A_WorkingDir . "\logfile.txt", "a", "UTF-8")
    }
    
    logEvent(event) {
        this.fileObj.Write(A_Now . ": " . event . "`n")
    }
    
    __Delete() {
        this.fileObj.Close()
    }
}

class Timeline {
    logger := {}
    
    __New(loggerObj) {
        this.logger := loggerObj
    }
    
    logEvent(event) {
        this.logger.logEvent(event)
    }
}

loggerObj := Logger()
timelineObj := Timeline(loggerObj)

timelineObj.logEvent("First event")
timelineObj.logEvent("Second event")
