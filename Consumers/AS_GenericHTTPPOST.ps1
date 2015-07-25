$script = @"
Set objHTTP = CreateObject("Microsoft.XMLHTTP")
objHTTP.open "POST", "http://192.168.188.132/", False

objHTTP.setRequestHeader "User-Agent", "DoYouEven-TF12-Bro?"

Dim outputString

outputString = outputString & "{'" & TargetEvent.TargetInstance.Path_.Class & "': {" & vbCrLf

outputString = outputString & vbTab & "'Server': '" & TargetEvent.Path_.Server & "'" & vbCrLf

For Each oProp in TargetEvent.TargetInstance.Properties_
     outputString = outputString & vbTab & "'" & oProp.Name & "': '" & oProp & "'," & vbCrLf
Next

outputString = outputString & "}}"
 
objHTTP.send outputString

Set objHTTP = Nothing
"@

$props = @{
    'Name' = 'AS_GenericHTTPPOST';
    'ScriptText' = $script;
}