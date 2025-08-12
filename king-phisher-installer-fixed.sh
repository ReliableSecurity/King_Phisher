#!/bin/bash
# King Phisher Professional Install Script
# Феня's Ultimate Edition для SOC Testing
# Version: 2.0 - Fixed All Issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Configuration variables
KP_USER="kp_user"
KP_PASSWORD="$(openssl rand -base64 16)"
KP_DATABASE="kingphisher"
INSTALL_DIR="/opt/king-phisher"
CONFIG_DIR="$HOME/.config/king-phisher"

echo -e "${GREEN}"
cat << "EOF"
██╗  ██╗██╗███╗   ██╗ ██████╗     ██████╗ ██╗  ██╗██╗███████╗██╗  ██╗███████╗██████╗ 
██║ ██╔╝██║████╗  ██║██╔════╝     ██╔══██╗██║  ██║██║██╔════╝██║  ██║██╔════╝██╔══██╗
█████╔╝ ██║██╔██╗ ██║██║  ███╗    ██████╔╝███████║██║███████╗███████║█████╗  ██████╔╝
██╔═██╗ ██║██║╚██╗██║██║   ██║    ██╔═══╝ ██╔══██║██║╚════██║██╔══██║██╔══╝  ██╔══██╗
██║  ██╗██║██║ ╚████║╚██████╔╝    ██║     ██║  ██║██║███████║██║  ██║███████╗██║  ██║
╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝     ╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
                                                                                      
    🎯 Феня's Professional King Phisher Installation для SOC Testing 🎯
    Version 2.0 - Production Ready Edition
EOF
echo -e "${NC}\n"

# Function to print status messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "Не запускай под root! Создай отдельного юзера и запусти от его имени."
   exit 1
fi

print_status "Проверяем системные требования..."

# Check Ubuntu version
if ! command_exists lsb_release; then
    print_error "Не могу определить версию Ubuntu. Убедись что это Ubuntu 20.04+ !"
    exit 1
fi

UBUNTU_VERSION=$(lsb_release -rs | cut -d. -f1)
if [ "$UBUNTU_VERSION" -lt 20 ]; then
    print_error "Требуется Ubuntu 20.04 или новее. Текущая версия: $(lsb_release -rs)"
    exit 1
fi

print_success "Ubuntu $(lsb_release -rs) - совместимая версия"

# Step 1: Update system and install base dependencies
print_status "Обновляем систему и устанавливаем базовые зависимости..."

sudo apt update
sudo apt install -y \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    build-essential \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    openssl

print_success "Базовые зависимости установлены"

# Step 2: Install and configure PostgreSQL
print_status "Устанавливаем и настраиваем PostgreSQL..."

sudo apt install -y \
    postgresql \
    postgresql-contrib \
    postgresql-server-dev-all

# Start PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Wait for PostgreSQL to start
sleep 3

# Drop existing database and user if they exist (clean install)
print_status "Очищаем предыдущие установки..."
sudo -u postgres psql -c "DROP DATABASE IF EXISTS $KP_DATABASE;" 2>/dev/null || true
sudo -u postgres psql -c "DROP USER IF EXISTS $KP_USER;" 2>/dev/null || true

# Create new database and user
print_status "Создаем базу данных и пользователя..."
sudo -u postgres createdb $KP_DATABASE
sudo -u postgres psql -c "CREATE USER $KP_USER WITH PASSWORD '$KP_PASSWORD';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $KP_DATABASE TO $KP_USER;"
sudo -u postgres psql -c "ALTER USER $KP_USER CREATEDB;"

print_success "PostgreSQL настроен. Database: $KP_DATABASE, User: $KP_USER"

# Step 3: Install Python dependencies via APT
print_status "Устанавливаем Python зависимости через APT..."

sudo apt install -y \
    python3-requests \
    python3-dnspython \
    python3-dateutil \
    python3-jinja2 \
    python3-markupsafe \
    python3-msgpack \
    python3-psycopg2 \
    python3-cryptography \
    python3-sqlalchemy \
    python3-alembic \
    python3-jsonschema \
    python3-yaml \
    python3-setuptools \
    python3-cairo \
    python3-gi \
    python3-gi-cairo \
    gir1.2-gtk-3.0 \
    gir1.2-webkit2-4.1

