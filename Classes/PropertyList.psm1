class PropertyList : Collections.Generic.List[object]
{
    PropertyList() : base() {}

    PropertyList([object]$Item) : base()
    {
        $this.Add($Item)
    }

    PropertyList([Collections.IList]$Properties) : base()
    {
        $this.AddRange($Properties)
    }

    #endregion Overrides to allow state inspection
    [void] Add([object]$Item)
    {
        Write-Debug "Adding $Item"
        ([Collections.Generic.List[object]]$this).Add($Item)
    }

    [void] set_Item([int]$Index, [object]$Item)
    {
        Write-Debug "Updating index $Index with $Item"
        ([Collections.Generic.List[object]]$this)[$Index] = $Item
    }

    [void] Clear()
    {
        Write-Debug "Clearing"
        ([Collections.Generic.List[object]]$this).Clear()
    }

    [void] Insert([int]$Index, [object]$Item)
    {
        Write-Debug "Inserting $Item at index $Index"
        ([Collections.Generic.List[object]]$this).Insert($Index, $Item)
    }

    [void] Remove([object]$Item)
    {
        Write-Debug "Removing $Item"
        ([Collections.Generic.List[object]]$this).Remove($Item)
    }

    [void] RemoveAt([int]$Index)
    {
        Write-Debug "Removing at index $Index"
        ([Collections.Generic.List[object]]$this).RemoveAt($Index)
    }
    #endregion Overrides to allow state inspection
}
