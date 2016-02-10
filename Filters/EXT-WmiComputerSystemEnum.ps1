$props = @{
    'Name' = 'EXT-WmiComputerSystemEnum';
    'EventNamespace' = 'root/cimv2';
    'Query' = 'SELECT * FROM MSFT_WmiProvider_CreateInstanceEnumAsyncEvent_Pre WHERE ClassName="Win32_ComputerSystem"';
    'QueryLanguage' = 'WQL';
}