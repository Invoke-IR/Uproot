$props = @{
    'Name' = 'StartupCommandCreation';
    'EventNamespace' = 'root/cimv2';
    'Query' = "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_StartupCommand'";
    'QueryLanguage' = 'WQL';
}