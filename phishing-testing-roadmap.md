# Phishing Tools Testing Roadmap для SOC

## Этап 1: King Phisher (Приоритет: ВЫСОКИЙ)
### Почему первым:
- Максимально близок к реальным enterprise-атакам
- Встроенная аналитика и метрики
- SPF/DKIM поддержка для обхода email security

### Тест-кейсы:
1. **Campaign с credential harvesting**
   - Клон корпоративного портала
   - Harvesting через OAuth redirect
   
2. **Calendar invitation phishing**
   - Фишинг через календарные приглашения
   - Обход календарных фильтров
   
3. **Geographic targeting**
   - Целевые атаки по IP regions
   - Проверка geo-based детекции SOC

4. **Multi-stage campaigns**
   - Последовательные атаки на одни таргеты
   - Проверка correlation rules

### Детекция метрики для SOC:
- Email header analysis (SPF, DKIM, DMARC)
- Suspicious calendar invitations
- Geographic anomalies in login attempts
- Credential stuffing patterns

## Этап 2: SET (Social Engineering Toolkit)
### Почему вторым:
- Разнообразие векторов атак
- Интеграция с другими pentest tools
- Автоматизация для mass campaigns

### Тест-кейсы:
1. **Website cloning attacks**
   - Автоклон legitimate сайтов
   - Injection malicious payloads
   
2. **Mass mailer campaigns**
   - Bulk email отправка
   - Template-based attacks
   
3. **Credential harvester**
   - Advanced form hijacking
   - Multi-step authentication bypass

4. **Integration testing**
   - SET + Metasploit chains
   - Multi-vector campaigns

### Детекция метрики:
- Suspicious domain registrations
- Mass email patterns
- Form submission anomalies
- Multi-vector attack correlation

## Этап 3: Phishing Frenzy (Опциональный)
### Почему последним:
- Less active development
- Ruby on Rails specific
- Более узкая функциональность

### Если времени мало - SKIP!

## Дополнительные инструменты для расширения:

### Evilginx2 (рекомендую!)
```bash
git clone https://github.com/kgretzky/evilginx2.git
```
- Real-time phishing with 2FA bypass
- Advanced session hijacking

### Gophish + Custom modules
- Extend существующий setup
- Custom templates и analytics

## Метрики успеха для SOC:
1. **Detection Rate** - % caught campaigns
2. **False Positive Rate** - legitimate emails blocked  
3. **Response Time** - time to detection
4. **Correlation Quality** - multi-vector detection
5. **User Awareness** - click-through rates

## Инфраструктура для тестирования:

### Isolated Environment:
```yaml
# docker-compose.yml для тест-среды
version: '3.8'
services:
  king-phisher:
    build: ./king-phisher
    ports:
      - "8080:80"
      - "8443:443"
    environment:
      - POSTGRES_DB=kingphisher
      - POSTGRES_USER=kp_user
    networks:
      - phishing_net
      
  set-toolkit:
    build: ./set
    ports:
      - "8081:80"
    networks:
      - phishing_net
      
  analytics:
    image: grafana/grafana
    ports:
      - "3000:3000"
    networks:
      - phishing_net

networks:
  phishing_net:
    driver: bridge
```

## Timeline:
- **Week 1-2**: King Phisher setup & initial campaigns
- **Week 3**: SET integration & advanced vectors  
- **Week 4**: Analysis & SOC rule optimization
- **Week 5**: Documentation & final report

## Legal & Ethics:
- ✅ Written authorization from management
- ✅ Scope documentation  
- ✅ User notification plan
- ✅ Data handling procedures
- ✅ Incident response plan
