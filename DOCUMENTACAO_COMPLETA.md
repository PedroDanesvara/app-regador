# 📚 Documentação Completa - Sistema de Monitoramento ESP32

## 📋 Visão Geral do Projeto

O Sistema de Monitoramento ESP32 é uma solução completa de IoT para monitoramento de temperatura e umidade do solo, composta por três componentes principais:

1. **ESP32** - Dispositivo de sensoriamento
2. **API Node.js** - Backend para processamento e armazenamento
3. **Aplicativo Mobile** - Interface de usuário para monitoramento

### 🎯 Objetivo
Monitorar em tempo real a temperatura do ambiente e umidade do solo, permitindo controle remoto de sistemas de irrigação através de um aplicativo mobile.

### 🔄 Fluxo de Dados
```
ESP32 → API → Banco de Dados → Aplicativo Mobile
  ↑                                    ↓
  └────────── Controle da Bomba ←──────┘
```

## 🏗️ Arquitetura do Sistema

### Componentes Principais

#### 1. ESP32 (Dispositivo IoT)
- **Função**: Coleta dados dos sensores
- **Sensores**: 
  - Sensor de umidade do solo capacitivo v2.0
  - Sensor de temperatura DS18B20
- **Comunicação**: WiFi HTTP/HTTPS
- **Intervalo**: Envio de dados a cada 5 segundos

#### 2. API Node.js (Backend)
- **Função**: Processamento e armazenamento de dados
- **Tecnologias**: Express.js, SQLite3, Joi
- **Endpoints**: RESTful API
- **Banco de Dados**: SQLite com tabelas relacionais

#### 3. Aplicativo Mobile (Frontend)
- **Função**: Interface de usuário
- **Tecnologias**: React Native, Expo
- **Atualização**: Dados em tempo real a cada 5 segundos
- **Funcionalidades**: Monitoramento e controle remoto

## 📊 Diagrama de Arquitetura

```
┌─────────────────┐    WiFi    ┌─────────────────┐    HTTP/HTTPS    ┌─────────────────┐
│                 │ ────────── │                 │ ──────────────── │                 │
│   ESP32         │            │   API Node.js   │                  │   App Mobile    │
│                 │            │                 │                  │                 │
│ ┌─────────────┐ │            │ ┌─────────────┐ │                  │ ┌─────────────┐ │
│ │ Sensor      │ │            │ │ Express.js  │ │                  │ │ React       │ │
│ │ Umidade     │ │            │ │ Server      │ │                  │ │ Native      │ │
│ └─────────────┘ │            │ └─────────────┘ │                  │ └─────────────┘ │
│                 │            │                 │                  │                 │
│ ┌─────────────┐ │            │ ┌─────────────┐ │                  │ ┌─────────────┐ │
│ │ Sensor      │ │            │ │ SQLite3     │ │                  │ │ Expo        │ │
│ │ Temperatura │ │            │ │ Database    │ │                  │ │ Framework   │ │
│ └─────────────┘ │            │ └─────────────┘ │                  │ └─────────────┘ │
│                 │            │                 │                  │                 │
│ ┌─────────────┐ │            │ ┌─────────────┐ │                  │ ┌─────────────┐ │
│ │ WiFi        │ │            │ │ Joi         │ │                  │ │ AsyncStorage│ │
│ │ Module      │ │            │ │ Validation  │ │                  │ │ Local Cache │ │
│ └─────────────┘ │            │ └─────────────┘ │                  │ └─────────────┘ │
└─────────────────┘            └─────────────────┘                  └─────────────────┘
```

## 🔄 Fluxo de Dados Detalhado

### 1. Coleta de Dados (ESP32)
```
Sensores → ESP32 → Processamento → JSON → API
```

**Processo**:
1. ESP32 lê dados dos sensores
2. Processa e converte para valores utilizáveis
3. Cria payload JSON
4. Envia via HTTP POST para API

### 2. Processamento (API)
```
API → Validação → Banco de Dados → Resposta
```

**Processo**:
1. Recebe dados do ESP32
2. Valida formato e valores
3. Armazena no banco SQLite
4. Retorna confirmação

### 3. Visualização (App Mobile)
```
API → App → Context → UI → Usuário
```

**Processo**:
1. App consulta API a cada 5 segundos
2. Atualiza contexto global
3. Renderiza interface
4. Exibe dados ao usuário

### 4. Controle Remoto
```
App → API → ESP32 → Bomba
```

**Processo**:
1. Usuário ativa/desativa bomba no app
2. App envia comando para API
3. API processa e retorna confirmação
4. ESP32 executa ação (simulado no projeto atual)

## ⚙️ Configuração Passo a Passo

### Etapa 1: Configuração do ESP32

