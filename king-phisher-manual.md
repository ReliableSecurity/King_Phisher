# 🎯 King Phisher - Полная Инструкция для SOC Testing
## Феня's Ultimate Manual v2.0

---

## 📋 Оглавление
1. [Системные требования](#системные-требования)
2. [Автоматическая установка](#автоматическая-установка)
3. [Настройка SMTP](#настройка-smtp)
4. [Первый запуск](#первый-запуск)
5. [Создание кампании](#создание-кампании)
6. [Мониторинг и логи](#мониторинг-и-логи)
7. [Тестирование SOC](#тестирование-soc)
8. [Решение проблем](#решение-проблем)
9. [Расширенные настройки](#расширенные-настройки)
10. [Лучшие практики](#лучшие-практики)

---

## 🖥️ Системные требования

### Минимальные требования:
- **ОС**: Ubuntu 20.04 LTS или новее
- **RAM**: 4 GB (рекомендуется 8 GB)
- **Disk**: 10 GB свободного места
- **CPU**: 2 cores (рекомендуется 4 cores)
- **Network**: Доступ к интернету

### Дополнительные требования:
- Root доступ (через sudo)
- SMTP сервер (для отправки email)
- Домен или IP для веб-интерфейса
- SSL сертификат (будет создан автоматически)

---

## 🚀 Автоматическая установка

### Шаг 1: Скачивание установщика

```bash
# Переходим в домашнюю директорию
cd ~

# Скачиваем установщик (если еще не скачали)
wget https://raw.githubusercontent.com/your-repo/king-phisher-installer-fixed.sh

# Или используем готовый файл
chmod +x king-phisher-installer-fixed.sh
```

### Шаг 2: Запуск установки

```bash
# Запускаем автоматический установщик
./king-phisher-installer-fixed.sh
```

**⚠️ ВАЖНО**: Не запускай под root! Создай отдельного пользователя.

### Шаг 3: Проверка установки

После успешной установки проверь статус:

```bash
cd /opt/king-phisher
./test-king-phisher.sh
```

---

## 📧 Настройка SMTP

### Настройка Gmail SMTP

Отредактируй конфиг:
```bash
nano ~/.config/king-phisher/server_config.yml
```

Замени секцию email:
```yaml
email:
  smtp_server: smtp.gmail.com
  smtp_port: 587
  smtp_username: your_email@gmail.com
  smtp_password: your_app_password
  smtp_ssl: true
```

### Настройка Office 365 SMTP

```yaml
email:
  smtp_server: smtp-mail.outlook.com
  smtp_port: 587
  smtp_username: your_email@company.com
  smtp_password: your_password
  smtp_ssl: true
```

### Настройка локального Postfix

```bash
# Установка postfix
sudo apt install postfix mailutils

# Конфигурация в King Phisher
email:
  smtp_server: localhost
  smtp_port: 25
  smtp_username: ""
  smtp_password: ""
  smtp_ssl: false
```

---

## 🎯 Первый запуск

### 1. Запуск сервера

```bash
cd /opt/king-phisher
./start-king-phisher-server.sh
```

Сервер запустится на:
- **HTTP**: http://localhost
- **HTTPS**: https://localhost:443

### 2. Проверка статуса сервиса

```bash
# Статус systemd сервиса
systemctl status king-phisher

# Логи в реальном времени
journalctl -f -u king-phisher

# Логи приложения
tail -f /tmp/king-phisher-server.log
```

### 3. Запуск GUI клиента

```bash
# Для локального запуска
./start-king-phisher-client.sh

# Для удаленного запуска через SSH
ssh -X username@server_ip
cd /opt/king-phisher
./start-king-phisher-client.sh
```

---

## 📝 Создание первой кампании

### 1. Подключение к серверу

1. Запусти клиент King Phisher
2. В окне подключения введи:
   - **Server**: `localhost` (или IP сервера)
   - **Username**: твой системный пользователь
   - **Password**: оставь пустым (для локального подключения)

### 2. Создание новой кампании

1. **File → New Campaign**
2. Заполни данные кампании:
   ```
   Campaign Name: SOC Test Campaign 1
   Description: Тестирование обнаружения фишинга
   Company: Your Company Name
   ```

### 3. Настройка email шаблона

#### Простой шаблон:
```
Subject: 🚨 URGENT: Security Update Required

Dear {{ client.first_name | default("User") }},

Your corporate account requires immediate verification due to suspicious activity 
detected on {{ campaign.created | strftime("%B %d, %Y") }}.

Click here to verify: {{ url_for('login') }}

This verification must be completed within 24 hours.

Best regards,
IT Security Team
```

#### HTML шаблон (используй готовые из templates/soc-testing/):
- `corporate_login.html` - корпоративный портал
- `office365_login.html` - имитация O365

### 4. Настройка целей (Targets)

#### Импорт из CSV:
```csv
email_address,first_name,last_name,department
john.doe@company.com,John,Doe,IT
jane.smith@company.com,Jane,Smith,HR
```

#### Ручное добавление:
1. **Targets → Import**
2. Выбери CSV файл или добавь вручную

### 5. Запуск кампании

1. Проверь все настройки
2. **Campaign → Send Messages**
3. Подтверди отправку

---

## 📊 Мониторинг и логи

### Веб-интерфейс мониторинга

Открой в браузере: `https://localhost:443`

**Основные разделы:**
- **Dashboard**: Общая статистика
- **Campaigns**: Список кампаний
- **Messages**: Отправленные сообщения
- **Visits**: Переходы по ссылкам
- **Credentials**: Собранные данные

### Логи для анализа

```bash
# Основные логи King Phisher
tail -f /tmp/king-phisher-server.log

# Логи systemd сервиса
journalctl -f -u king-phisher

# Логи PostgreSQL
sudo tail -f /var/log/postgresql/postgresql-16-main.log

# Логи веб-сервера (nginx/apache если используешь)
tail -f /var/log/nginx/access.log
```

### Экспорт результатов

```bash
# Экспорт в CSV через CLI
cd /opt/king-phisher
python3 -c "
import sys
sys.path.insert(0, '/opt/king-phisher')
from king_phisher.server.database import manager as db_manager
# Ваш код для экспорта
"
```

---

## 🛡️ Тестирование SOC

### 1. Базовые тест-кейсы

#### Тест 1: Email Detection
```bash
# Создай кампанию с подозрительными индикаторами:
Subject: URGENT: Account Suspended - Click Here NOW!
From: noreply@secure-bank.com (поддельный домен)
```

#### Тест 2: URL Analysis  
```bash
# Используй подозрительные URL:
https://secure-bank-verification.suspicious-domain.com
https://login-verification.bit.ly/shortened-url
```

#### Тест 3: Attachment Testing
```bash
# Добавь подозрительные вложения:
- security_update.pdf.exe
- urgent_document.zip (с password)
- company_policy.docm (с макросами)
```

### 2. Продвинутые сценарии

#### Spear Phishing Test:
```bash
# Персонализированные атаки на ключевых сотрудников
Target: CEO, CFO, IT Admin
Content: Специфичные для их роли сценарии
Timing: Отправка в рабочее время
```

#### Business Email Compromise (BEC):
```bash
# Имитация внутренней переписки
From: CEO <ceo@company.com> (spoofed)
Subject: RE: Urgent Payment Request
Content: Запрос на перевод средств
```

### 3. Метрики для SOC

Отслеживай следующие показатели:

```bash
# Email Security Gateway
- Сколько писем заблокировано
- Время до блокировки
- Причины блокировки

# SIEM/SOC Detection
- Время до обнаружения события
- Качество алертов
- False positive rate

# User Behavior  
- Количество переходов по ссылкам
- Введенные credentials
- Время реакции пользователей
```

---

## 🔧 Решение проблем

### Проблема 1: Сервер не запускается

```bash
# Проверь статус PostgreSQL
sudo systemctl status postgresql

# Проверь конфигурацию
python3 -c "import yaml; print(yaml.safe_load(open('/home/user/.config/king-phisher/server_config.yml')))"

# Проверь права доступа
ls -la /opt/king-phisher/data/server/king_phisher/ssl/
```

### Проблема 2: SMTP ошибки

```bash
# Тест SMTP подключения
python3 -c "
import smtplib
server = smtplib.SMTP('smtp.gmail.com', 587)
server.starttls()
server.login('your_email@gmail.com', 'your_password')
print('SMTP OK!')
server.quit()
"
```

### Проблема 3: GUI клиент не запускается

```bash
# Проверь X11 forwarding
echo $DISPLAY

# Установи недостающие GUI пакеты
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0

# Запуск с диагностикой
cd /opt/king-phisher
python3 KingPhisher --debug
```

### Проблема 4: Database ошибки

```bash
# Пересоздание базы
sudo -u postgres dropdb kingphisher
sudo -u postgres createdb kingphisher
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE kingphisher TO kp_user;"

# Инициализация схемы
cd /opt/king-phisher
python3 -c "
import sys
sys.path.insert(0, '/opt/king-phisher')
from king_phisher.server.database import models
from sqlalchemy import create_engine
engine = create_engine('postgresql://kp_user:password@localhost/kingphisher')
models.database_tables.metadata.create_all(engine)
"
```

---

## ⚙️ Расширенные настройки

### 1. Настройка SSL сертификатов

#### Let's Encrypt (для продакшена):
```bash
# Установка certbot
sudo apt install certbot

# Получение сертификата
sudo certbot certonly --standalone -d your-domain.com

# Обновление конфига King Phisher
ssl_cert: /etc/letsencrypt/live/your-domain.com/fullchain.pem  
ssl_key: /etc/letsencrypt/live/your-domain.com/privkey.pem
```

#### Самоподписанный сертификат:
```bash
# Генерация нового сертификата
cd /opt/king-phisher/data/server/king_phisher/ssl/
openssl req -new -x509 -keyout server.key -out server.crt -days 365 -nodes \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=your-domain.com"
```

### 2. Настройка плагинов

#### Включение плагинов:
```yaml
# В server_config.yml
plugins:
  enabled: true
  directories:
    - data/server/king_phisher/plugins
```

#### Популярные плагины:
- **Email Templates**: Дополнительные шаблоны
- **SMS Integration**: Отправка SMS
- **Webhook Notifications**: Интеграция с внешними системами

### 3. Интеграция с SIEM

#### Syslog отправка:
```yaml
logging:
  level: INFO
  file: /tmp/king-phisher-server.log
  syslog:
    enabled: true
    host: siem-server.company.com
    port: 514
```

#### Webhook уведомления:
```python
# Кастомный webhook плагин
import requests

def on_email_opened(event):
    payload = {
        'event': 'email_opened',
        'campaign': event.campaign_id,
        'target': event.target_email,
        'timestamp': event.timestamp
    }
    requests.post('https://siem.company.com/webhook', json=payload)
```

---

## 💡 Лучшие практики

### 1. Безопасность

```bash
# Ограничение доступа к серверу
sudo ufw allow from 192.168.1.0/24 to any port 443
sudo ufw allow from 10.0.0.0/8 to any port 443

# Изоляция в отдельной сети
# Используй VLAN или отдельный сегмент сети

# Регулярные бэкапы
sudo -u postgres pg_dump kingphisher > backup-$(date +%Y%m%d).sql
```

### 2. Этические аспекты

```bash
# Документация для Legal/HR:
1. Письменное разрешение от руководства
2. Уведомление сотрудников о тестировании
3. Четкие границы тестирования
4. План реагирования на инциденты
5. Обучение после тестирования
```

### 3. Эффективное тестирование

```bash
# Планирование кампаний:
1. Baseline тест - простой фишинг
2. Spear phishing - целевые атаки  
3. Business Email Compromise
4. Vishing (voice phishing) симуляция
5. SMS фишинг (smishing)

# Метрики эффективности:
- Click-through rate
- Credential capture rate  
- Время до обнаружения SOC
- Количество ложных срабатываний
- Время реакции команды
```

### 4. Мониторинг производительности

```bash
# Системные метрики
htop  # CPU и память
iotop # Дисковые операции
netstat -tuln # Сетевые подключения

# King Phisher метрики
tail -f /tmp/king-phisher-server.log | grep -E "(ERROR|WARNING)"

# PostgreSQL мониторинг
sudo -u postgres psql -c "
SELECT 
  datname,
  numbackends as connections,
  xact_commit as commits,
  xact_rollback as rollbacks
FROM pg_stat_database 
WHERE datname='kingphisher';
"
```

---

## 📞 Поддержка и дополнительные ресурсы

### Официальные ресурсы:
- **GitHub**: https://github.com/rsmusllp/king-phisher  
- **Documentation**: https://king-phisher.readthedocs.io/
- **Community**: https://github.com/rsmusllp/king-phisher/discussions

### Команды для диагностики:
```bash
# Полная диагностика системы
cd /opt/king-phisher
./test-king-phisher.sh

# Информация об установке  
cat ~/king-phisher-credentials.txt

# Проверка сервисов
systemctl status king-phisher postgresql

# Тест производительности
ab -n 1000 -c 10 https://localhost:443/
```

### Логи для отправки в поддержку:
```bash
# Создание диагностического архива
tar -czf king-phisher-logs-$(date +%Y%m%d).tar.gz \
  /tmp/king-phisher-server.log \
  ~/.config/king-phisher/server_config.yml \
  ~/king-phisher-credentials.txt
```

---

## 🎯 Заключение

King Phisher - мощный инструмент для тестирования осведомленности о фишинге и проверки эффективности SOC команд. 

**Помни главные принципы:**
1. **Всегда получай письменное разрешение** перед тестированием
2. **Уведомляй команду** о проводимых тестах
3. **Используй результаты для обучения**, а не для наказания
4. **Документируй все действия** и результаты
5. **Соблюдай этические границы** тестирования

**Как говорил мой дед-хакер**: *"Лучший фишинг - это тот, который учит, а не вредит. А лучший SOC - это тот, который учится на каждом тесте!"* 🎯

---

*Удачи в тестировании! Пусть твой SOC станет непробиваемой крепостью! 🛡️*
