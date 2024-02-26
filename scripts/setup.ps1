<powershell>
$admin = [adsi]('WinNT://./administrator, user')
$admin.PSBase.Invoke('SetPassword', 'P@ssw0rd1!')
Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))
set-item WSMan:\localhost\Service\AllowUnencrypted -Value True
set-item WSMan:\localhost\Service\Auth\Basic  -Value True
set-item WSMan:\localhost\Client\AllowUnencrypted -Value True
set-item WSMan:\localhost\Client\Auth\Basic  -Value True
winrm set winrm/config/client '@{TrustedHosts="*"}'
netsh advfirewall set allprofiles state off
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableIOAVProtection $true

$URLs = @("http://10.0.1.10:8000", "http://10.0.1.20:8000", "http://10.0.1.10:8080", "http://10.0.1.20:8080")
$Zone = 2  # 2 corresponds to the Trusted Sites zone

foreach ($URL in $URLs) {
    # Add URL to Trusted Sites
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\$URL" -Force
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\$URL" -Name "http" -Value $Zone -PropertyType DWORD -Force
}
</powershell>
