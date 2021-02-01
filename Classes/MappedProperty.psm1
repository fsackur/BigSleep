class MappedMemberCollection : Management.Automation.PSMemberInfoCollection[System.Management.Automation.PSPropertyInfo]
{
    MappedMemberCollection([Management.Automation.PSMemberInfoCollection[Management.Automation.PSPropertyInfo]]$Members) : base()
    {
        foreach ($Member in $Members)
        {
            $this.Add($Member)
        }
    }


    # public abstract void Add(T member);
    [void] Add([object]$Item)
    {
        Write-Debug "Adding $Item"
        ([Collections.Generic.List[object]]$this).Add($Item)
    }


    # public abstract void Add(T member, bool preValidated);
    # public abstract void Remove(string name);
    # public abstract T this[string name] { get; }

    [Management.Automation.PSPropertyInfo] get_Item([int]$Index)
    {
        Write-Debug "Updating index $Index with $Item"
        ([Collections.Generic.List[object]]$this)[$Index] = $Item
    }

    [void] set_Item([int]$Index, [Management.Automation.PSPropertyInfo]$Item)
    {
        Write-Debug "Updating index $Index with $Item"
        ([Collections.Generic.List[object]]$this)[$Index] = $Item
    }
}

class MappedProperty : Management.Automation.PSPropertyInfo
{
    hidden [xml]$_Xml
    hidden [string]$_XPath

    [object] get_Value()
    {
        return $this._Xml.SelectNodes($this._XPath)
    }

    [void] set_Value([object]$Value)
    {
        Write-Debug "Setting value"
    }
}
