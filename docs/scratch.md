## We need a default config for server URI and how to fetch creds

``` powershell
$Module = Get-Module BigSleep
$Module | Export-Configuration @{
    ServerUri = 'https://your.bigfix.server.com:52311/api'
    CredentialFetcher = {A scriptblock that returns a PSCredential}
}
$Module | Get-ConfigurationPath
```

~\AppData\Roaming\powershell\DustyFox\BigSleep
Author of Configuration module says it works on BSD/*nix
Defaults can be pushed, supports cascading user/system configs

## Sample snippets

$Computers = Invoke-BigfixRestMethod computers
$Computers.BESAPI.Computer
$Computer = Invoke-BigfixRestMethod $Computers.BESAPI.Computer[0].Resource
$Computer.BESAPI.Computer.Property


$Actions = Invoke-BigfixRestMethod -Uri actions
$Action = Invoke-BigfixRestMethod $Actions.BESAPI.Action[0].Resource
$Action.BES.SingleAction.ActionScript


$Tasks = Invoke-BigfixRestMethod -Uri tasks/master
$Task = Invoke-BigfixRestMethod @($Tasks.BESAPI.Task)[0].Resource
$Task.BES.Task.Action
$Task.BES.Task.Action.ActionScript
$Task.BES.Task.GroupRelevance.SearchComponentPropertyReference


$Sites = Invoke-BigfixRestMethod sites
$Sites.BESAPI.OperatorSite | ? Name -eq $env:USERNAME
