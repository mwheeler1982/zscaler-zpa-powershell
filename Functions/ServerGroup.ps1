function Get-ZPAServerGroup {
    <#
    .SYNOPSIS

    Retrieves Server Groups from the ZPA API

    .EXAMPLE

    PS> Get-ZPAServerGroup

    .EXAMPLE

    PS> Get-ZPAServerGroup -server_group_id 12738018157812
    #>
    
    # Parameters
    param(
        [Parameter(Mandatory=$false)][string]$server_group_id
    ) 

    $ZPAhost = $global:ZPAEnvironment.ZPAhost
    $token = $global:ZPAEnvironment.token
    $customer_id = $global:ZPAEnvironment.customer_id

    # Set the URI for this request
    if ($server_group_id)
    {
        $uri = ("https://{0}/mgmtconfig/v1/admin/customers/{1}/serverGroup/{2}" -f ($ZPAhost, $customer_id, $server_group_id))
    }
    else {
        $uri = ("https://{0}/mgmtconfig/v1/admin/customers/{1}/serverGroup" -f ($ZPAhost, $customer_id))
    }
    
    # Send the request
    return Invoke-RestMethod -uri $uri -Headers @{Authorization = "Bearer $token"}
}