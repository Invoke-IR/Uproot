$props = @{
    'Name' = 'INT-ShareCreation';
    'EventNamespace' = 'root/cimv2';
    'Query' = "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_Share'";
    'QueryLanguage' = 'WQL';
}