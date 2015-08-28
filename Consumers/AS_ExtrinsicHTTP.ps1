if($ListeningPostIP -eq $Null){
    $ListeningPostIP = Read-Host "Please enter the IP of your Listening Post"
}

$script = @"
Set objSysInfo = CreateObject("WinNTSystemInfo")
Set objHTTP = CreateObject("Microsoft.XMLHTTP")

objHTTP.open "POST", "http://$($ListeningPostIP)/", False
objHTTP.setRequestHeader "User-Agent", "UprootIDS"


Dim ipString

Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\localhost\root\cimv2")
Set IPConfigSet = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled=TRUE")

For Each IPConfig in IPConfigSet
    If Not IsNull(IPConfig.IPAddress) Then 
         ipString = IPConfig.IPAddress(0)
    End If
Next


Dim outputString

outputString = outputString & "{""TargetEvent"":{"
outputString = outputString & """EventType"":""ExtrinsicEvent"","
outputString = outputString & """TimeCreated"":""" & TargetEvent.Time_Created & ""","
outputString = outputString & """SourceIP"":""" & ipString & ""","
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
    'Name' = 'AS_ExtrinsicHTTP';
    'ScriptText' = $script;
}