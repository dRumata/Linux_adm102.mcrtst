**Пример настройки NAT (шлюза)**

Включить перенаправления на уровне ядра. Для этого открываем следующий файл:
```
vi /etc/sysctl.conf
```
И добавляем в него следующую строку:
```
net.ipv4.ip_forward=1
```
После применяем настройку:
```
sysctl -p /etc/sysctl.conf
```
В случае с единым сетевым интерфейсом больше ничего делать не потребуется — CentOS начнет работать как Интернет-шлюз.

В случае с несколькими сетевыми адаптерами, настраиваем сетевой экран.

**Включить маскарадинг:**
```
firewall-cmd --permanent --zone=dmz --add-masquerade
```
- без указания зон, будет включен для public и external.

> Для добавления интерфейсов в зоны использовать синтаксис:
firewall-cmd --permanent --zone=enable_test --add-interface=enp0s8

Для примера берем два ethernet интерфейса — `ens32` (внутренний) и `ens33` (внешний). Для настройки nat последовательно вводим следующие 4 команды:
```
firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -o ens33 -j MASQUERADE
```
* правило включает маскарадинг на внешнем интерфейсе ens33. Где опция --direct требуется перед всеми пользовательскими правилами (`--passthrough`, `--add-chain`, `--remove-chain`, `--query-chain`, `--get-chains`, `--add-rule`, `--remove-rule`, `--query-rule`, `--get-rules`); `nat` — таблица, в которую стоит добавить правило; `POSTROUTING 0` — цепочка в таблице `nat`; опция `MASQUERADE` указывает сетевому экрану менять внутренний IP-адрес на внешний.
```
firewall-cmd --direct --permanent --add-rule ipv4 filter FORWARD 0 -i ens32 -o ens33 -j ACCEPT
```
* добавляет в таблицу `filter` (цепочку `FORWARD`) правило, позволяющее хождение трафика с `ens32` на `ens33`.
```
firewall-cmd --direct --permanent --add-rule ipv4 filter FORWARD 0 -i ens33 -o ens32 -m state --state RELATED,ESTABLISHED -j ACCEPT
```
* добавляет правило в таблицу `filter` (цепочку `FORWARD`), позволяющее хождение трафика с `ens33` на `ens32` для пакетов, открывающих новый сеанс, который связан с уже открытым другим сеансом (`RELATED`) и пакетов, которые уже являются частью существующего сеанса (`ESTABLISHED`).
```
systemctl restart firewalld
```