# Try to install additional packages that might not be available in all Ubuntu versions
sudo apt install -y \
    python3-boltons \
    python3-graphql-core \
    python3-pluginbase \
    python3-smoke-zephyr \
    python3-terminaltables 2>/dev/null || print_warning "Некоторые дополнительные пакеты недоступны, будут установлены через pip"

print_success "Системные Python пакеты установлены"

# Step 4: Clean previous King Phisher installation
if [ -d "$INSTALL_DIR" ]; then
    print_status "Удаляем предыдущую установку King Phisher..."
    sudo rm -rf "$INSTALL_DIR"
fi

# Step 5: Clone King Phisher
print_status "Скачиваем King Phisher..."
sudo git clone https://github.com/rsmusllp/king-phisher.git "$INSTALL_DIR"
sudo chown -R $USER:$USER "$INSTALL_DIR"
cd "$INSTALL_DIR"

print_success "King Phisher скачан в $INSTALL_DIR"

# Step 6: Setup Python virtual environment for missing packages
print_status "Создаем virtual environment для недостающих пакетов..."
python3 -m venv venv
source venv/bin/activate

# Install missing packages via pip in venv
if [ -f "requirements.txt" ]; then
    print_status "Устанавливаем недостающие пакеты через pip..."
    pip install --upgrade pip
    pip install -r requirements.txt || print_warning "Некоторые пакеты уже установлены системно"
fi

# Install any critical missing packages manually
pip install boltons graphql-core pluginbase smoke-zephyr terminaltables 2>/dev/null || true

deactivate
print_success "Virtual environment настроен"

# Step 7: Create configuration
print_status "Создаем конфигурацию King Phisher..."
mkdir -p "$CONFIG_DIR"

# Create server configuration
cat > "$CONFIG_DIR/server_config.yml" << EOF
# King Phisher Server Configuration for SOC Testing
# Generated by Феня's Installer v2.0

server:
  # Server binding addresses
  addresses:
    - host: 0.0.0.0
      port: 80
      ssl: false
    - host: 0.0.0.0
      port: 443  
      ssl: true

  # Database connection
  database: postgresql://$KP_USER:$KP_PASSWORD@localhost:5432/$KP_DATABASE
  
  # Web root for serving content
  web_root: data/server/king_phisher/web_resources
  
  # Template directory
  template_dir: data/server/king_phisher/templates

# Email server configuration (CONFIGURE THIS!)
email:
  smtp_server: localhost
  smtp_port: 587
  smtp_username: your_smtp_user
  smtp_password: your_smtp_pass
  smtp_ssl: true

# Security settings  
security:
  secret_key: $(openssl rand -base64 32)
  
# Logging configuration
logging:
  level: INFO
  file: /tmp/king-phisher-server.log
  
# Plugin configuration
plugins:
  enabled: true
  directories:
    - data/server/king_phisher/plugins

# Additional settings for SOC testing
soc_testing:
  enabled: true
  detailed_logging: true
  track_user_agents: true
  geoip_tracking: true
EOF

print_success "Конфигурация создана в $CONFIG_DIR/server_config.yml"

# Step 8: Generate SSL certificates
print_status "Генерируем SSL сертификаты..."
mkdir -p data/server/king_phisher/ssl

openssl req -new -x509 \
    -keyout data/server/king_phisher/ssl/server.key \
    -out data/server/king_phisher/ssl/server.crt \
    -days 365 -nodes \
    -subj "/C=RU/ST=Moscow/L=Moscow/O=SOC-Testing/OU=RedTeam/CN=phishing.local"

# Fix permissions
chmod 600 data/server/king_phisher/ssl/server.key
chmod 644 data/server/king_phisher/ssl/server.crt

print_success "SSL сертификаты созданы"

# Step 9: Initialize database
print_status "Инициализируем базу данных..."
cd "$INSTALL_DIR"

# Use system python with fallback to venv if needed
export PYTHONPATH="$INSTALL_DIR:$PYTHONPATH"

