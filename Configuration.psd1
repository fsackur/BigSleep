@{
    # Default values
    ServerUri         = 'https://your.bigfix.server.com:52311/api'
    CredentialFetcher = (scriptblock 'Write-Host "Provide a scriptblock that returns a PSCredential"')
}
