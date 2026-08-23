# Установка и настройка Hysteria 2 на роутерах Keenetic

Установка и настройка Hysteria 2 на роутерах Keenetic с использованием Entware и проекта [H-wave](https://github.com/for6to9si/H-wave).

## Требования

- Роутер Keenetic с поддержкой USB
- Внешний USB-накопитель
- Установленный Entware
- Доступ к роутеру по SSH

## Установка Entware

Перед установкой Hysteria 2 необходимо подготовить USB-накопитель и установить Entware.

📘 **Официальная инструкция Keenetic:**  
👉 https://help.keenetic.ru/hc/ru/articles/360021214160.html

## Включение необходимых компонентов

Для корректной работы требуются модули ядра Netfilter:
- `xt_TPROXY`
- `xt_socket`
- `xt_multiport`

### Как включить

В веб-интерфейсе Keenetic:
1. **Управление → Параметры системы → Общие настройки системы→ Изменить набор компонентов → Пакеты OPKG**
3. Включите компонент: **Модули ядра подсистемы Netfilter**
4. Перезагрузите роутер при необходимости.

## Обновление Entware и установка зависимостей

Подключитесь к роутеру по SSH и выполните:

```bash
opkg update
opkg install wget-ssl ca-certificates
```

## Установка Hysteria 2

Hysteria 2 устанавливается напрямую из релизов GitHub.

Для архитектуры mipsle:
```bash
opkg install https://github.com/for6to9si/H-wave/releases/download/v2.12.2/hysteria_2.12.2_mipsle.ipk
```
Для архитектуры arm64:
```bash
opkg install https://github.com/for6to9si/H-wave/releases/download/v2.12.2/hysteria_2.12.2_arm64.ipk
```

ℹ️ Если архитектура роутера неизвестна, можно попробовать установить оба пакета — Entware не позволит установить неподходящий.

⚠️ Версия arm64 не тестировалась автором.

## Удаление Hysteria 2

Удаление пакета Hysteria из списка opkg влечет за собой удаление связанной с ним политики доступа Hwave на роутере keenetic

```bash
opkg remove hysteria-tg-installer
```

## Конфигурация Hysteria

Далее необходимо внести настройки в файл конфигурации Hysteria:


Пример файла конфигурации можно найти здесь:  
[/opt/etc/hysteria/config.json](https://github.com/for6to9si/H-wave/blob/main/etc/hysteria/config.json)


## Список команд

- `/opt/etc/init.d/S96hysteria status` — узнать текущий статус

- `/opt/etc/init.d/S96hysteria restart` — перезапуск Hysteria  
  (включает запуск Hysteria и применение настроек маршрутизации)

- `/opt/etc/init.d/S96hysteria fast_restart` — быстрый перезапуск Hysteria  
  (маршрутизация не затрагивается)

- `/opt/etc/init.d/S96hysteria firewall_up` — запуск / применение настроек маршрутизации

- `/opt/etc/init.d/S96hysteria stop` — остановка Hysteria и отключение маршрутизации

## Логи и отладка

### Просмотр логов Hysteria

  Просмотр логов Hysteria и другая полезная отладочная информация:
  ```bash
  cat /opt/var/log/hwave/hwave.log
  ```

### Режим отладки

  По умолчанию включён полный режим отладки.  
  Для отключения отладочного вывода установите переменную `DEBUG=false`  
  в файле [`/opt/etc/init.d/S96hysteria`](https://github.com/for6to9si/H-wave/blob/main/etc/init.d/S96hysteria#L30).


## Важное замечание о Obfuscation

**Включение Obfuscation** (см. документацию: https://v2.hysteria.network/docs/advanced/Full-Client-Config/?h=obfuscation#obfuscation) приводит к неработоспособности Hysteria на сотовых операторах. Причина: операторы распознают пакеты как непонятный UDP-трафик и дропают их. Лучше отключить маскировку, и настройть работу Hysteria на работу quic


## Решения для работы с QUIC

### Вариант 1: Бесплатный домен и сертификат
1. Зарегистрировать домен 3-го уровня на сайте: **freedns.afraid.org**
2. Автоматически получить TLS-сертификат с помощью встроенного ACME-клиента Hysteria  
   Документация: https://v2.hysteria.network/docs/getting-started/Server/?h=acme#__tabbed_1_1 

### Вариант 2: Свой домен и платный сертификат
- Использовать свой домен
- Применить купленный TLS-сертификат


## Быстрый взгляд на Hysteria

Чистая **Hysteria** имеет ряд преимуществ перед встроенным пакетом Hysteria в программе **sing-box**.

### Основные преимущества

- Поддержка опции **медленной загрузки**  
  👉 https://v2.hysteria.network/docs/advanced/Full-Client-Config/?h=lazy#lazy

- Поддержка опции **быстрого подключения**  
  👉 https://v2.hysteria.network/docs/advanced/Full-Client-Config/?h=fast+open#fast-open

### Особенности работы

- Соединение по **UDP** может держаться почти **2 часа** в открытом состоянии без повторного обмена ключами.

- Также можно изменять **размер пакета QUIC**:  
  👉 https://v2.hysteria.network/docs/advanced/Full-Client-Config/?h=quic+parameters#quic-parameters  
  Однако на практике эта возможность, скорее всего, не понадобится.

# Настройка портов и режимов работы

## TCP (Redirect)
**Режим:** Redirect  
**Протокол:** TCP  
**Требование:** Порты должны совпадать в конфигурациях

| Сервис   | Файл конфигурации                  | Строка | Ссылка |
|----------|------------------------------------|--------|--------|
| H-wave   | `/etc/hwave/hwave-conf.json`       | #L19   | [ссылка](https://github.com/for6to9si/H-wave/blob/main/etc/hwave/hwave-conf.json#L19) |
| Hysteria | `/etc/hysteria/config.json`        | #L22   | [ссылка](https://github.com/for6to9si/H-wave/blob/main/etc/hysteria/config.json#L22) |

## UDP (TPROXY)
**Режим:** TPROXY  
**Протокол:** UDP  
**Требование:** Порты должны совпадать в конфигурациях

| Сервис   | Файл конфигурации                  | Строка | Ссылка |
|----------|------------------------------------|--------|--------|
| H-wave   | `/etc/hwave/hwave-conf.json`       | #L20   | [ссылка](https://github.com/for6to9si/H-wave/blob/main/etc/hwave/hwave-conf.json#L20) |
| Hysteria | `/etc/hysteria/config.json`        | #L26   | [ссылка](https://github.com/for6to9si/H-wave/blob/main/etc/hysteria/config.json#L26) |

# Примечания

- Бинарник Hysteria забирается через GitHub Actions [ссылка](https://github.com/apernet/hysteria/releases) с добавляются файлы c проекта H-wave и собирается пакет ipk.
- Поддержка arm64 не тестировалась, я взял бинарник для сборки  [hysteria-linux-arm64](https://github.com/apernet/hysteria/releases/download/app%2Fv2.6.5/hysteria-linux-arm64) возможно следовало взять [hysteria-linux-arm](https://github.com/apernet/hysteria/releases/download/app%2Fv2.6.5/hysteria-linux-arm)

# Полезные ссылки

- **H-wave**: https://github.com/for6to9si/H-wave
- **Hysteria**: https://github.com/apernet/hysteria
- **Entware**: https://entware.net