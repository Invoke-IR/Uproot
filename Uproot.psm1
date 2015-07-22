<## 
Consumers

TODO:
Add ability to get all Consumers
Add CommandLineEventConsumer Support
CommandLine CommandLineTemplate or ExecutablePath

##>

# Read in all ps1 files in the Cmdlets Directory
Get-ChildItem $PSScriptRoot |
    ? {$_.PSIsContainer -and ($_.Name -eq 'Cmdlets')} |
    % {Get-ChildItem "$($_.FullName)\*" -Include '*.ps1'} |
    % {. $_.FullName}


