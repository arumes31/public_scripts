Function Get-RedirectedUrl {
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )

    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()

    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}


###########EDIT HERE###########

#Customer Site Name (Default is not supported, since disconnected clients also uses default in HKLM:\SOFTWARE\Fortinet\FortiClient\FA_ESNAC\vdom)
$emsvdom = "SITENAME"

#Bulk Invitation Link 
$bulkinvurl = "https://SERVERIP/api/v1/invitation/register?code=_XXXXXXXXXXXXXX"

###########EDIT END###########


$emsvdomreg = Get-ItemProperty -Path HKLM:\SOFTWARE\Fortinet\FortiClient\FA_ESNAC -Name "vdom" -ErrorAction SilentlyContinue
$emsvdomreg = $emsvdomreg.vdom

if ($emsvdomreg -ne $emsvdom){
Write-Host "ems disconnected, reconnecting.." 
$req = Get-RedirectedUrl $bulkinvurl 
if ($req){
    start-process $req
    }
}