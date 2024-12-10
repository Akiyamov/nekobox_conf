# Nekobox config

Установка конфига для Nekobox на Windows, в будущем также будет для GNU/Linux.  
Для установки нужно ввести следующую команду в Powershell:
```powershell
irm https://raw.githubusercontent.com/Akiyamov/nekobox_conf/refs/heads/main/setup_conf.ps1 | iex
```
На данный момент можно выбрать два файла со списками для обхода:
* [Antizapret от Савелия Красовского](https://github.com/savely-krasovsky/antizapret-sing-box)
* [Re:filter от 1andrevich](https://github.com/1andrevich/Re-filter-lists)  

Также скрипт может создать таску для Windows, чтобы скачивать новый конфиг и файлы для обхода при каждом запуске системы. Для этого нужно запускать скрипт от администратора и на втором пункте выбрать `1`.