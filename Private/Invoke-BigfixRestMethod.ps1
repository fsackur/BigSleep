function Invoke-BigfixRestMethod
{
    <#
        .SYNOPSIS
        A wrapper for Invoke-RestMethod that injects default values from $Script:Config.

        .NOTES
        Largely generated with MetaProgramming: see PSGallery
    #>
    [CmdletBinding()]
    param
    (
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        ${Method},

        [switch]
        ${UseBasicParsing},

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [uri]
        ${Uri},

        [Microsoft.PowerShell.Commands.WebRequestSession]
        ${WebSession},

        [Alias('SV')]
        [string]
        ${SessionVariable},

        [pscredential]
        [System.Management.Automation.CredentialAttribute()]
        ${Credential},

        [switch]
        ${UseDefaultCredentials},

        [ValidateNotNullOrEmpty()]
        [string]
        ${CertificateThumbprint},

        [ValidateNotNull()]
        [X509Certificate]
        ${Certificate},

        [string]
        ${UserAgent},

        [switch]
        ${DisableKeepAlive},

        [ValidateRange(0, 2147483647)]
        [int]
        ${TimeoutSec},

        [System.Collections.IDictionary]
        ${Headers},

        [ValidateRange(0, 2147483647)]
        [int]
        ${MaximumRedirection},

        [uri]
        ${Proxy},

        [pscredential]
        [System.Management.Automation.CredentialAttribute()]
        ${ProxyCredential},

        [switch]
        ${ProxyUseDefaultCredentials},

        [Parameter(ValueFromPipeline = $true)]
        [object]
        ${Body},

        [string]
        ${ContentType},

        [ValidateSet('chunked', 'compress', 'deflate', 'gzip', 'identity')]
        [string]
        ${TransferEncoding},

        [string]
        ${InFile},

        [string]
        ${OutFile},

        [switch]
        ${PassThru}
    )

    begin
    {
        #region Inject module defaults
        if (-not $ContentType)
        {
            $PSBoundParameters.ContentType = 'application/xml'
        }

        if (-not $Uri.IsAbsoluteUri)
        {
            $PSBoundParameters.Uri = "{0}/{1}" -f ($Script:Config.ServerUri -replace '/$'), ($Uri -replace '^/')
        }

        if (-not $Credential)
        {
            $PSBoundParameters.Credential = & $Script:Config.CredentialFetcher
        }
        #endregion Inject module defaults


        try
        {
            $OutBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$OutBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }

            $WrappedCmd        = $ExecutionContext.InvokeCommand.GetCommand('Invoke-RestMethod', 'All')
            $ScriptCmd         = {& $WrappedCmd @PSBoundParameters}
            $SteppablePipeline = $ScriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)

            $SteppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }
    }

    process
    {
        try
        {
            $SteppablePipeline.Process($_)
        }
        catch
        {
            throw
        }
    }

    end
    {
        try
        {
            $SteppablePipeline.End()
        }
        catch
        {
            throw
        }
    }
}
