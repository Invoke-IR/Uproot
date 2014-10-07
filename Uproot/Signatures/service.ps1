$FilePath = 'C:\Users\assessor\Desktop\'

#SERVICE_CREATION
$Name = 'SERVICE_CREATION'
$Query = "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Service'"
$Text = "%TIME_CREATED%|UTC|N/A|UPR|Uproot|$Name|%TargetInstance.Name% Service Created|ComputerName: %TargetInstance.SystemName%, Name: %TargetInstance.Name%, Path: %TargetInstance.PathName%, DisplayName: %TargetInstance.DisplayName%, State: %TargetInstance.State%, StartMode: %TargetInstance.StartMode%, ServiceType: %TargetInstance.ServiceType%"

Add-Signature -Name $Name -Query $Query -FilePath $FilePath -Text $Text -Type "LogFile"

#SERVICE_DELETION
$Name = 'SERVICE_DELETION'
$Query = "SELECT * FROM __InstanceDeletionEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Service'"
$Text = "%TIME_CREATED%|UTC|N/A|UPR|Uproot|$Name|%TargetInstance.Name% Service Deleted|ComputerName: %TargetInstance.SystemName%, Name: %TargetInstance.Name%, Path: %TargetInstance.PathName%, DisplayName: %TargetInstance.DisplayName%, State: %TargetInstance.State%, StartMode: %TargetInstance.StartMode%, ServiceType: %TargetInstance.ServiceType%"

Add-Signature -Name $Name -Query $Query -FilePath $FilePath -Text $Text -Type "LogFile"