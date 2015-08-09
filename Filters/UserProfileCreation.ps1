$props = @{
    'Name' = 'UserProfileCreation';
    'EventNamespace' = 'root/cimv2';
    'Query' = "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA 'Win32_UserProfile'";
    'QueryLanguage' = 'WQL';
}