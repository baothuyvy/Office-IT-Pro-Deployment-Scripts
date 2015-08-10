﻿Param
(
    [Parameter(Mandatory=$true)]
    [string]$CommonFileShare
)

function Deploy-TelemetryAgent3 {

begin {
    $HKLM = [UInt32] "0x80000002";
    $HKCR = [UInt32] "0x80000000";
    $HKEY_Users = 2147483651;

	$results = new-object PSObject[] 1;

 }	
        
process {

        New-PSDrive -PSProvider Registry HKU -Root HKEY_USERS

        Set-Location HKU:
        
        $regProv = Get-Wmiobject -list "StdRegProv" -namespace root\default   

        foreach ($userKey in $regProv.EnumKey($HKEY_Users,"").sNames) {

            $objExcel = New-Object -ComObject Excel.Application
            $officeVersion = $objExcel.Version.Split('.')[0]

                if($officeVersion -match '11'){
                    $regpath = "Software\Policies\Microsoft\Office\11.0\osm"
                }
                elseif($officeVersion -match '12'){
                    $regpath = "Software\Policies\Microsoft\Office\12.0\osm"
                }
                elseif($officeVersion -match '14'){
                    $regpath = "Software\Policies\Microsoft\Office\14.0\osm"
                }
                elseif($officeVersion -match '15'){
                    $regpath = "Software\Policies\Microsoft\Office\15.0\osm"
                }
                elseif($officeVersion -match '16'){
                    $regpath = "Software\Policies\Microsoft\Office\16.0\osm"
                }


            $packagePath = join-path $userKey $regpath
        
                if(!(Test-Path -Path $packagePath)){

                    New-Item -Path $packagePath -Force

                }
            
                    New-ItemProperty -Path $packagePath -Name "CommonFileShare" -Value $CommonFileShare -PropertyType String | Out-Null

                    New-ItemProperty -Path $packagePath -Name "Tag1" -Value "TAG1" -PropertyType String | Out-Null
                    New-ItemProperty -Path $packagePath -Name "Tag2" -Value "TAG2" -PropertyType String | Out-Null
                    New-ItemProperty -Path $packagePath -Name "Tag3" -Value "TAG3" -PropertyType String | Out-Null
                    New-ItemProperty -Path $packagePath -Name "Tag4" -Value "TAG4" -PropertyType String | Out-Null

                    New-ItemProperty -Path $packagePath -Name "AgentInitWait" -Value "60" -PropertyType "DWord" | Out-Null
                    New-ItemProperty -Path $packagePath -Name "Enablelogging" -Value "1" -PropertyType "DWord" | Out-Null
                    New-ItemProperty -Path $packagePath -Name "EnableUpload" -Value "1" -PropertyType "DWord" | Out-Null
                    New-ItemProperty -Path $packagePath -Name "EnableFileObfuscation" -Value "0" -PropertyType "DWord" | Out-Null
                    New-ItemProperty -Path $packagePath -Name "AgentRandomDelay" -Value "0" -PropertyType "DWord" | Out-Null
                   

            }

    }
 
}


Deploy-TelemetryAgent3 $CommonFileShare


