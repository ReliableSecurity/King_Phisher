# 🎯 King Phisher - Ultimate SOC Testing Suite
## AKUMA Professional Edition для Red Team & SOC Testing

---

![GitHub stars](https://img.shields.io/github/stars/sweetpotatohack/AKUMA_King_Phisher)
![GitHub forks](https://img.shields.io/github/forks/sweetpotatohack/AKUMA_King_Phisher)
![GitHub issues](https://img.shields.io/github/issues/sweetpotatohack/AKUMA_King_Phisher)
![License](https://img.shields.io/github/license/sweetpotatohack/AKUMA_King_Phisher)

```ascii
██╗  ██╗██╗███╗   ██╗ ██████╗     ██████╗ ██╗  ██╗██╗███████╗██╗  ██╗███████╗██████╗ 
██║ ██╔╝██║████╗  ██║██╔════╝     ██╔══██╗██║  ██║██║██╔════╝██║  ██║██╔════╝██╔══██╗
█████╔╝ ██║██╔██╗ ██║██║  ███╗    ██████╔╝███████║██║███████╗███████║█████╗  ██████╔╝
██╔═██╗ ██║██║╚██╗██║██║   ██║    ██╔═══╝ ██╔══██║██║╚════██║██╔══██║██╔══╝  ██╔══██╗
██║  ██╗██║██║ ╚████║╚██████╔╝    ██║     ██║  ██║██║███████║██║  ██║███████╗██║  ██║
╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
                                                                                      
    🔥 Professional Phishing Framework для SOC Testing & User Awareness 🔥
```

---

## 🚀 Quick Start (TL;DR)

```bash
# Скачай и запусти
git clone https://github.com/sweetpotatohack/AKUMA_King_Phisher.git
cd AKUMA_King_Phisher
chmod +x king-phisher-installer-fixed.sh
./king-phisher-installer-fixed.sh

# Настрой SMTP и запускай
cd /opt/king-phisher
./start-king-phisher-server.sh
./start-king-phisher-client.sh

# Профит! 💀
```

---

## 🎯 Что это такое?

**AKUMA King Phisher** - это профессиональный набор инструментов для:

✅ **SOC Testing** - Проверки эффективности команд безопасности  
✅ **Phishing Awareness** - Обучение пользователей распознавать атаки  
✅ **Red Team Operations** - Симуляция реальных атак  
✅ **Security Training** - Тренировка детекции и реагирования  

### 🔥 Основные фичи:

- **🎨 Professional Templates** - Готовые HTML шаблоны корпоративного уровня
- **📧 Advanced Email Engine** - Поддержка всех популярных SMTP сервисов
- **📊 Real-time Analytics** - Детальная аналитика кампаний
- **🛡️ SOC Integration** - Интеграция с SIEM и SOC процессами
- **🔧 One-click Installation** - Автоматическая установка без головной боли
- **📚 Complete Documentation** - Полная документация на русском языке

---

## 📦 Что входит в комплект?

### 🛠️ Установщики
- **`king-phisher-installer-fixed.sh`** - Автоматический установщик (исправлена поддержка Ubuntu 24.04+)

### 📖 Документация  
- **`king-phisher-manual.md`** - Полное руководство (50+ страниц)
- **`king-phisher-cheatsheet.md`** - Шпаргалка для быстрого старта
- **`phishing-testing-roadmap.md`** - План тестирования SOC команд

### 🎨 Шаблоны
- **`templates/soc-testing/corporate_login.html`** - Корпоративный портал
- **`templates/soc-testing/office365_login.html`** - Имитация Microsoft O365

---

## ⚡ Системные требования

- **OS**: Ubuntu 20.04 LTS+ (протестировано на 24.04)
- **RAM**: 4 GB (рекомендуется 8 GB)
- **Disk**: 10 GB свободного места
- **Network**: Интернет + SMTP доступ

---

## 🚀 Установка

### Автоматическая установка (рекомендуется)

```bash
# 1. Клонируем репозиторий
git clone https://github.com/sweetpotatohack/AKUMA_King_Phisher.git
cd AKUMA_King_Phisher

# 2. Запускаем установщик  
chmod +x king-phisher-installer-fixed.sh
./king-phisher-installer-fixed.sh

# 3. Следуем инструкциям на экране
# Установщик сам настроит PostgreSQL, Python зависимости, SSL сертификаты
```

### Что делает установщик:

✅ Проверяет совместимость системы  
✅ Устанавливает PostgreSQL и настраивает базу данных  
✅ Устанавливает Python зависимости через apt (решает проблему с externally-managed-environment)  
✅ Скачивает и настраивает King Phisher  
✅ Генерирует SSL сертификаты  
✅ Создает systemd сервис  
✅ Настраивает готовые шаблоны для тестирования  

---

## ⚙️ Быстрая настройка

### 1. SMTP конфигурация

```bash
# Редактируем конфиг
nano ~/.config/king-phisher/server_config.yml
```

**Gmail SMTP:**
```yaml
email:
  smtp_server: smtp.gmail.com
  smtp_port: 587
  smtp_username: your_email@gmail.com
  smtp_password: your_app_password  # Не обычный пароль!
  smtp_ssl: true
```

**Office 365 SMTP:**
```yaml
email:
  smtp_server: smtp-mail.outlook.com
  smtp_port: 587
  smtp_username: your_email@company.com
  smtp_password: your_password
  smtp_ssl: true
```

### 2. Запуск сервиса

```bash
cd /opt/king-phisher

# Запуск сервера
./start-king-phisher-server.sh

# Запуск GUI клиента (в новом терминале)
./start-king-phisher-client.sh

# Веб-интерфейс
firefox https://localhost:443
```

---

## 🎯 Создание первой кампании

### 1. В GUI клиенте:

1. **File → New Campaign**
2. Заполни данные:
   ```
   Campaign Name: SOC Test Campaign 1
   Description: Тестирование детекции фишинга
   Company: Your Company
   ```

### 2. Настройка шаблона:

**Простой email:**
```
Subject: 🚨 URGENT: Security Update Required

Dear {{ client.first_name | default("User") }},

Your account requires verification: {{ url_for('login') }}

Security Team
```

**HTML шаблон:**
Используй готовые из `templates/soc-testing/`

### 3. Импорт целей:

**CSV формат:**
```csv
email_address,first_name,last_name,department
john.doe@company.com,John,Doe,IT
jane.smith@company.com,Jane,Smith,HR
```

---

## 📊 Мониторинг результатов

### Веб-интерфейс
- **Dashboard**: https://localhost:443
- **Campaigns**: Список активных кампаний  
- **Messages**: Статус отправленных писем
- **Visits**: Переходы по ссылкам
- **Credentials**: Собранные данные

### Логи
```bash
# Основные логи
tail -f /tmp/king-phisher-server.log

# Системные логи
journalctl -f -u king-phisher

# Статус сервиса
systemctl status king-phisher
```

---

## 🛡️ SOC Testing Scenarios

### Базовые тесты:

#### 1. Email Security Gateway Test
```bash
# Подозрительные индикаторы:
Subject: URGENT: Account Suspended - Click NOW!
From: security@fake-domain.com
Attachments: security_update.exe
```

#### 2. URL Analysis Test  
```bash
# Подозрительные ссылки:
https://secure-bank-verification.suspicious-domain.com
https://bit.ly/malicious-redirect
```

#### 3. Advanced Persistent Threat (APT) Simulation
```bash
# Многоэтапная атака:
Stage 1: Reconnaissance email
Stage 2: Spear phishing на key personnel  
Stage 3: Credential harvesting
Stage 4: Lateral movement simulation
```

### Метрики для анализа:

- **Detection Rate**: % пойманных кампаний
- **Response Time**: Время реакции SOC
- **False Positive Rate**: Ложные срабатывания  
- **User Awareness**: % пользователей, попавшихся на удочку
- **Click-through Rate**: % переходов по ссылкам

---

## 🔧 Устранение проблем

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
echo $DISPLAY  # Проверь X11 forwarding
sudo apt install python3-gi python3-gi-cairo gir1.2-gtk-3.0
```

---

## 📚 Документация

- **[📖 Полное руководство](king-phisher-manual.md)** - Детальная инструкция (16,000+ слов)
- **[⚡ Шпаргалка](king-phisher-cheatsheet.md)** - Быстрый справочник
- **[🗺️ Roadmap](phishing-testing-roadmap.md)** - План тестирования инструментов

---

## 🤝 Contributing

Приветствуются:
- 🐛 Багфиксы
- 📝 Улучшения документации  
- 🎨 Новые шаблоны
- 🔧 Дополнительные скрипты
- 🌍 Переводы на другие языки

### Как внести вклад:

1. Fork репозиторий
2. Создай feature branch (`git checkout -b feature/amazing-feature`)
3. Commit изменения (`git commit -m 'Add amazing feature'`)
4. Push в branch (`git push origin feature/amazing-feature`)
5. Создай Pull Request

---

## ⚖️ Legal & Ethics

**⚠️ ВАЖНО**: Этот инструмент предназначен ТОЛЬКО для:

✅ **Authorized penetration testing**  
✅ **Security awareness training**  
✅ **SOC team training**  
✅ **Educational purposes**  

❌ **НЕ используй для:**
- Unauthorized access
- Malicious activities
- Real phishing attacks
- Illegal activities

**Всегда получай письменное разрешение** перед тестированием!

---

## 📄 License

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для деталей.

---

## 🙏 Acknowledgments

- **King Phisher Team** - За оригинальный фреймворк
- **RSM LLC** - За разработку и поддержку King Phisher
- **Security Community** - За feedback и улучшения
- **SOC Teams worldwide** - За тестирование и отзывы

---

## 🔗 Полезные ссылки

- **Original King Phisher**: https://github.com/rsmusllp/king-phisher
- **Documentation**: https://king-phisher.readthedocs.io/
- **Community**: https://github.com/rsmusllp/king-phisher/discussions

---

## 📈 Roadmap

### v2.0 (Current)
- ✅ Ubuntu 24.04+ support
- ✅ Fixed Python dependencies  
- ✅ Professional templates
- ✅ Complete documentation

### v2.1 (Planned)
- 🔄 SET (Social Engineering Toolkit) integration
- 🔄 Evilginx2 compatibility  
- 🔄 SIEM integration modules
- 🔄 Advanced analytics dashboard

### v3.0 (Future)
- 🔮 Machine Learning detection evasion
- 🔮 Multi-language support
- 🔮 Cloud deployment scripts
- 🔮 Advanced reporting system

---

**Made with ❤️ by the AKUMA team**

*"Лучший фишинг - это тот, который учит, а не вредит. Лучший SOC - это тот, который учится на каждом тесте!"*

⭐ **Если этот проект помог тебе - поставь звездочку!** ⭐
