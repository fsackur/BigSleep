## API ref

https://developer.bigfix.com/rest-api/
https://github.com/bigfix/

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

# Building docker test instance

git clone https://github.com/bigfix/bfdocker
$env:BES_VERSION="9.2.6.94"
$env:BES_ACCEPT="true"
./besserver/build.sh
<!-- in theory... in practice, I had to exec in to run thru the install wizard -->

docker run -d -e DB2INST1_PASSWORD=BigFix1t4Me -e LICENSE=accept --hostname=eval.mybigfix.com --name=eval.mybigfix.com -p 80:80 -p 52311:52311 -p 52311:52311/udp bfdocker/besserver /bes-start.sh

## Objects mapped from XML nodes

It's not too hard to generalise pulling XML nodes according to a schema.

However, when we want object mutation to result in XML changes, then it's harder.

It's pretty challenging in pure Powershell to detect member addition. Member addition happens in [PSMemberInfoIntegratingCollection](https://github.com/PowerShell/PowerShell/blob/50fd950920c9961e6437d6d9c3caf98d10ae2307/src/System.Management.Automation/engine/MshMemberInfo.cs#L4672) and again in [L4683](https://github.com/PowerShell/PowerShell/blob/50fd950920c9961e6437d6d9c3caf98d10ae2307/src/System.Management.Automation/engine/MshMemberInfo.cs#L4683). However, that's an internal calss, so even with reflection we can't just derive from this and stick it into our PSObject.

In PSv5 we can use [System.Runtime.Remoting.Proxies.RealProxy] and in PSv7 we can use [System.Reflection.DispatchProxy]. On both versions, probably, we can use [Castle DynamicProxy](http://www.castleproject.org/projects/dynamicproxy/) at the cost of adding a dependency.

See https://devblogs.microsoft.com/dotnet/migrating-realproxy-usage-to-dispatchproxy/

## Schema parsing

https://docs.microsoft.com/en-us/dotnet/standard/data/xml/process-xml-data-using-linq-to-xml

https://docs.microsoft.com/en-us/dotnet/standard/data/xml/xml-schema-object-model-som

```
$xr = [System.Xml.XmlTextReader]::new("C:\dev\BigSleep\Schema\BESAPI.xsd")
$xs = [System.Xml.Schema.XmlSchema]::Read($xr, {$_ | Out-String | Write-Host})
$xs.Items[4].Particle.Items[1]
```
