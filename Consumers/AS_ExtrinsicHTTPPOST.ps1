$script = @"
Set objSysInfo = CreateObject("WinNTSystemInfo")
Set objHTTP = CreateObject("Microsoft.XMLHTTP")

objHTTP.open "POST", "http://127.0.0.1/", False

objHTTP.setRequestHeader "User-Agent", "UprootIDS"

Dim outputString

outputString = outputString & "{""TargetEvent"":{"
outputString = outputString & """EventType"":""ExtrinsicEvent"","
outputString = outputString & """TimeCreated"":""" & TargetEvent.Time_Created & ""","
outputString = outputString & """Server"":""" & objSysInfo.ComputerName & ""","
outputString = outputString & """InstanceType"":""" & TargetEvent.Path_.Class & ""","
outputString = outputString & """TargetInstance"":{"

For Each oProp in TargetEvent.Properties_
     If oProp.Name <> "Sid" Then
        outputString = outputString & """" & oProp.Name & """:" & """" & oProp & ""","
    End If
Next

outputString = Left(outputString, Len(outputString) - 1)
outputString = outputString & "}"
outputString = outputString & "}}"

objHTTP.send outputString

Set objHTTP = Nothing
"@

$props = @{
    'Name' = 'AS_ExtrinsicHTTPPOST';
    'ScriptText' = $script;
}