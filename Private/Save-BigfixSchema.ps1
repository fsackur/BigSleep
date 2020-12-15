function Save-BigfixSchema
{
    [CmdletBinding()]
    param
    (
        [string]$Path = '.'
    )

    $Uri = "{0}/{1}" -f ($Script:Config.ServerUri -replace '/$' -replace '/api$'), "xmlschema/BES.xsd"

    Invoke-WebRequest $Uri -Credential (& $Script:Config.CredentialFetcher) -OutFile (Join-path $Path "BES.xsd")

    $Uri = $Uri -replace 'BES.xsd$', 'BESAPI.xsd'

    Invoke-WebRequest $Uri -Credential (& $Script:Config.CredentialFetcher) -OutFile (Join-path $Path "BESAPI.xsd")
}
