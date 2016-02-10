$props = @{
    'Name' = 'EXT-WmiProcessEnum';
    'EventNamespace' = 'root/cimv2';
    'Query' = 'SELECT * FROM MSFT_WmiProvider_CreateInstanceEnumAsyncEvent_Pre WHERE ClassName="Win32_Process"';
    'QueryLanguage' = 'WQL';
}