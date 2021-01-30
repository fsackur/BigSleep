function Get-Site
{
    [CmdletBinding(DefaultParameterSetName = "AllSites")]
    param
    (
        [Parameter(ParameterSetName = "BySite", Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter(ParameterSetName = "BySite", Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet("custom", "external", "operator", "action")]
        [string]$Type
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq "AllSites")
        {
            $X = Invoke-BigfixRestMethod "sites"

            return $X.BESAPI.PSObject.Properties |
                Where-Object Name -like "*Site" |
                # Select-Object -ExpandProperty Value |
                ForEach-Object {
                    $Type = $_.Name -replace "Site$"
                    $_.Value | ForEach-Object {
                        [pscustomobject]@{
                            Type      = $Type
                            Name      = $_.Resource -replace ".*/"
                            GatherUrl = $_.GatherURL
                        }
                    }
                }
        }
        else
        {
            if ($Type -eq "action" -and $Name -eq "master")
            {
                $Uri = "site/master"
            }
            else
            {
                $Uri = "site", $Type.ToLower(), $Name -join "/"
            }

            $Initial, $Remainder = $Type -split '(?<=^.)'
            $Type = $Initial.ToUpper(), $Remainder.ToLower() -join ""

            $X = Invoke-BigfixRestMethod $Uri
            $X.BES.PSObject.Properties |
                Where-Object Name -like "*Site" |
                Select-Object -ExpandProperty Value |
                ForEach-Object {
                    [pscustomobject]@{
                        Type      = $Type
                        Name      = if ($Name -eq "master") {$Name} else {$_.Name}
                        GatherUrl = $_.GatherURL
                    }
                }

        }
    }
}
