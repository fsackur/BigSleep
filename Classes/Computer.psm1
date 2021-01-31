# Import at CLI:
# using module Classes/Computer.psm1
# Get-Content Classes/Computer.psm1 -Raw | Invoke-Expression   # to reimport

class Computer
{
    hidden static [string] $_XPathBase = "BESAPI/Computer"
    hidden static [Collections.IDictionary] $_PropertyMap = @{
        Properties = "BESAPI/Computer/Property"
        Settings   = "BESAPI/ComputerSettings/Setting"
        # Fixlets    = ""
        # Tasks      = ""
        # Analyses   = ""
        # Baselines  = ""
        # Mailbox    = ""
    }


    hidden [xml] $_Xml

    [string]$Id

    Computer([string]$Id)
    {
        $this.Id = $Id
        $this._InitialiseMappedProperties()
    }

    Computer([xml]$Xml)
    {
        $Node = $Xml | Select-Xml -XPath ([Computer]::_XPathBase) | Select-Object -ExpandProperty Node
        if ($Node.Count -gt 1 -or -not $Node)
        {
            throw [ArgumentException]::new(
                "Supplied XML must contain exactly one node at path $([Computer]::_XPathBase)."
            )
        }

        $this.Id = ([uri]$Node.Resource).Segments[-1]
        $this._Xml = $Xml
        $this._InitialiseMappedProperties()
    }

    hidden [void] _InitialiseMappedProperties()
    {
        foreach ($Kvp in [Computer]::_PropertyMap.GetEnumerator())
        {
            $PropertyName = $Kvp.Key
            $Selector = $Kvp.Value
            Remove-Variable Kvp

            $this | Add-Member ScriptProperty $PropertyName `
                <# get #> `
                -Value {
                    $this._Xml | Select-Xml -XPath $Selector | Select-Object -ExpandProperty Node
                }.GetNewClosure() `
                `
                <# set #> `
                -SecondValue {
                    throw [NotImplementedException]::new("Setter not implemented for '$PropertyName'.")
                }.GetNewClosure()
        }
    }
}
