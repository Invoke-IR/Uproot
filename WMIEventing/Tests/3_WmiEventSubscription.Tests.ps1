Import-Module -Force $PSScriptRoot\..\WMIEventing.psd1

Get-WmiEventSubscription | Remove-WmiEventSubscription

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

Add-WmiEventFilter -Name filter0 -Query 'SELECT * FROM Win32_ProcessStartTrace'
Add-WmiEventFilter -Name filter1 -Query 'SELECT * FROM Win32_ProcessStartTrace'
Add-WmiEventFilter -Name filter2 -Query 'SELECT * FROM Win32_ProcessStartTrace'
Add-WmiEventFilter -Name filter3 -Query 'SELECT * FROM Win32_ProcessStartTrace'
Add-WmiEventFilter -Name filter4 -Query 'SELECT * FROM Win32_ProcessStartTrace'
Add-WmiEventConsumer -Name AS_consumer -ScriptingEngine VBScript -ScriptText $script

Describe 'Get-WmiEventSubscription' {

    Context 'no registered subscriptions' {

        It 'should return gracefully' {
            { Get-WmiEventSubscription } | Should Not Throw
        }
    }
}

Describe 'Add-WmiEventSubscription' {    
    
    Context 'FilterName, ConsumerName and ConsumerType parameters specified on the commandline' { 
        
        It 'should add a local __FilterToConsumerBinding (filter0)' {
            { Add-WmiEventSubscription -FilterName filter0 -ConsumerName AS_consumer -ConsumerType ActiveScriptEventConsumer } | Should Not Throw
        }        
    }
}

Add-WmiEventSubscription -FilterName filter1 -ConsumerName AS_consumer -ConsumerType ActiveScriptEventConsumer
Add-WmiEventSubscription -FilterName filter2 -ConsumerName AS_consumer -ConsumerType ActiveScriptEventConsumer
Add-WmiEventSubscription -FilterName filter3 -ConsumerName AS_consumer -ConsumerType ActiveScriptEventConsumer
Add-WmiEventSubscription -FilterName filter4 -ConsumerName AS_consumer -ConsumerType ActiveScriptEventConsumer


Describe 'Get-WmiEventSubscription' {    
    
    Context 'five registered subscriptions' { 
        
        It 'should get all local __FilterToConsumerBindings' {
            $subscriptions = Get-WmiEventSubscription 
            $subscriptions.Length | Should Be 5
        }

        It 'should get a local __FilterToConsumerBinding by name (filter0)' {
            $subscription = Get-WmiEventSubscription -Name filter0
            $subscription.FilterName | Should Be 'filter0'
        }
    }
}

Describe 'Remove-WmiEventSubscription' {    
    
    Context 'five registered subscriptions' { 
        
        It 'should remove a local __FilterToConsumerBinding by name (filter0)' {
            Remove-WmiEventSubscription -Name filter0
            Get-WmiEventSubscription -Name filter0 | Should Be $Null
        }

        It 'should remove a local __FilterToConsumerBinding through the pipeline (filter1)' {
            Get-WmiEventSubscription -Name filter1 | Remove-WmiEventSubscription
            Get-WmiEventSubscription -Name filter1 | Should Be $Null
        }

        It 'should remove all local __FilterToConsumerBindings' {
            Remove-WmiEventSubscription
            Get-WmiEventSubscription | Should Be $Null
        }
    }

    Context 'no registered subscriptions' {

        It 'should not fail' {
            { Remove-WmiEventSubscription } | Should Not Throw
        }
    }
}