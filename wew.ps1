Import-Module ScheduledTasks
$Nekobox_dir = Read-Host "Enter path to directory with Nekobox"
$Nekobox_dir.TrimEnd('\')
if (!(Test-Path "$Nekobox_dir\nekobox.exe")) {
    Write-Warning "Wrong path to Nekobox."
    [Environment]::Exit(1)
}
$Nekobox_geofile = Read-Host "Enter which geoip/geosite you want to use. 1 or 2.:
1) Antizapret
2) Re:filter
"
$Register_cron = Read-Host "Register a job?
1) Yes
2) No
"
function Nekobox_files_download {
    irm https://raw.githubusercontent.com/Akiyamov/nekobox_conf/refs/heads/master/go.mod
    $custom_line Get-Content "$Nekobox_dir\config\routes_box\Default" | Select-String custom | Select-Object -ExpandProperty Line
    $content = Get-Content "$Nekobox_dir\config\routes_box\Default"
    $content | ForEach-Object {$_ -replace $custom_line,"pear = amazing"} | Set-Content c:\temp\test.txt
#    wget http://blog.stackexchange.com/ -OutFile "$Nekobox_dir\config\routes_box\Default"
    wget "https://github.com/$geoip_name/releases/latest/download/geoip.db" -OutFile "$Nekobox_dir\geoip.db"
    wget "https://github.com/$geoip_name/releases/latest/download/geosite.db" -OutFile "$Nekobox_dir\geosite.db"
}
switch ($Nekobox_geofile) {
    1 {
        $custom_line Get-Content "$Nekobox_dir\config\routes_box\Default" | Select-String custom | Select-Object -ExpandProperty Line
        $geoip_name = "savely-krasovsky/antizapret-sing-box"
        $action = New-ScheduledTaskAction -Execute Nekobox_refilter_download
        $trigger = New-ScheduledTaskTrigger -AtLogon
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -StartWhenAvailable
        $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
        Register-ScheduledTask -TaskName "Nekobox route config" -Action $action -Trigger $trigger -Settings $settings -Description "Download sing-box files on startup" -Principal $principal
    }
    2 {
        $geoip_name = "1andrevich/Re-filter-lists"
        $action = New-ScheduledTaskAction -Execute Nekobox_refilter_download
        $trigger = New-ScheduledTaskTrigger -AtLogon
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -StartWhenAvailable
        $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
        Register-ScheduledTask -TaskName "Nekobox route config" -Action $action -Trigger $trigger -Settings $settings -Description "Download sing-box files on startup" -Principal $principal
    }
}
Start-ScheduledTask -TaskName "Nekobox route config"