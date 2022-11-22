Создание unit
1 Создайте unit (типа service) для включения маршрутизации в ядре
(переменная net.ipv4.ip_forward).

Порядок выполнения:
• создайте юнит с именем ip_forward.service;

sudo systemctl --force --full edit ip_forward.service

• в секции [Unit] параметру Description присвойте краткое описание того,
что делает служба;

Description=Turn on/off internal routing

• прежде чем, записать параметры в секции [Service] спланируйте работу
службы:

◦ так как необходимо разово запускать команду

sysctl net.ipv4.ip_forward=1, то тип определите как oneshot;

Type=oneshot

◦ в соответствии с выбранным типом, после запуска маршрутизации, служба будет автоматически остановлена и чтобы
маршрутизация не была остановлена тоже, добавьте параметр
RemainAfterExit;
RemainAfterExit=yes
◦ добавьте параметр на запуск команды ExecStart, обязательно
указывая полный путь до команды;
ExecStart=/usr/sbin/sysctl net.ipv4.ip_forward=1
◦ параметр на останов — ExecStop укажите аналогично;
ExecStop=/usr/sbin/sysctl net.ipv4.ip_forward=0
• в секции [Install] задайте многопользовательский режим без графического интерфейса;

WantedBy=multi-user.target

• сохраните юнит с параметрами по умолчанию;

• перечитайте конфигурационный файл службы

sudo systemctl daemon-reload;

• запустите созданную службу и проверьте корректность работы;

• добавьте службу в автозагрузку:

sudo systemctl enable ip_forward.service

2 Проверьте корректность работы службы ip_forward.service после
перезагрузки ОС.
