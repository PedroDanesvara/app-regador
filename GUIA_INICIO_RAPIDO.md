# ⚡ Guia de Início Rápido - Sistema de Monitoramento ESP32

## 🎯 Objetivo
Configurar todo o sistema em **30 minutos** para começar a monitorar temperatura e umidade do solo.

## 📋 Checklist de Pré-requisitos

### Hardware Necessário
- [ ] ESP32 (qualquer modelo)
- [ ] Sensor de umidade do solo capacitivo v2.0
- [ ] Sensor de temperatura DS18B20 (opcional)
- [ ] Protoboard e jumpers
- [ ] Cabo USB para ESP32
- [ ] Resistor 4.7kΩ (para sensor de temperatura)

### Software Necessário
- [ ] Arduino IDE instalado
- [ ] Node.js 16+ instalado
- [ ] Expo CLI instalado
- [ ] Dispositivo móvel com Expo Go

### Rede
- [ ] Rede WiFi 2.4GHz
- [ ] IP fixo ou DHCP configurado

## ⚡ Configuração Rápida (30 min)

### Etapa 1: ESP32 (15 min)

#### 1.1 Conexões Físicas
```
ESP32          Sensor v2.0
3.3V    →      VCC
GND     →      GND
GPIO 36 →      AOUT

ESP32          DS18B20 (opcional)
3.3V    →      VCC
GND     →      GND
GPIO 4  →      DATA
4.7kΩ   →      DATA ↔ VCC (pull-up)
```

#### 1.2 Configuração Arduino IDE
1. **Instalar ESP32 Board Package**:
   - Arduino IDE → File → Preferences
   - Adicionar: `https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json`
   - Tools → Board → ESP32 Arduino → ESP32 Dev Module

2. **Instalar Bibliotecas**:
   ```
   Sketch → Include Library → Manage Libraries
   - ArduinoJson (versão 6.x)
   - OneWire
   - DallasTemperature
   ```

#### 1.3 Upload do Código
1. **Abrir arquivo**: `esp32/main.ino`
2. **Configurar WiFi**: Editar `esp32/config.h`
   ```cpp
   #define WIFI_SSID "SUA_REDE_WIFI"
   #define WIFI_PASSWORD "SUA_SENHA_WIFI"
   #define API_URL "http://192.168.1.100:3000/api/sensors"
   ```
3. **Upload**: Conectar ESP32 e clicar em Upload
4. **Verificar**: Monitor Serial deve mostrar "Conectado ao WiFi"

### Etapa 2: API Node.js (10 min)

#### 2.1 Instalação
```bash
cd api
npm install
```

#### 2.2 Configuração
```bash
cp env.example .env
# Editar .env se necessário
```

#### 2.3 Inicialização
```bash
npm run init-db
npm start
```

#### 2.4 Verificação
```bash
curl http://localhost:3000/health
# Deve retornar: {"status":"ok","timestamp":"..."}
```

### Etapa 3: App Mobile (5 min)

#### 3.1 Instalação
```bash
cd app
npm install
```

#### 3.2 Configuração
Editar `app/src/services/apiService.js`:
```javascript
const API_BASE_URL = 'http://192.168.1.100:3000/api';
```

#### 3.3 Execução
```bash
npm start
```

#### 3.4 Teste no Dispositivo
1. Instalar Expo Go no celular
2. Escanear QR Code
3. Inserir Device ID: `ESP32_001`
4. Conectar e monitorar

## 🔧 Configurações Avançadas

### Personalizar Intervalo de Medição
**ESP32** (`esp32/config.h`):
```cpp
const unsigned long intervaloMedicao = 10000; // 10 segundos
```

**App** (`app/src/context/DeviceContext.js`):
```javascript
interval = setInterval(updateDeviceData, 10000); // 10 segundos
```

### Calibrar Sensor de Umidade
**ESP32** (`esp32/main.ino`):
```cpp
// Ajustar conforme seu sensor
const int VALOR_SECO = 4095;    // Solo seco
const int VALOR_MOLHADO = 1800; // Solo molhado
```

### Configurar Múltiplos Dispositivos
**ESP32** (`esp32/config.h`):
```cpp
#define DEVICE_ID "ESP32_002" // ID único para cada dispositivo
```

## 🚨 Solução de Problemas Rápida

### ESP32 não conecta
- ✅ Verificar nome da rede WiFi
- ✅ Confirmar senha correta
- ✅ Verificar se é rede 2.4GHz
- ✅ Verificar distância do roteador

### API não responde
- ✅ Verificar se está rodando: `npm start`
- ✅ Verificar porta 3000 livre
- ✅ Verificar firewall
- ✅ Testar: `curl http://localhost:3000/health`

### App não conecta
- ✅ Verificar IP da API no app
- ✅ Confirmar rede WiFi
- ✅ Verificar se API está rodando
- ✅ Testar no navegador: `http://IP:3000/api/devices`

### Dados não aparecem
- ✅ Verificar Device ID correto
- ✅ Confirmar ESP32 enviando dados
- ✅ Verificar logs da API
- ✅ Testar endpoint: `curl http://IP:3000/api/sensors/latest/ESP32_001`

## 📊 Testes Rápidos

### Teste 1: ESP32 → API
```bash
# Simular dados do ESP32
curl -X POST http://localhost:3000/api/sensors \
  -H "Content-Type: application/json" \
  -d '{
    "device_id": "ESP32_001",
    "temperatura": 25.5,
    "umidade_solo": 65,
    "timestamp": 1234567890
  }'
```

### Teste 2: API → App
```bash
# Buscar dados mais recentes
curl http://localhost:3000/api/sensors/latest/ESP32_001
```

### Teste 3: Controle da Bomba
```bash
# Ativar bomba
curl -X POST http://localhost:3000/api/devices/pump \
  -H "Content-Type: application/json" \
  -d '{"device_id": "ESP32_001", "action": "on"}'
```

## 📱 Comandos Úteis

### ESP32
```bash
# Monitor Serial
# Baud Rate: 115200
# Verificar logs de conexão e envio
```

### API
```bash
# Logs em tempo real
npm run dev

# Reiniciar servidor
npm start

# Verificar banco
sqlite3 database/sensors.db ".tables"
```

### App
```bash
# Limpar cache
npx expo start --clear

# Logs detalhados
npx expo start --dev-client
```

## 🎯 Próximos Passos

### Após Configuração Básica
1. **Testar Funcionamento**: Verificar dados chegando no app
2. **Calibrar Sensores**: Ajustar valores para seu ambiente
3. **Configurar Backup**: Script de backup do banco
4. **Monitoramento**: Logs e alertas

### Melhorias Sugeridas
1. **Segurança**: HTTPS e autenticação
2. **Notificações**: Alertas por email/SMS
3. **Gráficos**: Visualização histórica
4. **Múltiplos Dispositivos**: Dashboard centralizado

## 📞 Suporte

### Logs Importantes
- **ESP32**: Monitor Serial (115200 baud)
- **API**: Console do terminal
- **App**: Metro bundler console

### Recursos Adicionais
- 📚 [Documentação Completa](DOCUMENTACAO_COMPLETA.md)
- 📊 [Diagramas do Sistema](DIAGRAMAS.md)
- 📋 [Resumo Executivo](RESUMO_EXECUTIVO.md)

---

**⚡ Sistema configurado em 30 minutos! 🚀**

**Status**: ✅ Pronto para uso
**Próximo**: 🎯 Testar e calibrar sensores 