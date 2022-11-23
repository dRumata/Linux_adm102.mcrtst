**Добавление маршрутов с помощью nmcli**

1. Используйте nmcli, nmtui или инструменты GUI для изменения маршрутов сети

2. Чтобы добавить маршрут с помощью nmcli, измените свойство ipv4.routes соединения.

Например, чтобы добавить маршрут к сети `10.20.30.0/24` через `192.168.100.10` для соединения с именем «external»:
```
nmcli connection modify external ipv4.routes "10.20.30.0/24 192.168.100.10"
```
3. Чтобы добавить дополнительные маршруты, используйте модификатор `+` (плюс) в свойстве ipv4.routes подключения:
```
nmcli connection modify external +ipv4.routes "10.0.1.0/24 192.168.100.20"
```
4. Несколько маршрутов могут быть добавлены сразу, разделенные запятой:
```
nmcli connection modify external ipv4.routes "10.20.30.0/24 192.168.100.10, 10.0.1.0/24 192.168.100.20"
```
**Удаление маршрутов с помощью nmcli**

1. Чтобы удалить маршрут, используйте модификатор `–` (минус) в свойстве `ipv4.routes` подключения, указав маршрут, который нужно удалить:
```
nmcli connection modify external -ipv4.routes "10.0.1.0/24 192.168.100.20"
```
2. Чтобы удалить все маршруты, установите значение свойства `ipv4.routes` в значение “” (пусто):
```
nmcli connection modify external ipv4.routes ""
```
3. После любых изменений, приведенных выше, подключите соединение, чтобы внести изменения.

Например, после изменения свойств соединения с именем «external»:
```
nmcli connection up external
```