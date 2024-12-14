$Nekobox_dir = Read-Host "Enter path to directory with Nekobox"
$Nekobox_dir.TrimEnd('\')
if (!(Test-Path "$Nekobox_dir\nekobox.exe")) {
    Write-Warning "Wrong path to Nekobox."
    [Environment]::Exit(0)
}
$Nekobox_geofile = Read-Host "Enter which geoip/geosite you want to use. 1 or 2
1) Antizapret
2) Re:filter
"
$Discord_geofile = Read-Host "Do you want to add discord IP cidr?
1) Yes
2) No
"
if ( $Discord_geofile -eq 1 ){
    $Discord_filename = "discord"
} else {
    $Discord_filename = "clear"
}
$Register_cron = Read-Host "Register a job?
1) Yes
2) No
"
wget "https://raw.githubusercontent.com/Akiyamov/nekobox_conf/refs/heads/main/Default" -OutFile "$Nekobox_dir\config\routes_box\Default"
function Nekobox_files_download {
    wget https://raw.githubusercontent.com/Akiyamov/nekobox_conf/refs/heads/main/$geoip_name_discord.json -OutFile "$Nekobox_dir\tmp_file.json"
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
    Import-Module ScheduledTasks
    wget "https://raw.githubusercontent.com/Akiyamov/nekobox_conf/refs/heads/main/scheduled_task.ps1" -OutFile "$env:USERPROFILE\scheduled_task.ps1"
    $taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like "Nekobox route config" }
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "$env:USERPROFILE\scheduled_task.ps1 $Nekobox_dir $geoip_name $geoip_name_discord -WindowStyle hidden" 
    $trigger = New-ScheduledTaskTrigger -AtLogon
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -StartWhenAvailable
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive
    if($taskExists){
        Set-ScheduledTask -TaskName "Nekobox route config" -Action $action -Trigger $trigger -Settings $settings -Description "Download sing-box files on startup" -Principal $principal
    } else {
        Register-ScheduledTask -TaskName "Nekobox route config" -Action $action -Trigger $trigger -Settings $settings -Description "Download sing-box files on startup" -Principal $principal
    }
}
switch ($Nekobox_geofile) {
    1 {
        $geoip_name = "savely-krasovsky/antizapret-sing-box"
        $geoip_name_discord = "savely-krasovsky/antizapret-sing-box_$Discord_filename"
        Nekobox_files_download
    }
    2 {
        $geoip_name = "1andrevich/Re-filter-lists"
        $geoip_name_discord = "1andrevich/Re-filter-lists_$Discord_filename"
        Nekobox_files_download
    }
}

if ( $Register_cron -eq 1 ) {
    Nekobox_schedule
}