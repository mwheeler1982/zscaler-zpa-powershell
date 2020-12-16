function Get-ZPAAppSegment {
    <#
    .SYNOPSIS

    Retrieves Application Segments from the ZPA API

    .EXAMPLE

    PS> Get-ZPAAppSegment

    .EXAMPLE

    PS> Get-ZPAAppSegment -app_segment_id 12738018157812
    #>
    
    # Parameters
    param(
        [Parameter(Mandatory=$false)][string]$app_segment_id
    ) 

    $ZPAhost = $global:ZPAEnvironment.ZPAhost
    $token = $global:ZPAEnvironment.token
    $customer_id = $global:ZPAEnvironment.customer_id

    # Set the URI for this request
    if ($app_segment_id)
    {
        $uri = ("https://{0}/mgmtconfig/v1/admin/customers/{1}/application/{2}" -f ($ZPAhost, $customer_id, $app_segment_id))
    }
    else {
        $uri = ("https://{0}/mgmtconfig/v1/admin/customers/{1}/application" -f ($ZPAhost, $customer_id))
    }
    
    # Send the request
    return Invoke-RestMethod -uri $uri -Headers @{Authorization = "Bearer $token"}
}