* Вопросы
1.  Назовите основные отличия и преимущества systemd от sysvinit, опишите подходы
```
Sysvinit – запускает все демоны последовательно, друг за другом,
нет возможности сделать зависимость запуска одного сервиса от другого. Используется система с runlevel.

Systemd – создаёт сокеты отдельно от запуска демонов, что позволяет начать работу намного раньше.
Также systemd поддерживает множество технологий, которые не поддерживает sysvinit.
В Systemd нет runlevel, вместо этого есть targets, определяющие зависимости одних юнитов от других.
```
2.  Каким образом происходит параллельный запуск всех процессов но в то же время сервисы стартуют с нужными зависимостями друг относительно друга
```
Systemd знает необходимые зависимости для каждого сервиса и может запускать сервисы без зависимостей параллельно,
таким образом, для каждого сервиса поднимаются его зависимости и сам сервис.
Также systemd может заранее создать сокет для сервиса, что позволит начать работу всей системы раньше.
```
3.  Каким образом проверить работает процесс в sysvinit и в systemd?
```
Sysvinit: 
  chkconfig service_name или service --status-all
  
Systemd: 
  systemctl status [unit]
```
4.  Как добавить в автозагрузку init скрипт в sysvinit и в systemd?
```
Sysvinit:
  Добавить скрипт в директорию /etc/init.d
  chkconfig srvice_name on

Systemd:
  Добавить файл с описанием модуля в /etc/systemd/system/
  sysctemctl enable service
```
5.  Как посмотреть логи в системе systemd по нужному нам процессу
```
  journalctl -u <name_unit>
```
---
* Задачи:
1.  Hаписать простой скрипт на любом языке программирования который будет работать в режиме демона

    [demon.sh](demon.sh?raw=true) ``` Скрипт, который переодически очищает все файлы в определенных директориях ```
2.  Установить дистрибутив Debian 8 и написать sysvnit скрипт для запуска процесса, добавить в автозагрузку, проверить автозагрузку и работу start stop аргументов

    [scrypt.sh](scrypt.sh?raw=true) ``` Скрипт, который запускает скрипт demon.sh ```
      
![pic1](pic1.png?raw=true)
```
Вводим команду chkconfig myscript.sh on и после перезагрузки системы получаем:
```
![pic2](pic2.png?raw=true)

3.  Установить Debian 10, написать systemd unit, добавить в автозагрузку, проверить что скрипт запускается после рестарта, проверить start stop status unit-а


    [mydemon](mydemon.sh?raw=true) ``` Изменяем скрипт demon.sh ```
```
Создаём файл описания модуля /etc/systemd/system/mydemon.sevice:
```
```
[Unit]
Description=Clear logs

[Service]
ExecStart=/opt/mydemon.sh
```

```
Проверяем, что модуль работает, просматриваем статус службы systemctl status mydemon.service,
запускаем сервис systemctl start mydemon.service:
```
  ![pic3](pic3.png?raw=true)

  ![pic4](pic4.png?raw=true)

4.  Написать timer для systemd который раз в 5 минут пишет что-либо в лог файл
```
Создаем файл /etc/systemd/system/mytimer.timer:
```
```
[Unit]
Description=Clear log every 5 min

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
```
```
Создаем файл /etc/systemd/system/mytimer.service:
```
```
[Unit]
Description=Clear logs

[Service]
ExecStart=/opt/mydemon.sh
```
```
Запускаем таймер systemctl start mytimer.timer и проверяем список таймеров в системе systemctl list-timers:
```
![pic5](pic5.png?raw=true)
```
Теперь через минуту после загрузки системы и после каждые 5 минут будет запускаться наш скрипт mydemon.sh.
Создаем несколько файлов.
```
![pic6](pic6.png?raw=true)
```
Запускаем таймер systemctl start mytimer.timer и проверяем список таймеров в системе systemctl list-timers.
Проверяем, удалились ли файлы.
```
![pic7](pic7.png?raw=true)
```
Каждые 5 минут таймер идет заново.
```
![pic8](pic8.png?raw=true)
