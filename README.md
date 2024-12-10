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
Для того, чтобы удалить данную таску введите следующую команду от админа в powershell: 
```powershell
Unregister-ScheduledTask -TaskName "Nekobox route config" -Confirm:$false
```

## Discord

Так как я не советую вам подключать режим TUN, то рекомендую установить [drover](https://github.com/hdrover/discord-drover) для того, чтобы запускать Discord с прокси. При установке указывайте HTTP на порту 2080, если вы ничего не трогали.  
На GNU\Linux следуйте этому [гисту](https://gist.github.com/mzpqnxow/ca4b4ae0accf2d3b275537332ccbe86e)
