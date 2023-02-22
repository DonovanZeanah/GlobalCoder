;source: https://autohotkey.com/board/topic/62953-clr-email-systemnetmail-ahk-l/

;NOTE:
;System.Net.Mail supports only 587 port (TLS) (https://autohotkey.com/board/topic/36522-cdo-com-email-delivery/?p=286182)

InputBox, password , Enter Password, Enter Password, HIDE, 200, 100
If ErrorLevel
    ExitApp

C# := LoadC#()
CLR_StartDomain( mailDomain ) 
if not ( asm := CLR_CompileC#(C#, "System.dll", mailDomain ) )
  MsgBox Could not compile C#
mail := CLR_CreateObject(asm, "iMail")
mail.iSend("smtp-mail.outlook.com", 587, "donovan.zeanah@outlook.com", 3de32882D!, "dkzeanah@gmail.com", "dkzeanah@gmail.com", "Hello There", "This is a test email", True)
CLR_StopDomain( mailDomain ) 

LoadC#() {
c# =
(
using System.Net;
using System.Net.Mail;
 
public class iMail
{
  public void iSend(string host, int port, string userName, string pswd, string fromAddress, string toAddress, string body, string subject, bool sslEnabled) 
  {
      MailMessage msg = new MailMessage(new MailAddress(fromAddress), new MailAddress(toAddress));
              msg.Subject = subject;
              msg.SubjectEncoding = System.Text.Encoding.UTF8;
      msg.Body = body;
              msg.BodyEncoding = System.Text.Encoding.UTF8;
      msg.IsBodyHtml = false;
      
      SmtpClient client = new SmtpClient(host, port);
              client.Credentials = new NetworkCredential(userName, pswd);
              client.EnableSsl = sslEnabled;
      client.Send(msg);
  }
}
)
return c#
}

;source: https://www.autohotkey.com/boards/viewtopic.php?f=65&t=39100&p=178985&hilit=CLR_L#p178985
; ==========================================================
;                  .NET Framework Interop
;      https://autohotkey.com/boards/viewtopic.php?t=4633
; ==========================================================
;
;   Author:     Lexikos
;   Version:    1.2
;   Requires:   AutoHotkey_L v1.0.96+
;   
;   (This modification, CLR_H.ahk, works for AutoHotkey_H v1.1.26.01
;   with my Win7 64-bit system, AHK_H 64-bit.
;   Also works with AutoHotkey.DLL via
;   Auto.Hotkey.Interop in UiPath activities.)
;
;   "null" changed to "nulo" 10.28.17 to avoid
;   errors related to declaration of built-in variables
;   with AHK_H. No other changes.
;   Regards, burque505

CLR_LoadLibrary(AssemblyName, AppDomain=0)
{
    if !AppDomain
        AppDomain := CLR_GetDefaultDomain()
    e := ComObjError(0)
    Loop 1 {
        if assembly := AppDomain.Load_2(AssemblyName)
            break
        static nulo := ComObject(13,0)
        args := ComObjArray(0xC, 1),  args[0] := AssemblyName
        typeofAssembly := AppDomain.GetType().Assembly.GetType()
        if assembly := typeofAssembly.InvokeMember_3("LoadWithPartialName", 0x158, nulo, nulo, args)
            break
        if assembly := typeofAssembly.InvokeMember_3("LoadFrom", 0x158, nulo, nulo, args)
            break
    }
    ComObjError(e)
    return assembly
}

CLR_CreateObject(Assembly, TypeName, Args*)
{
    if !(argCount := Args.MaxIndex())
        return Assembly.CreateInstance_2(TypeName, true)
    
    vargs := ComObjArray(0xC, argCount)
    Loop % argCount
        vargs[A_Index-1] := Args[A_Index]
    
    static Array_Empty := ComObjArray(0xC,0), nulo := ComObject(13,0)
    
    return Assembly.CreateInstance_3(TypeName, true, 0, nulo, vargs, nulo, Array_Empty)
}

CLR_CompileC#(Code, References="", AppDomain=0, FileName="", CompilerOptions="")
{
    return CLR_CompileAssembly(Code, References, "System", "Microsoft.CSharp.CSharpCodeProvider", AppDomain, FileName, CompilerOptions)
}

CLR_CompileVB(Code, References="", AppDomain=0, FileName="", CompilerOptions="")
{
    return CLR_CompileAssembly(Code, References, "System", "Microsoft.VisualBasic.VBCodeProvider", AppDomain, FileName, CompilerOptions)
}

CLR_StartDomain(ByRef AppDomain, BaseDirectory="")
{
    static nulo := ComObject(13,0)
    args := ComObjArray(0xC, 5), args[0] := "", args[2] := BaseDirectory, args[4] := ComObject(0xB,false)
    AppDomain := CLR_GetDefaultDomain().GetType().InvokeMember_3("CreateDomain", 0x158, nulo, nulo, args)
    return A_LastError >= 0
}

CLR_StopDomain(ByRef AppDomain)
{   ; ICorRuntimeHost::UnloadDomain
    DllCall("SetLastError", "uint", hr := DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+20*A_PtrSize), "ptr", RtHst, "ptr", ComObjValue(AppDomain))), AppDomain := ""
    return hr >= 0
}

