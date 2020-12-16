function Get-ZPAServer {
    <#
    .SYNOPSIS

    Retrieves Servers from the ZPA API

    .EXAMPLE

    PS> Get-ZPAServer

    .EXAMPLE

    PS> Get-ZPAServer -server_id 12738018157812
    #>
    
    # Parameters
    param(
        [Parameter(Mandatory=$false)][string]$server_id
    ) 

    $ZPAhost = $global:ZPAEnvironment.ZPAhost
    $token = $global:ZPAEnvironment.token
    $customer_id = $global:ZPAEnvironment.customer_id

    # Set the URI for this request
    if ($server_id)
    {
        $uri = ("https://{0}/mgmtconfig/v1/admin/customers/{1}/server/{2}" -f ($ZPAhost, $customer_id, $server_id))
    }
    else {
        $uri = ("https://{0}/mgmtconfig/v1/admin/customers/{1}/server" -f ($ZPAhost, $customer_id))
    }
    
    # Send the request
    return Invoke-RestMethod -uri $uri -Headers @{Authorization = "Bearer $token"}
}