#### 1.1 Hardware Necessário
- ESP32 (qualquer modelo)
- Sensor de umidade do solo capacitivo v2.0
- Sensor de temperatura DS18B20 (opcional)
- Protoboard e jumpers
- Cabo USB

#### 1.2 Conexões Físicas

**Sensor de Umidade do Solo**:
```
ESP32          Sensor v2.0
3.3V    →      VCC
GND     →      GND
GPIO 36 →      AOUT
```

**Sensor de Temperatura**:
```
ESP32          DS18B20
3.3V    →      VCC
GND     →      GND
GPIO 4  →      DATA
4.7kΩ   →      Resistor pull-up (DATA ↔ VCC)
```

#### 1.3 Configuração do Software

1. **Instalar Arduino IDE**:
   - Download: https://www.arduino.cc/en/software
   - Instalar ESP32 Board Package

2. **Instalar Bibliotecas**:
   ```
   Sketch → Include Library → Manage Libraries
   - ArduinoJson (versão 6.x)
   - OneWire
   - DallasTemperature
   ```

3. **Configurar Código**:
   - Abrir `esp32/main.ino`
   - Configurar WiFi em `esp32/config.h`:
     ```cpp
     #define WIFI_SSID "SUA_REDE_WIFI"
     #define WIFI_PASSWORD "SUA_SENHA_WIFI"
     #define API_URL "http://localhost:3000/api/sensors"
     ```

4. **Upload do Código**:
   - Conectar ESP32 via USB
   - Selecionar placa e porta
   - Clicar em Upload

### Etapa 2: Configuração da API

#### 2.1 Pré-requisitos
- Node.js 16+
- npm ou yarn

#### 2.2 Instalação e Configuração

1. **Instalar Dependências**:
   ```bash
   cd api
   npm install
   ```

2. **Configurar Variáveis de Ambiente**:
   ```bash
   cp env.example .env
   # Editar .env conforme necessário
   ```

3. **Inicializar Banco de Dados**:
   ```bash
   npm run init-db
   ```

4. **Iniciar Servidor**:
   ```bash
   # Desenvolvimento
   npm run dev
   
   # Produção
   npm start
   ```

#### 2.3 Verificação da API

1. **Health Check**:
   ```bash
   curl http://localhost:3000/health
   ```

2. **Teste de Endpoint**:
   ```bash
   curl http://localhost:3000/api/devices
   ```

### Etapa 3: Configuração do Aplicativo Mobile

#### 3.1 Pré-requisitos
- Node.js 16+
- Expo CLI
- Dispositivo móvel ou emulador

#### 3.2 Instalação e Configuração

1. **Instalar Dependências**:
   ```bash
   cd app
   npm install
   ```

2. **Configurar API**:
   Editar `app/src/services/apiService.js`:
   ```javascript
   // Para desenvolvimento local
   const API_BASE_URL = 'http://localhost:3000/api';
   
   // Para dispositivo físico
   // const API_BASE_URL = 'http://192.168.1.100:3000/api';
   ```

3. **Iniciar Aplicativo**:
   ```bash
   npm start
   ```

4. **Executar no Dispositivo**:
   - Instalar Expo Go no dispositivo
   - Escanear QR Code
   - Ou usar emulador

## 🔄 Fluxo de Dados Completo

### Diagrama de Sequência

```
┌─────┐    ┌─────┐    ┌─────┐    ┌─────┐    ┌─────┐
│ESP32│    │ API │    │ DB  │    │ App │    │User │
└──┬──┘    └──┬──┘    └──┬──┘    └──┬──┘    └──┬──┘
   │          │          │          │          │
   │───Dados──│          │          │          │
   │─────────>│          │          │          │
   │          │───Save───│          │          │
   │          │─────────>│          │          │
   │          │───OK────│          │          │
   │<─────────│          │          │          │
   │          │          │          │          │
   │          │          │          │───GET────│
   │          │          │          │─────────>│
   │          │───Query──│          │          │
   │          │─────────>│          │          │
   │          │───Data───│          │          │
   │          │<─────────│          │          │
   │          │───JSON───│          │          │
   │          │─────────>│          │          │
   │          │          │<─────────│          │
   │          │          │          │───Show───│
   │          │          │          │─────────>│
   │          │          │          │          │
   │          │          │          │───Pump───│
   │          │          │          │─────────>│
   │          │───Cmd────│          │          │
   │          │<─────────│          │          │
   │───Exec───│          │          │          │
   │<─────────│          │          │          │
```

### Fluxo de Dados Detalhado

#### 1. Inicialização do Sistema
```
1. ESP32 conecta ao WiFi
2. API inicializa banco de dados
3. App carrega dispositivo salvo (se houver)
4. Sistema está pronto para operação
```

