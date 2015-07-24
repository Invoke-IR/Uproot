$props = @{
    'Name' = 'UserCreation';
    'EventNamespace' = 'root/cimv2';
    'Query' = "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_User'";
    'QueryLanguage' = 'WQL';
}