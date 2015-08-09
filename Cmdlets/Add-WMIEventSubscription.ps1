function Add-WmiEventSubscription
{
    [CmdletBinding(DefaultParameterSetName = 'Name')]
    Param(
        [Parameter(Mandatory = $False, ValueFromPipeline = $True)]
            [string[]]$ComputerName = 'localhost',
        [Parameter(Mandatory = $True, ParameterSetName = 'Name')]
            [string]$FilterName,
        [Parameter(Mandatory = $True, ParameterSetName = 'Name')]
            [string]$ConsumerName,
        [Parameter(Mandatory = $True, ParameterSetName = 'Path')]
            [string]$FilterPath,
        [Parameter(Mandatory = $True, ParameterSetName = 'Path')]
            [string]$ConsumerPath
    )

    BEGIN
    {

    }

    PROCESS
    {
        foreach($computer in $ComputerName)
        {
            $class = [WMICLASS]"\\$computer\root\subscription:__FilterToConsumerBinding"
            
            $instance = $class.CreateInstance()
            if($PSCmdlet.ParameterSetName -eq 'Name')
            {
                $instance.Filter = (Get-WMIEventFilter -ComputerName $computer -Name $FilterName).Path
                $instance.Consumer = (Get-WMIEventConsumer -ComputerName $computer -Name $ConsumerName).Path
            }
            elseif($PSCmdlet.ParameterSetName -eq 'Path')
            {
                $instance.Filter = $FilterPath
                $instance.Consumer = $ConsumerPath
            }

            $instance.Put()
        }
    }
}