function Get-Fixlet
{
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline, Mandatory)]
        [object]$Site,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int]$Id
    )

    process
    {
        if ($Site -eq "master" -or $Site.Name -eq "master")
        {
            $SiteString = "master"
        }
        else
        {
            $SiteString = $Site.Type.ToLower(), $Site.Name -join "/"
        }


        if (-not $PSBoundParameters.ContainsKey("Id"))
        {
            $X = Invoke-BigfixRestMethod "fixlets/$SiteString"
            return $X.BESAPI.Fixlet | Get-Fixlet -Site $Site
        }


        $Fixlet = [pscustomobject]@{Id = $Id}

        $X = Invoke-BigfixRestMethod "fixlet/$SiteString/$Id"
        $XProps = $X.BES.Fixlet |
            Get-Member -MemberType Property |
            Select-Object -ExpandProperty Name

        $XProps | Where-Object Name -ne "ID" | ForEach-Object {
            $Name = $_
            $Value = $X.BES.Fixlet.$Name
            $Fixlet | Add-Member NoteProperty $Name $Value -Force
        }

        $Fixlet
    }
}
