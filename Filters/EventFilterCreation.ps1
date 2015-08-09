$props = @{
    'Name' = 'EventFilterCreation';
    'EventNamespace' = 'root/subscription';
    'Query' = "SELECT * FROM __InstanceCreationEvent WITHIN 10 WHERE TargetInstance ISA '__EventFilter'";
    'QueryLanguage' = 'WQL'
}