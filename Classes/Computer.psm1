using module ./PropertyList.psm1
# Import at CLI:
# using module Classes/Computer.psm1
# Get-Content Classes/Computer.psm1 -Raw | Invoke-Expression   # to reimport

class PropertySelector
{
    [string]$XPath
    [scriptblock]$Process = {$_}

    PropertySelector([string]$XPath)
    {
        $this.XPath = $XPath
    }

    PropertySelector([Collections.IDictionary]$Properties)
    {
        foreach ($Kvp in $Properties.GetEnumerator())
        {
            $this.$($Kvp.Key) = $Kvp.Value
        }
    }
}


class Computer
{
    hidden static [string] $_XPathBase = "BESAPI/Computer"
    hidden static [Collections.Generic.IDictionary[string, PropertySelector]] $_PropertyMap
    static Computer()
    {
        $Map = @{
            Properties = @{
                XPath   = "BESAPI/Computer/Property"
                Process = {
                    param([Xml.XmlElement[]]$Node)
                    $Node |
                        ForEach-Object {[pscustomobject]@{Name = $_.Name; Value = $_.'#text'}} |
                        Group-Object Name |
                        ForEach-Object {
                            if ($_.Count -gt 1)
                            {
                                [pscustomobject]@{Name = $_.Name; Value = [PropertyList]$_.Group.Value}
                            }
                            else
                            {
                                $_.Group
                            }
                        }
                }
            }
            Settings   = "BESAPI/ComputerSettings/Setting"
            # Fixlets    = ""
            # Tasks      = ""
            # Analyses   = ""
            # Baselines  = ""
            # Mailbox    = ""
        }

        [Computer]::_PropertyMap = [Collections.Generic.Dictionary[string, PropertySelector]]::new()
        foreach ($Kvp in $Map.GetEnumerator())
        {
            [Computer]::_PropertyMap.Add($Kvp.Key, $Kvp.Value)
        }
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
            $Selector     = $Kvp.Value

            # Don't needlessly add to closures
            Remove-Variable Kvp

            $Member = @{
                Name        = $PropertyName
                MemberType  = "ScriptProperty"

                # Get
                Value       = {
                    $Node = $this._Xml |
                        Select-Xml -XPath $Selector.XPath |
                        Select-Object -ExpandProperty Node

                    & $Selector.Process $Node

                }.GetNewClosure()

                # Set
                SecondValue = {
                    throw [NotImplementedException]::new(
                        "Setter not implemented for '$PropertyName'."
                    )
                }.GetNewClosure()
            }

            $this | Add-Member @Member
        }
    }
}
