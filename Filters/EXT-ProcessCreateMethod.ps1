$props = @{
    'Name' = 'EXT-ProcessCreateMethod';
    'EventNamespace' = 'root/cimv2';
    'Query' = 'SELECT * FROM MSFT_WmiProvider_ExecMethodAsyncEvent_Pre WHERE ObjectPath="Win32_Process" AND MethodName="Create"';
    'QueryLanguage' = 'WQL';
}