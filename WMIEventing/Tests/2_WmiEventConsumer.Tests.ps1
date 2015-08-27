Import-Module -Force $PSScriptRoot\..\WMIEventing.psd1

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
outputString = outputString & """TimeCreated"":""" & TargetEvent.Time_Created & ""","
outputString = outputString & """SourceIP"":""" & ipString & ""","
outputString = outputString & """Server"":""" & objSysInfo.ComputerName & ""","

If ((TargetEvent.Path_.Class = "__NamespaceOperationEvent") Or (TargetEvent.Path_.Class = "__NamespaceModificationEvent") Or (TargetEvent.Path_.Class = "__NamespaceDeletionEvent") Or (TargetEvent.Path_.Class = "__NamespaceCreationEvent") Or (TargetEvent.Path_.Class = "__ClassOperationEvent") Or (TargetEvent.Path_.Class = "__ClassModificationEvent") Or (TargetEvent.Path_.Class = "__ClassCreationEvent") Or (TargetEvent.Path_.Class = "__InstanceOperationEvent") Or (TargetEvent.Path_.Class = "__InstanceCreationEvent") Or (TargetEvent.Path_.Class = "__MethodInvocationEvent") Or (TargetEvent.Path_.Class = "__InstanceModificationEvent") Or (TargetEvent.Path_.Class = "__InstanceDeletionEvent") Or (TargetEvent.Path_.Class = "__TimerEvent")) Then
    outputString = outputString & """EventType"":""" & TargetEvent.Path_.Class & ""","
    outputString = outputString & """InstanceType"":""" & TargetEvent.TargetInstance.Path_.Class & ""","
    outputString = outputString & """TargetInstance"":{"

    For Each oProp in TargetEvent.TargetInstance.Properties_
         outputString = outputString & """" & oProp.Name & """:""" & oProp & ""","
    Next
Else
    outputString = outputString & """EventType"":""ExtrinsicEvent"","
    outputString = outputString & """InstanceType"":""" & TargetEvent.Path_.Class & ""","
    outputString = outputString & """TargetInstance"":{"

    For Each oProp in TargetEvent.Properties_
         If oProp.Name <> "Sid" Then
            outputString = outputString & """" & oProp.Name & """:" & """" & oProp & ""","
        End If
    Next
End If

outputString = Left(outputString, Len(outputString) - 1)
outputString = outputString & "}"
outputString = outputString & "}}"

objHTTP.send outputString

Set objHTTP = Nothing
"@

Remove-WmiEventConsumer

Describe 'Get-WmiEventConsumer' {

    Context 'no registered consumers' {

        It 'should return gracefully' {
            { Get-WmiEventConsumer } | Should Not Throw
        }
    }
}

Describe 'Add-WmiEventConsumer' {    
    
    Context 'ActiveScriptEventConsumer ScriptText' { 
        
        It 'should add successfully (AS_consumer)' {
            { Add-WmiEventConsumer -Name AS_consumer -ScriptingEngine VBScript -ScriptText $script } | Should Not Throw
        }
    }

        #It 'Should add a local CommandLineEventConsumer' {
        #    { Add-WmiEventConsumer -Name CL_consumer -Query 'SELECT * FROM Win32_ProcessStartTrace' } | Should Not Throw
        #}
    
    Context 'LogFileEventConsumer Filename and Text' {

        It 'should add successfully (LF_consumer)' {
            { Add-WmiEventConsumer -Name LF_consumer -Filename C:\Windows\Temp\test.txt -Text "%TargetInstance%" } | Should Not Throw
        }
    }

        #It 'Should add a local NtEventLogEventConsumer' {
        #    { Add-WmiEventConsumer -Name EL_consumer -Query 'SELECT * FROM Win32_ProcessStartTrace' } | Should Not Throw
        #}

        #It 'Should add a local SMTPEventConsumer' {
        #    { Add-WmiEventConsumer -Name SMTP_consumer -Query 'SELECT * FROM Win32_ProcessStartTrace' } | Should Not Throw
        #}
}

Add-WmiEventConsumer -Name AS_consumer1 -ScriptingEngine VBScript -ScriptText $script
Add-WmiEventConsumer -Name AS_consumer2 -ScriptingEngine VBScript -ScriptText $script
Add-WmiEventConsumer -Name AS_consumer3 -ScriptingEngine VBScript -ScriptText $script

Describe 'Get-WmiEventConsumer' {    
    
    Context 'five registered consumers' { 
        
        It 'should get all local __EventConsumers' {
            $consumers = Get-WmiEventConsumer
            $consumers.Length | Should Be 5
        }

        It 'should get a local __EventConsumer by Name (AS_consumer)' {
            $consumer = Get-WmiEventConsumer -Name AS_consumer
            $consumer.Name | Should Be 'AS_consumer'
        }      
    }
}

Describe 'Remove-WmiEventConsumer' {    
    
    Context 'five registered consumers' { 
        
        It 'should remove a local __EventConsumer by name (AS_consumer)' {
            Remove-WmiEventConsumer -Name AS_consumer
            Get-WmiEventConsumer -Name AS_consumer | Should Be $Null
        }

        It 'should remove a local __EventConsumer through the pipeline (LF_consumer)' {
            Get-WmiEventConsumer -Name LF_consumer | Remove-WmiEventFilter
            Get-WmiEventConsumer -Name LF_consumer | Should Be $Null
        }

        It 'should remove all local __EventConsumers' {
            Remove-WmiEventConsumer
            Get-WmiEventConsumer | Should Be $Null
        }
    }

    Context 'no registered consumers' {

        It 'should not fail' {
            { Remove-WmiEventConsumer } | Should Not Throw
        }  
    }
}