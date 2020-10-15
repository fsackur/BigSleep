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
