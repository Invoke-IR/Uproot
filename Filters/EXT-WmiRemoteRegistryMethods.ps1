$props = @{
    'Name' = 'EXT-WmiRemoteRegistryMethods';
    'EventNamespace' = 'root/cimv2';
    'Query' = 'SELECT * FROM MSFT_WmiProvider_ExecMethodAsyncEvent_Pre WHERE ObjectPath="StdRegProv"';
    'QueryLanguage' = 'WQL';
}