function Get-ZPAAPISession
{
    <#
    .SYNOPSIS

    Logs into the ZPA API and gets an active session

    .EXAMPLE

    PS> Get-ZPAAPISession
    #>

    $ZPAhost = $global:ZPAEnvironment.ZPAhost
    $client_id = $global:ZPAEnvironment.client_id
    $client_secret = $global:ZPAEnvironment.client_secret


    #
    # set the URI
    #
    $uri = ("https://{0}/signin" -f $ZPAhost)

   
    #
    # construct our parameters variable
    #
    $parameters = @{
        client_id = $client_id
        client_secret = $client_secret
    }

    #
    # send login request
    #
    $result = Invoke-RestMethod -Uri $uri -Method Post -Form $parameters
    $global:ZPAEnvironment.token = $result[0].access_token
}

function Remove-ZPAAPISession
{
    <#
    .SYNOPSIS

    Logs out of the ZPA API session

    .EXAMPLE

    PS> Remove-ZPAAPISession
    #>

    # set the URI
    $uri = ("https://{0}/signout" -f $global:ZPAEnvironment.ZPAhost)
    $token = $global:ZPAEnvironment.token

    # log out of the authenticated session
    $result = Invoke-RestMethod -Uri $uri -Method Post -Headers @{ Authorization = "Bearer $token"}
    return
}

function Get-ZPAEnvironmentFromFile
{
    <#
    .SYNOPSIS

    Reads Zscaler API Environment information from a file, then feeds to Set-ZPAEnvironment

    .EXAMPLE

    PS> Get-ZPAEnvironmentFromFile -FileName .\.Zscaler\ZPAconfig
    
    .PARAMETER FileName

    File name containing the Zsclaer API environment variables. Example file looks like this:
    ZPAhost = public-api.dev.zpath.net
    client_id = MTQ1MjUzOTQzODkzNTUasdjfkaldjsfkajkEwNWItNDVmNi1hYmIyLWQzMzk4YmE0ZmEyYQ==
    client_secret = hfwilhafilhksdfajhfiflwej

    #>
    param(
        [Parameter(Mandatory=$false)][string]$FileName
    )

    # try to read from the default location of $HOME/.Zscaler/config if no FileName was specified. If this file does not exist, throw an error
    if (!$FileName)
    {
        if (Test-Path -Path $HOME/.Zscaler/ZPAconfig)
        {
            # config file exists
            $FileName = "$HOME/.Zscaler/ZPAconfig"
        } else {
            # conf file does not exist. Since they didn't specify a file and there's no default config, throw an error
            Throw "Must specify -FileName or have a config file at $HOME/.Zscaler/ZPAconfig"
        }
    }

    # read in the configuration file
    $environment = ConvertFrom-StringData -StringData (Get-Content -path $FileName -Raw)

    # set the environment
    Set-ZPAEnvironment -ZPAhost $environment.ZPAhost -client_id $environment.client_id -client_secret $environment.client_secret
}

function Set-ZPAEnvironment
{
    <#
    .SYNOPSIS

    Sets the variables required to authenticate to the ZPA API

    .EXAMPLE 

    PS> Set-ZPAEnvironment -host public-api.dev.zpath.net -client_id asdfjafjasdjfkajsdkfjaskdfj -client_secret adfasdfjksdjfkajsdfklaghl

    .PARAMETER ZPAhost
    The ZPA host you are logging into. Example: public-api.dev.zpath.net

    .PARAMETER client_id
    Your ZPA Client ID

    .PARAMETER client_secret
    Your ZPA Client Secret

    #>
    param(
        [Parameter(Mandatory=$true)][string]$ZPAhost,
        [Parameter(Mandatory=$true)][string]$client_id,
        [Parameter(Mandatory=$true)][string]$client_secret
    )

    $global:ZPAEnvironment = [PSCustomObject]@{
        ZPAhost = $ZPAhost
        client_id = $client_id
        client_secret = $client_secret
        token = $token
    }
}

function Get-ZPASessionCookie
{
    <#
    .SYNOPSIS

    Outputs the Zscaler API session cookie value if one exists

    .EXAMPLE

    PS> Get-ZPASessionCookie
    eyJraWQiOiJua29W[...]QPzwRI8T1uI0A
    #>
    return $Global:ZPAEnvironment.token
}