#### 2. Coleta e Envio de Dados
```
1. ESP32 lê sensores a cada 5 segundos
2. Processa dados (calibração, conversão)
3. Cria JSON payload
4. Envia POST para /api/sensors
5. API valida dados
6. Salva no banco SQLite
7. Retorna confirmação
```

#### 3. Visualização de Dados
```
1. App consulta API a cada 5 segundos
2. Busca dados mais recentes
3. Atualiza contexto global
4. Renderiza interface
5. Exibe dados ao usuário
```

#### 4. Controle Remoto
```
1. Usuário ativa/desativa bomba
2. App envia comando para API
3. API processa comando
4. Retorna confirmação
5. App atualiza interface
6. ESP32 executa ação (simulado)
```

## 📊 Estrutura de Dados

### Banco de Dados (SQLite)

#### Tabela: devices
```sql
CREATE TABLE devices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  device_id TEXT UNIQUE NOT NULL,
  name TEXT,
  location TEXT,
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### Tabela: sensor_data
```sql
CREATE TABLE sensor_data (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  device_id TEXT NOT NULL,
  temperatura REAL,
  umidade_solo INTEGER,
  timestamp BIGINT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (device_id) REFERENCES devices (device_id)
);
```

### Formatos de Dados

#### Payload do ESP32
```json
{
  "temperatura": 25.5,
  "umidade_solo": 65,
  "timestamp": 1234567890,
  "device_id": "ESP32_001"
}
```

#### Resposta da API
```json
{
  "success": true,
  "message": "Dados recebidos com sucesso",
  "data": {
    "id": 1,
    "device_id": "ESP32_001",
    "temperatura": 25.5,
    "umidade_solo": 65,
    "timestamp": 1234567890,
    "created_at": "2024-01-01T12:00:00.000Z"
  }
}
```

## 🔧 Configurações Avançadas

### Personalização do ESP32

#### Calibração do Sensor de Umidade
```cpp
// Valores de calibração (ajustar conforme seu sensor)
const int VALOR_SECO = 4095;    // Solo seco
const int VALOR_MOLHADO = 1800; // Solo molhado
```

#### Intervalo de Envio
```cpp
const unsigned long intervaloMedicao = 5000; // 5 segundos
```

### Personalização da API

#### Configuração de Segurança
```javascript
// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100 // máximo 100 requisições por IP
});
```

#### Configuração de CORS
```javascript
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  methods: ['GET', 'POST', 'PATCH', 'DELETE']
}));
```

### Personalização do App

#### Intervalo de Atualização
```javascript
// Em DeviceContext.js
interval = setInterval(updateDeviceData, 5000); // 5 segundos
```

#### Configuração de Cores
```javascript
const getHumidityColor = (humidity) => {
  if (humidity < 30) return '#F44336'; // Vermelho
  if (humidity < 50) return '#FF9800'; // Laranja
  if (humidity < 70) return '#4CAF50'; // Verde
  return '#2196F3'; // Azul
};
```

## 🚨 Solução de Problemas

### Problemas Comuns

#### ESP32 não conecta ao WiFi
- Verificar nome da rede e senha
- Confirmar se a rede é 2.4GHz
- Verificar distância do roteador

#### API não recebe dados
- Verificar se a API está rodando
- Confirmar URL no ESP32
- Verificar logs da API

#### App não atualiza dados
- Verificar conexão com internet
- Confirmar URL da API no app
- Verificar logs do console

#### Dados inconsistentes
- Calibrar sensor de umidade
- Verificar conexões físicas
- Confirmar valores de referência

### Logs e Debug

#### ESP32
```cpp
Serial.println("Debug: " + String(valor));
```

#### API
```javascript
console.log('API Request:', req.method, req.path);
```

#### App
```javascript
console.log('App Debug:', data);
```

## 📈 Monitoramento e Manutenção

### Métricas Importantes
- **Latência**: Tempo entre coleta e visualização
- **Taxa de Sucesso**: % de dados recebidos com sucesso
- **Uptime**: Tempo de funcionamento do sistema
- **Qualidade dos Dados**: Precisão das medições

### Manutenção Preventiva
- **Calibração Mensal**: Dos sensores
- **Backup Semanal**: Do banco de dados
- **Atualização Trimestral**: Das dependências
- **Limpeza Mensal**: Dos logs

## 🎯 Próximos Passos

### Melhorias Planejadas
1. **Notificações Push**: Alertas em tempo real
2. **Gráficos**: Visualização histórica
3. **Múltiplos Dispositivos**: Dashboard centralizado
4. **Autenticação**: Sistema de usuários
5. **Modo Offline**: Cache local avançado

### Escalabilidade
- **Banco PostgreSQL**: Para grandes volumes
- **Redis**: Cache de alta performance
- **Load Balancer**: Para múltiplas instâncias
- **Microserviços**: Arquitetura distribuída

---

**Sistema completo e documentado! 🚀** 