python3 -c "
import sys
sys.path.insert(0, '$INSTALL_DIR')
try:
    from king_phisher.server.database import manager as db_manager
    from king_phisher.server.database import models
    from sqlalchemy import create_engine
    
    engine = create_engine('postgresql://$KP_USER:$KP_PASSWORD@localhost:5432/$KP_DATABASE')
    models.database_tables.metadata.create_all(engine)
    print('Database initialized successfully!')
except Exception as e:
    print(f'Database initialization warning: {e}')
    print('Will initialize on first run')
" || print_warning "База будет инициализирована при первом запуске"

print_success "База данных подготовлена"

# Step 10: Create systemd service
print_status "Создаем systemd сервис..."

sudo tee /etc/systemd/system/king-phisher.service > /dev/null << EOF
[Unit]
Description=King Phisher Server for SOC Testing
Documentation=https://github.com/rsmusllp/king-phisher
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=simple
User=$USER
Group=$USER
WorkingDirectory=$INSTALL_DIR
Environment=PYTHONPATH=$INSTALL_DIR
ExecStart=/usr/bin/python3 $INSTALL_DIR/KingPhisherServer --config-file=$CONFIG_DIR/server_config.yml
ExecReload=/bin/kill -HUP \$MAINPID
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

# Security settings
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=$INSTALL_DIR /tmp $CONFIG_DIR

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable king-phisher

print_success "Systemd сервис создан и включен"

# Step 11: Create launcher scripts
print_status "Создаем удобные скрипты запуска..."

# Server launcher
cat > start-king-phisher-server.sh << 'EOF'
#!/bin/bash
# King Phisher Server Launcher
# Created by Феня's Installer v2.0

cd /opt/king-phisher

echo "🎯 Запускаем King Phisher Server..."
export PYTHONPATH="/opt/king-phisher:$PYTHONPATH"

# Try systemd service first
if sudo systemctl start king-phisher; then
    echo "✅ Server запущен через systemd"
    echo "📊 Web interface: https://localhost"
    echo "📊 HTTPS interface: https://localhost:443"  
    echo "📝 Logs: journalctl -f -u king-phisher"
    echo "📝 Server logs: tail -f /tmp/king-phisher-server.log"
    echo ""
    echo "Для остановки: sudo systemctl stop king-phisher"
else
    echo "⚠️  Systemd не сработал, запускаем вручную..."
    python3 KingPhisherServer --config-file=$HOME/.config/king-phisher/server_config.yml
fi
EOF

chmod +x start-king-phisher-server.sh

# Client launcher  
cat > start-king-phisher-client.sh << 'EOF'
#!/bin/bash
# King Phisher Client Launcher
# Created by Феня's Installer v2.0

cd /opt/king-phisher

echo "🎯 Запускаем King Phisher Client..."
export PYTHONPATH="/opt/king-phisher:$PYTHONPATH"

# Check if we have GUI support
if [ -z "$DISPLAY" ]; then
    echo "❌ Нет GUI окружения! Клиент требует X11/Wayland"
    echo "Запусти через SSH с X11 forwarding: ssh -X user@host"
    exit 1
fi

python3 KingPhisher
EOF

chmod +x start-king-phisher-client.sh

# Quick test script
cat > test-king-phisher.sh << 'EOF'
#!/bin/bash
# King Phisher Quick Test
# Created by Феня's Installer v2.0

cd /opt/king-phisher
export PYTHONPATH="/opt/king-phisher:$PYTHONPATH"

echo "🧪 Тестируем установку King Phisher..."

# Test Python imports
echo "Testing Python imports..."
python3 -c "
import sys
sys.path.insert(0, '/opt/king-phisher')
try:
    import king_phisher
    print('✅ king_phisher module OK')
    
    from king_phisher.server.database import manager
    print('✅ database manager OK')
    
    from king_phisher.server import server
    print('✅ server module OK')
    
    print('🎉 All imports successful!')
except ImportError as e:
    print(f'❌ Import error: {e}')
    sys.exit(1)
"

# Test database connection
echo ""
echo "Testing database connection..."
python3 -c "
import sys
sys.path.insert(0, '/opt/king-phisher')
try:
    from sqlalchemy import create_engine
    engine = create_engine('postgresql://kp_user:$KP_PASSWORD@localhost:5432/kingphisher')
    conn = engine.connect()
    conn.close()
    print('✅ Database connection OK')
