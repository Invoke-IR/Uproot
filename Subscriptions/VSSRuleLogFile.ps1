$ComputerName = 'localhost'
$filter = TestAdd-WMIEventFilter -ComputerName $ComputerName -Name VolumeShadowCreation -Query "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_ShadowCopy'"
$consumer = TestAdd-WMIEventConsumer -ComputerName $ComputerName -Name GenericTextFileOutputter -Filename C:\Users\Uproot\Desktop\event.txt -Text "%TargetInstance%"
TestAdd-WMIEventSubscription -ComputerName $ComputerName -FilterPath $filter.path -ConsumerPath $consumer.path