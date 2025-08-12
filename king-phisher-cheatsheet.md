# 🎯 King Phisher - Краткая Шпаргалка
## Быстрый старт от Фени

---

## 🚀 Установка (одна команда)

```bash
chmod +x king-phisher-installer-fixed.sh && ./king-phisher-installer-fixed.sh
```

---

## ⚙️ Базовая настройка

### 1. Настройка SMTP (Gmail)
```bash
nano ~/.config/king-phisher/server_config.yml

# Замени секцию email:
email:
  smtp_server: smtp.gmail.com
  smtp_port: 587
  smtp_username: your_email@gmail.com
  smtp_password: your_app_password  # Не обычный пароль!
  smtp_ssl: true
```

### 2. Запуск сервера
```bash
cd /opt/king-phisher
./start-king-phisher-server.sh
```

### 3. Запуск клиента  
```bash
./start-king-phisher-client.sh
```

---

## 📊 Мониторинг

```bash
# Статус сервиса
systemctl status king-phisher

# Логи в реальном времени
journalctl -f -u king-phisher

# Логи приложения
tail -f /tmp/king-phisher-server.log

# Веб-интерфейс
open https://localhost:443
```

---

## 🛠️ Устранение неполадок

### Сервер не запускается
```bash
sudo systemctl restart postgresql
sudo systemctl restart king-phisher
./test-king-phisher.sh
```

### SMTP не работает
```bash
# Тест подключения
python3 -c "
import smtplib
server = smtplib.SMTP('smtp.gmail.com', 587)
server.starttls()
server.login('email@gmail.com', 'app_password')
print('SMTP OK!')
server.quit()
"
```

### GUI клиент не запускается
```bash
echo $DISPLAY  # Должен показать :0 или похожее
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0
```

---

## 🎯 Быстрые команды

```bash
# Перезапуск всего
sudo systemctl restart king-phisher

# Очистка логов
sudo truncate -s 0 /tmp/king-phisher-server.log

# Бэкап базы
sudo -u postgres pg_dump kingphisher > backup-$(date +%Y%m%d).sql

# Восстановление базы
sudo -u postgres dropdb kingphisher
sudo -u postgres createdb kingphisher  
sudo -u postgres psql kingphisher < backup-file.sql

# Проверка портов
netstat -tuln | grep -E "(80|443|5432)"

# Просмотр активных кампаний
sudo -u postgres psql kingphisher -c "SELECT name, created FROM campaigns;"
```

---

## 📝 Готовые шаблоны

### Email шаблон (простой)
```
Subject: 🚨 URGENT: Account Security Alert

Dear {{ client.first_name | default("User") }},

Suspicious activity detected on your account.
Verify immediately: {{ url_for('login') }}

Security Team
```

### Список целей (CSV)
```csv
email_address,first_name,last_name,department
test1@company.com,John,Doe,IT
test2@company.com,Jane,Smith,HR
```

---

## 🔍 Полезные файлы

```bash
# Конфигурация
~/.config/king-phisher/server_config.yml

# Логи
/tmp/king-phisher-server.log

# Учетные данные
~/king-phisher-credentials.txt

# Шаблоны  
/opt/king-phisher/templates/soc-testing/

# SSL сертификаты
/opt/king-phisher/data/server/king_phisher/ssl/
```

---

## ⚠️ Важные напоминания

1. **НЕ запускай под root!**
2. **Получи письменное разрешение** перед тестированием
3. **Настрой Gmail App Password**, не используй обычный пароль
4. **Проверь firewall** - порты 80, 443, 5432
5. **Сделай бэкап** перед важными тестами

---

## 🆘 Экстренное восстановление

```bash
# Если все сломалось - полная переустановка
cd /opt && sudo rm -rf king-phisher
sudo -u postgres dropdb kingphisher
sudo -u postgres dropuser kp_user
cd ~ && ./king-phisher-installer-fixed.sh
```

---

**Контакты поддержки:**
- GitHub: https://github.com/rsmusllp/king-phisher
- Документация: https://king-phisher.readthedocs.io/

**Удачи в pwn'е своего SOC! 😈**
