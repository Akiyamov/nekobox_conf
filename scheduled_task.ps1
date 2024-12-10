$Nekobox_dir = $args[0]
$geoip_name = $args[1]
wget https://raw.githubusercontent.com/Akiyamov/nekobox_conf/refs/heads/main/$geoip_name.json -OutFile "$Nekobox_dir\tmp_file.json"
$neko_json_new = Get-Content "$Nekobox_dir\tmp_file.json" -raw 
$neko_json = Get-Content "$Nekobox_dir\config\routes_box\Default" -raw | ConvertFrom-Json
$neko_json.def_outbound = "bypass" 
$neko_json.custom = "$neko_json_new"
$neko_jsonified = $neko_json | ConvertTo-Json
$neko_jsonified.Replace('\\\', '\') | set-content "$Nekobox_dir\config\routes_box\Default"
wget "https://github.com/$geoip_name/releases/latest/download/geoip.db" -OutFile "$Nekobox_dir\geoip.db"
wget "https://github.com/$geoip_name/releases/latest/download/geosite.db" -OutFile "$Nekobox_dir\geosite.db"
