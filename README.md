# SSH Telegram Notifier

Скрипт для уведомления в Telegram о логине пользователя по SSH

# Подноготная

Скрипт работает за счёт механизма Linux под названием **PAM** (Pluggable Authentication Modules). PAM - программный интерфейс (API), который могут использовать как сама ОС, так и приложения для отправки запросов на проверку подлинности пользователя. Это позволяет предоставить единые механизмы для управления и встраивания прикладных программ в процесс аутентификации. В данном скрипте открытие сессии является спусковым крючком, который в свою очередь пораждает скрипт отправляющий уведомления в Telegram


# Инструкция

Создайте бота в Telegram через [@BotFather](https://t.me/BotFather). Далее добавьте бота в чат и дайте необходимые права для работы.

Получить ID чата в Telegram можно несколькими способами:
1. Из настрольного клиента, предварительно включив тумблер по пути `Settings -> Show Peer IDs in Profile`. Добавьте к полученному значению префикс `-100`
2. По ссылке вида `https://api.telegram.org/bot$TG_BOT_TOKEN/getUpdates`, где `$TG_BOT_TOKEN` - это токен вашего бота в Telegram (смотреть пояснение для переменных ниже)
3. С помощью ботов [@RawDataBot](https://t.me/RawDataBot), [@getidsbot](https://t.me/getidsbot) или [@rose](https://t.me/)

Получите токен на сайте [ipinfo.io](https://ipinfo.io) для того, чтобы скрипт мог использовать API для получения информации об IP-адресе. Сделать это можно путём [регистрации](https://ipinfo.io/signup)

Поместите содержимое скрипта `ssh-tg-notifier.sh` по пути `/usr/bin/ssh-tg-notifier`

Измените значения следующих переменных путём редактирования `/usr/bin/ssh-tg-notifier`:

* `TG_BOT_TOKEN` - токен вашего бота в Telegram
* `TG_CHAT_ID` - идентификтор группового чата в Telegram 
* `IPINFO_TOKEN` - токен с сайта ipinfo.io

Сделайте скрипт исполняемым

```shell
sudo chmod +x /usr/bin/ssh-tg-notifier
```

Добавьте следующую строчку в конец файла `/etc/pam.d/sshd`

```shell
echo "session optional pam_exec.so type=open_session seteuid /usr/bin/ssh-tg-notifier" | sudo tee -a /etc/pam.d/sshd
```

На этом настройка закончена. Теперь при успешном SSH подключении вы будете получать уведомление в Telegram'е.

По аналогии с этим скриптом, вы можете сделать уведомления и на другие события. Например, на закрытие сессии, или на неудачную аутентификацию

# Демонстрация работы

![screenshot](./screenshot.png)

# Референсы

* [Бэкдор PAM для сбора пользовательских паролей в учебных целях](https://youtube.com/watch?v=6tn30O0SjVQ&t=2550)
* [Более подробная программная интеграция с PAM_EXEC на Go](https://www.youtube.com/watch?v=FQGu9jarCWY&t=1s)
* [Мануал PAM](https://www.man7.org/linux/man-pages/man8/pam.8.html)