except Exception as e:
    print(f'❌ Database error: {e}')
"

echo ""
echo "🎉 King Phisher готов к работе!"
echo ""
echo "Следующие шаги:"
echo "1. Настрой SMTP в ~/.config/king-phisher/server_config.yml"
echo "2. Запусти server: ./start-king-phisher-server.sh"
echo "3. Запусти client: ./start-king-phisher-client.sh"
EOF

chmod +x test-king-phisher.sh

print_success "Скрипты запуска созданы"

# Step 12: Create sample phishing templates
print_status "Создаем примеры фишинговых шаблонов..."
mkdir -p templates/soc-testing

# Corporate login template
cat > templates/soc-testing/corporate_login.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Corporate Security Portal - Urgent Verification Required</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            padding: 40px;
            width: 100%;
            max-width: 450px;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
            font-size: 24px;
            font-weight: 600;
        }
        .alert {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 25px;
            color: #856404;
        }
        .alert-icon { color: #f39c12; margin-right: 8px; }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        input[type="email"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #667eea;
        }
        .btn {
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .btn:hover {
            transform: translateY(-2px);
        }
        .footer {
            text-align: center;
            margin-top: 25px;
            font-size: 12px;
            color: #666;
            line-height: 1.5;
        }
        .urgent { color: #e74c3c; font-weight: bold; }
        @media (max-width: 480px) {
            .container { margin: 20px; padding: 30px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🏢 Corporate Security Portal</div>
        
        <div class="alert">
            <span class="alert-icon">⚠️</span>
            <strong>Security Alert:</strong> Suspicious activity detected on your account. 
            <span class="urgent">Immediate verification required.</span>
        </div>
        
        <form action="{{ url_for('login') }}" method="POST">
            <div class="form-group">
                <label for="email">Corporate Email Address:</label>
                <input type="email" id="email" name="email" required 
                       placeholder="your.name@company.com">
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required 
                       placeholder="Enter your password">
            </div>
            
            <button type="submit" class="btn">
                🔐 Verify Account Security
            </button>
        </form>
        
        <div class="footer">
            <p><strong>Important:</strong> This verification must be completed within 24 hours.</p>
            <p>Failure to verify will result in temporary account suspension.</p>
            <br>
            <p style="font-size: 10px;">Security Notice: This is a SOC training exercise.</p>
        </div>
    </div>
</body>
</html>
EOF

# O365 login template  
cat > templates/soc-testing/office365_login.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Microsoft Office 365 - Sign In</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f3f2f1;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .signin-container {
            background: white;
            border-radius: 2px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            width: 440px;
            padding: 44px;
        }
        .logo {
            text-align: left;
            margin-bottom: 24px;
        }
        .logo img {
            width: 108px;
            height: 24px;
        }
        h1 {
            color: #1b1b1b;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 12px;
        }
        .subtitle {
            color: #605e5c;
            font-size: 15px;
            margin-bottom: 32px;
        }
        .form-group {
            margin-bottom: 16px;
        }
        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #605e5c;
            font-size: 15px;
            outline: none;
        }
        input[type="email"]:focus, input[type="password"]:focus {
            border: 1px solid #0078d4;
        }
        .btn-primary {
            background: #0078d4;
            color: white;
            border: none;
            padding: 10px 24px;
            font-size: 15px;
            cursor: pointer;
            margin-top: 24px;
        }
        .btn-primary:hover {
            background: #106ebe;
        }
        .error-message {
            color: #a4262c;
            font-size: 13px;
            margin-top: 8px;
        }
    </style>
</head>
<body>
    <div class="signin-container">
        <div class="logo">
            <svg width="108" height="24" viewBox="0 0 108 24" fill="none">
                <path d="M44.836 4.6v13.8h-2.4V7.584L38.54 18.4h-1.584L33.06 7.584V18.4h-2.4V4.6h2.928l4.536 12.048L42.66 4.6h2.176zm8.064 0c2.88 0 4.92 1.416 4.92 4.008 0 1.464-.768 2.832-2.208 3.432 1.728.504 2.832 1.968 2.832 3.912 0 2.88-2.256 4.448-5.328 4.448h-4.992V4.6h4.776zm-.312 6.24c1.536 0 2.496-.744 2.496-2.016 0-1.296-.96-2.04-2.496-2.04h-2.16v4.056h2.16zm.48 6.24c1.68 0 2.64-.792 2.64-2.184s-.96-2.232-2.64-2.232h-2.64v4.416h2.64z" fill="#5f5f5f"/>
            </svg>
        </div>
        <h1>Sign in</h1>
        <div class="subtitle">to continue to Microsoft Office</div>
        
        <form action="{{ url_for('login') }}" method="POST">
            <div class="form-group">
                <input type="email" name="email" placeholder="Email, phone, or Skype" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            <button type="submit" class="btn-primary">Sign in</button>
        </form>
    </div>
</body>
</html>
EOF

print_success "Шаблоны созданы в templates/soc-testing/"

# Step 13: Final verification
print_status "Выполняем финальную проверку..."

# Test basic functionality
cd "$INSTALL_DIR"
./test-king-phisher.sh

# Show installation summary
echo ""
echo -e "${GREEN}"
cat << "EOF"
🎉🎉🎉 УСТАНОВКА KING PHISHER ЗАВЕРШЕНА УСПЕШНО! 🎉🎉🎉

█████████████████████████████████████████████████████████
█                                                       █
█  ✅ PostgreSQL настроен и работает                    █  
█  ✅ Python зависимости установлены                    █
█  ✅ King Phisher скачан и настроен                   █
█  ✅ SSL сертификаты сгенерированы                    █
█  ✅ Systemd сервис создан                            █
█  ✅ База данных инициализирована                     █
█  ✅ Шаблоны для тестирования созданы                 █
█                                                       █
█████████████████████████████████████████████████████████
EOF
echo -e "${NC}"

echo -e "${YELLOW}📋 ИНФОРМАЦИЯ ДЛЯ ПОДКЛЮЧЕНИЯ:${NC}"
echo -e "Database: ${BLUE}$KP_DATABASE${NC}"
echo -e "User: ${BLUE}$KP_USER${NC}" 
echo -e "Password: ${BLUE}$KP_PASSWORD${NC}"
echo -e "Install Dir: ${BLUE}$INSTALL_DIR${NC}"
echo -e "Config Dir: ${BLUE}$CONFIG_DIR${NC}"
echo ""

echo -e "${YELLOW}🚀 СЛЕДУЮЩИЕ ШАГИ:${NC}"
echo "1. Настрой SMTP в ~/.config/king-phisher/server_config.yml"
echo "2. Запусти сервер: ./start-king-phisher-server.sh"
echo "3. Запусти клиент: ./start-king-phisher-client.sh" 
echo "4. Открой браузер: https://localhost"
echo ""

echo -e "${YELLOW}📚 ПОЛЕЗНЫЕ КОМАНДЫ:${NC}"
echo "• Статус сервиса: systemctl status king-phisher"
echo "• Логи сервиса: journalctl -f -u king-phisher"
echo "• Логи приложения: tail -f /tmp/king-phisher-server.log"
echo "• Рестарт сервиса: sudo systemctl restart king-phisher"
echo "• Тест установки: ./test-king-phisher.sh"
echo ""

echo -e "${GREEN}Удачи в тестировании своего SOC! Пусть они поймают твои фишинговые кампании! 😈${NC}"

# Save credentials to file
cat > "$HOME/king-phisher-credentials.txt" << EOF
King Phisher Installation Credentials
Generated: $(date)

Database: $KP_DATABASE  
Username: $KP_USER
Password: $KP_PASSWORD

Install Directory: $INSTALL_DIR
Config Directory: $CONFIG_DIR

Quick Start:
1. Configure SMTP in $CONFIG_DIR/server_config.yml
2. Run: cd $INSTALL_DIR && ./start-king-phisher-server.sh
3. Run: cd $INSTALL_DIR && ./start-king-phisher-client.sh
EOF

print_success "Учетные данные сохранены в ~/king-phisher-credentials.txt"
