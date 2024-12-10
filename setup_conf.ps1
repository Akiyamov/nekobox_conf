Import-Module ScheduledTasks
$Nekobox_dir = Read-Host "Enter path to directory with Nekobox"
$Nekobox_dir.TrimEnd('\')
if (!(Test-Path "$Nekobox_dir\nekobox.exe")) {
    Write-Warning "Wrong path to Nekobox."
    [Environment]::Exit(0)
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
    wget https://raw.githubusercontent.com/Akiyamov/nekobox_conf/refs/heads/main/$geoip_name.json
    $neko_json_new = Get-Content "$Nekobox_dir\tmp_file.json" -raw 
    $neko_json = Get-Content "$Nekobox_dir\config\routes_box\Default" -raw | ConvertFrom-Json
    $neko_json.def_outbound = "bypass" 
    $neko_json.custom = "$neko_json_new"
    $neko_jsonified = $neko_json | ConvertTo-Json
    $neko_jsonified.Replace('\\\', '\') | set-content "$Nekobox_dir\config\routes_box\Default"
    wget "https://github.com/$geoip_name/releases/latest/download/geoip.db" -OutFile "$Nekobox_dir\geoip.db"
    wget "https://github.com/$geoip_name/releases/latest/download/geosite.db" -OutFile "$Nekobox_dir\geosite.db"
}
function Nekobox_schedule {
    [System.Environment]::SetEnvironmentVariable('Nekobox_dir',$Nekobox_dir, 'User')
    [System.Environment]::SetEnvironmentVariable('geoip_name',$geoip_name, 'User')
    $action = New-ScheduledTaskAction -Execute Nekobox_files_download 
    $trigger = New-ScheduledTaskTrigger -AtLogon
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -StartWhenAvailable
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
    Register-ScheduledTask -TaskName "Nekobox route config" -Action $action -Trigger $trigger -Settings $settings -Description "Download sing-box files on startup" -Principal $principal
}
switch ($Nekobox_geofile) {
    1 {
        $geoip_name = "savely-krasovsky/antizapret-sing-box"
        Nekobox_files_download
    }
    2 {
        $geoip_name = "1andrevich/Re-filter-lists"
        Nekobox_files_download
    }
}

if ( $Register_cron -eq 1 ) {
    Nekobox_schedule
}