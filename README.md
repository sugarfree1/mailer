mailer
======

Использование
=============

В файле settings.rb необходимо указать параметры подключения к smtp серверу.
* user_name - имя пользователя почтового сервера,
* password - пароль,
* port - порт,
* address - адрес почтового сервера, например smtp.yandex.ru
* from - адрес отправителя письма
* use_tls - false/true

Запуск: 
* $ruby runner.rb --help