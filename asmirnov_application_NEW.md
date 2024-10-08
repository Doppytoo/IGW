# Артём Смирнов - Сервис мониторинга скорости загрузки страниц

### Группа: 10 - И - 5
### Электронная почта: mr.asmirnow@gmail.com ; avsmirnov_10@edu.hse.ru ;
### Telegram: [@mrasmirnow](https://t.me/mrasmirnow) (Не пользуюсь VK от слова совсем)

**[ НАЗВАНИЕ ПРОЕКТА ]**

Сервис мониторинга скорости загрузки страниц

**[ ЗАКАЗЧИК / ПОТЕНЦИАЛЬНАЯ АУДИТОРИЯ ]**

Заказчик:
Компания Академ Сити, руководитель Управления Разработки

**[ ПРОБЛЕМНОЕ ПОЛЕ ]**

У компании-заказчика есть много сайтов и сервисов, с помощью которых она предоставляет услуги пользователям. Скорость загрузки страниц - крайне важный для заказчика показатель. Сейчас используется две системы мониторинга, ни одна из которых не устраивает заказчика.

Нужно создать инструмент, который бы позволил оперативно получать оперативные оповещения об инцидентах и наглядно просматривать требуемую информацию (см. функциональные требования).

**[ ОБРАЗ ПРОДУКТА ]**

Приложение для мониторинга скорости загрузки сайтов и сервисов заказчика и настройки этого мониторинга; Телеграм-бот для оповещений об инцидентах.


**[ АППАРАТНЫЕ / ПРОГРАММНЫЕ ТРЕБОВАНИЯ ]** 

* Android 8 и выше, 3 Гб оперативной памяти, 1 Гб свободного места

*Требования к свободному месту на диске здесь заданы как максимум. Для установки приложения, скорее всего, его понадобится меньше.

**[ ФУНКЦИОНАЛЬНЫЕ ТРЕБОВАНИЯ ]**

Программный продукт должен автоматически выполнять следующие функции:
* С определённой периодичностью измерять скорость загрузки страниц, формировать запись об инциденте при превышении порогового значения скорости загрузки страниц
* Оповещать пользователя о возникших индцидентах через Telegram
* Повторно оповещать пользователя об инциденте, если он не закончился через определённое время

Программный продукт должен предоставлять пользователю следующие возможности:
* Просматривать историю инцидентов
* Просматривать ключевые метрики, вычисленные на основе истории скорости загрузки страниц (количество сбоев в неделю, общее время сбоев итд.)
* Задавать список страниц для измерения скорости
* Задавать пороговые значения скорости загрузки каждой из страниц
* Задавать периодичность измерения скорости загрузки страниц
* Задавать время, через которое отправляется повторное оповещение об инциденте
* "Привязывать" к системе аккаунт в Telegram для получения оповещений об инцидентах


**[ ПОХОЖИЕ / АНАЛОГИЧНЫЕ ПРОДУКТЫ ]**

1. Google PageSpeed Insights
    * Невозможно запустить на сервере заказчика, вследствие чего не представляется возможным собирать данные о скорости сервисов, находящихся в локальной сети / VPN заказчика, не доступных через интернет
    * Нет возможности установить пороговые значения скорости загрузки, следовательно нельзя настроить оповещения об инцидентах, не хранит их историю
    * Нет дополнительных вычисляемых метрик
2. Grafana
    * Неинформативный "посекундный" график скорости загрузки, нет дополнительных вычисляемых метрик
    * Нет возможности настроить оповещения об инцидентах, кроме как по электронной почте (требование заказчика - оповещения в Telegram)
    * Не хранит историю инцидентов
3. Sitespeed.io
    * Нет дополнительных вычисляемых метрик
    * Нет возможности настроить оповещения об инцидентах, кроме как по электронной почте (требование заказчика - оповещения в Telegram)
    * Не хранит историю инцидентов
    

**[ ИНСТРУМЕНТЫ РАЗРАБОТКИ, ИНФОРМАЦИЯ О БД ]**

* Flutter / Dart - для разработки фронтенда
* FastAPI / Python - для разработки бэкенда
* aiogram / Python - для разработки Телеграм-бота для оповещений
* PostgreSQL - база данных
    * SQLModel - ORM

**[ ЭТАПЫ РАЗРАБОТКИ ]**

1. Подготовка к разработке (до конца марта-начала апреля, так уж вышло)
    * Бесконечные самокопания по поводу заявки
    * Проработка архитектуры проекта
    * Создание макета пользовательского интерфейса
    * Написание пользовательских сценариев
    * При необходимости, отдельное обучение работе с выбранными инструментами до начала основной разработки
2. Разработка (до конца августа)
    * Разработка серверной части: базы данных, API для клиента
    * Разработка клиентского приложения
3. Тестирование, отладка (до конца сентября)
4. Защита проекта (ноябрь)

**[ ВОЗМОЖНЫЕ РИСКИ ]**

* Переоценка собственных возможностей и невыполнение изначальных требований
* Неправильная оценка необходимого стека технологий, нехватка времени на изучение этого стека
* Неспособность спроектировать удобный пользовательский интерфейс
* Неспособность спроектировать подходящую архитектуру сервиса
* Сложности в общении с заказчиком

**[ ПРИМЕЧАНИЕ ]**

Заказчик действительно есть, я его не выдумал... =)
