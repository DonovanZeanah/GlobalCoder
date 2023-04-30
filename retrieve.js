function getText(strURL)
{
    var strResult;

    try
    {
        // Create the WinHTTPRequest ActiveX Object.
        var WinHttpReq = new ActiveXObject(
                                  "WinHttp.WinHttpRequest.5.1");

        //  Create an HTTP request.
        var temp = WinHttpReq.Open("GET", strURL, false);

        //  Send the HTTP request.
        WinHttpReq.Send();

        //  Retrieve the response text.
        strResult = WinHttpReq.ResponseText;
    }
    catch (objError)
    {
        strResult = objError + "\n"
        strResult += "WinHTTP returned error: " + 
            (objError.number & 0xFFFF).toString() + "\n\n";
        strResult += objError.description;
    }

    //  Return the response text.
    return strResult;
}

WScript.Echo(getText("https://www.microsoft.com/default.htm"));