; NOTE: IT IS NOT NECESSARY TO CALL THIS FUNCTION unless you need to load a specific version.
CLR_Start(Version="") ; returns ICorRuntimeHost*
{
    static RtHst := 0
    ; The simple method gives no control over versioning, and seems to load .NET v2 even when v4 is present:
    ; return RtHst ? RtHst : (RtHst:=COM_CreateObject("CLRMetaData.CorRuntimeHost","{CB2F6722-AB3A-11D2-9C40-00C04FA30A3E}"), DllCall(NumGet(NumGet(RtHst+0)+40),"uint",RtHst))
    if RtHst
        return RtHst
    EnvGet SystemRoot, SystemRoot
    if Version =
        Loop % SystemRoot "\Microsoft.NET\Framework" (A_PtrSize=8?"64":"") "\*", 2
            if (FileExist(A_LoopFileFullPath "\mscorlib.dll") && A_LoopFileName > Version)
                Version := A_LoopFileName
    if DllCall("mscoree\CorBindToRuntimeEx", "wstr", Version, "ptr", 0, "uint", 0
    , "ptr", CLR_GUID(CLSID_CorRuntimeHost, "{CB2F6723-AB3A-11D2-9C40-00C04FA30A3E}")
    , "ptr", CLR_GUID(IID_ICorRuntimeHost,  "{CB2F6722-AB3A-11D2-9C40-00C04FA30A3E}")
    , "ptr*", RtHst) >= 0
        DllCall(NumGet(NumGet(RtHst+0)+10*A_PtrSize), "ptr", RtHst) ; Start
    return RtHst
}

;
; INTERNAL FUNCTIONS
;

CLR_GetDefaultDomain()
{
    static defaultDomain := 0
    if !defaultDomain
    {   ; ICorRuntimeHost::GetDefaultDomain
        if DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+13*A_PtrSize), "ptr", RtHst, "ptr*", p:=0) >= 0
            defaultDomain := ComObject(p), ObjRelease(p)
    }
    return defaultDomain
}

CLR_CompileAssembly(Code, References, ProviderAssembly, ProviderType, AppDomain=0, FileName="", CompilerOptions="")
{
    if !AppDomain
        AppDomain := CLR_GetDefaultDomain()
    
    if !(asmProvider := CLR_LoadLibrary(ProviderAssembly, AppDomain))
    || !(codeProvider := asmProvider.CreateInstance(ProviderType))
    || !(codeCompiler := codeProvider.CreateCompiler())
        return 0

    if !(asmSystem := (ProviderAssembly="System") ? asmProvider : CLR_LoadLibrary("System", AppDomain))
        return 0
    
    ; Convert | delimited list of references into an array.
    StringSplit, Refs, References, |, %A_Space%%A_Tab%
    aRefs := ComObjArray(8, Refs0)
    Loop % Refs0
        aRefs[A_Index-1] := Refs%A_Index%
    
    ; Set parameters for compiler.
    prms := CLR_CreateObject(asmSystem, "System.CodeDom.Compiler.CompilerParameters", aRefs)
    , prms.OutputAssembly          := FileName
    , prms.GenerateInMemory        := FileName=""
    , prms.GenerateExecutable      := SubStr(FileName,-3)=".exe"
    , prms.CompilerOptions         := CompilerOptions
    , prms.IncludeDebugInformation := true
    
    ; Compile!
    compilerRes := codeCompiler.CompileAssemblyFromSource(prms, Code)
    
    if error_count := (errors := compilerRes.Errors).Count
    {
        error_text := ""
        Loop % error_count
            error_text .= ((e := errors.Item[A_Index-1]).IsWarning ? "Warning " : "Error ") . e.ErrorNumber " on line " e.Line ": " e.ErrorText "`n`n"
        MsgBox, 16, Compilation Failed, %error_text%
        return 0
    }
    ; Success. Return Assembly object or path.
    return compilerRes[FileName="" ? "CompiledAssembly" : "PathToAssembly"]
}

CLR_GUID(ByRef GUID, sGUID)
{
    VarSetCapacity(GUID, 16, 0)
    return DllCall("ole32\CLSIDFromString", "wstr", sGUID, "ptr", &GUID) >= 0 ? &GUID : ""
}