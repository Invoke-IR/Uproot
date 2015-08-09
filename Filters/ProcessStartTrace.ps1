$props = @{
    'Name' = 'ProcessStartTrace';
    'EventNamespace' = 'root/cimv2';
    'Query' = "SELECT * FROM Win32_ProcessStartTrace";
    'QueryLanguage' = 'WQL';
}