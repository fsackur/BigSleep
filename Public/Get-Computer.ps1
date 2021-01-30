function Get-Computer
{
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int]$Id
    )

    process
    {
        if (-not $PSBoundParameters.ContainsKey("Id"))
        {
            $X = Invoke-BigfixRestMethod "computers"
            return $X.BESAPI.Computer | Get-Computer
        }


        $Computer = [pscustomobject]@{Id = $Id}

        $X = Invoke-BigfixRestMethod "computer/$Id"
        $XProps = $X.BESAPI.Computer.Property | Group-Object Name

        $XProps | Where-Object Name -ne "ID" | ForEach-Object {
            $Name = $_.Name
            $Value = $_.Group."#text"
            $Computer | Add-Member NoteProperty $Name $Value -Force
        }

        $Computer
    }
}
