c# =
(
    using System;
    using System.Runtime.InteropServices;
    
    class ObjectWithEvent {
        public void RaiseEvent() {
            if (OnEvent != null)
                OnEvent(this, EventArgs.Empty);
        }
        public event EventHandler OnEvent;
        
        public Delegate Delegate4FuncPtr(uint ptr, Type t) {
            return Marshal.GetDelegateForFunctionPointer((IntPtr)ptr, t);
        }
    }
)

CLR_Start()

asm := CLR_CompileC#(c#, "System.dll")
obj := CLR_CreateObject(asm, "ObjectWithEvent")

asmCor := CLR_LoadLibrary("mscorlib")
; Get typeof(System.EventHandler)
tEH := COM_Invoke(asmCor, "GetType_2", "System.EventHandler")
; Create a .NET Delegate for the EventHandler() callback.
pEH := COM_Invoke(obj, "Delegate4FuncPtr", RegisterCallback("EventHandler"), "+" tEH)
; Register the event handler. (Events export add_event() and remove_event()).
COM_Invoke_(obj, "add_OnEvent", 13,pEH)
; Call the C# method which raises the event.
COM_Invoke(obj, "RaiseEvent")

; (Cleanup code omitted.)

ListVars
Pause

EventHandler(vt, junk1, sender, junk2, eventArgs)
{
    MsgBox, 0, Event Raised, % "sender: " COM_Invoke(sender,"ToString")
        . "`neventArgs: " COM_Invoke(eventArgs,"ToString")
}