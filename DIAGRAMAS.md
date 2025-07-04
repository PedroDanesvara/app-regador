# 📊 Diagramas do Sistema - Monitoramento ESP32

## 🔄 Diagrama de Arquitetura Geral

```mermaid
graph TB
    subgraph "Dispositivo IoT"
        ESP32[ESP32]
        SENSOR_UMIDADE[Sensor Umidade Solo]
        SENSOR_TEMP[Sensor Temperatura]
        BOMBA[Bomba de Água]
    end
    
    subgraph "Backend"
        API[API Node.js]
        DB[(SQLite Database)]
        VALIDATION[Validação Joi]
    end
    
    subgraph "Frontend"
        APP[App Mobile React Native]
        CONTEXT[Device Context]
        CACHE[AsyncStorage Cache]
    end
    
    subgraph "Rede"
        WIFI[WiFi Network]
        HTTP[HTTP/HTTPS]
    end
    
    ESP32 --> SENSOR_UMIDADE
    ESP32 --> SENSOR_TEMP
    ESP32 --> BOMBA
    ESP32 --> WIFI
    WIFI --> HTTP
    HTTP --> API
    API --> VALIDATION
    VALIDATION --> DB
    API --> HTTP
    HTTP --> APP
    APP --> CONTEXT
    CONTEXT --> CACHE
    APP --> HTTP
    HTTP --> API
    API --> BOMBA
    
    style ESP32 fill:#ff6b6b
    style API fill:#4ecdc4
    style APP fill:#45b7d1
    style DB fill:#96ceb4
```

## 🔄 Fluxo de Dados Detalhado

```mermaid
sequenceDiagram
    participant ESP as ESP32
    participant API as API Node.js
    participant DB as SQLite DB
    participant APP as App Mobile
    participant USER as Usuário
    
    Note over ESP,USER: Inicialização do Sistema
    ESP->>ESP: Conecta WiFi
    API->>DB: Inicializa banco
    APP->>APP: Carrega dispositivo salvo
    
    Note over ESP,USER: Coleta e Envio de Dados
    loop A cada 5 segundos
        ESP->>ESP: Lê sensores
        ESP->>ESP: Processa dados
        ESP->>API: POST /api/sensors
        API->>API: Valida dados
        API->>DB: Salva dados
        API->>ESP: Confirmação
    end
    
    Note over ESP,USER: Visualização de Dados
    loop A cada 5 segundos
        APP->>API: GET /api/sensors/latest
        API->>DB: Consulta dados
        DB->>API: Retorna dados
        API->>APP: JSON response
        APP->>APP: Atualiza contexto
        APP->>USER: Renderiza interface
    end
    
    Note over ESP,USER: Controle Remoto
    USER->>APP: Ativa/desativa bomba
    APP->>API: POST /api/devices/pump
    API->>API: Processa comando
    API->>APP: Confirmação
    APP->>USER: Atualiza interface
    API->>ESP: Comando bomba (simulado)
```

## 🏗️ Estrutura de Componentes

```mermaid
graph LR
    subgraph "ESP32 Components"
        MAIN[main.ino]
        CONFIG[config.h]
        SENSORS[Sensor Libraries]
    end
    
    subgraph "API Components"
        SERVER[server.js]
        ROUTES[routes/]
        MIDDLEWARE[middleware/]
        DB_MODULE[database/]
    end
    
    subgraph "App Components"
        APP_MAIN[App.js]
        CONTEXT[DeviceContext.js]
        SCREENS[screens/]
        SERVICES[services/]
    end
    
    MAIN --> CONFIG
    MAIN --> SENSORS
    SERVER --> ROUTES
    SERVER --> MIDDLEWARE
    SERVER --> DB_MODULE
    APP_MAIN --> CONTEXT
    APP_MAIN --> SCREENS
    SCREENS --> SERVICES
```

## 📊 Estrutura do Banco de Dados

```mermaid
erDiagram
    DEVICES {
        int id PK
        string device_id UK
        string name
        string location
        string description
        datetime created_at
        datetime updated_at
    }
    
    SENSOR_DATA {
        int id PK
        string device_id FK
        float temperatura
        int umidade_solo
        bigint timestamp
        datetime created_at
    }
    
    DEVICES ||--o{ SENSOR_DATA : "has many"
```

## 🔄 Estados do Sistema

```mermaid
stateDiagram-v2
    [*] --> Inicializacao
    Inicializacao --> ConectandoWiFi
    ConectandoWiFi --> Conectado
    Conectado --> ColetandoDados
    ColetandoDados --> EnviandoDados
    EnviandoDados --> Aguardando
    Aguardando --> ColetandoDados
    
    ConectandoWiFi --> ErroConexao
    ErroConexao --> ConectandoWiFi
    
    EnviandoDados --> ErroEnvio
    ErroEnvio --> Aguardando
    
    state ColetandoDados {
        [*] --> LendoSensores
        LendoSensores --> ProcessandoDados
        ProcessandoDados --> DadosProntos
    }
    
    state EnviandoDados {
        [*] --> CriandoJSON
        CriandoJSON --> EnviandoHTTP
        EnviandoHTTP --> AguardandoResposta
        AguardandoResposta --> DadosEnviados
    }
```

## 📱 Fluxo do Aplicativo Mobile

```mermaid
flowchart TD
    A[App Inicia] --> B{Dispositivo Salvo?}
    B -->|Sim| C[Carrega Dispositivo]
    B -->|Não| D[Tela de Conexão]
    
    C --> E[Tela de Monitoramento]
    D --> F[Inserir Device ID]
    F --> G{Validar ID}
    G -->|Válido| H[Conectar Dispositivo]
    G -->|Inválido| F
    H --> E
    
    E --> I[Atualizar Dados]
    I --> J{Novos Dados?}
    J -->|Sim| K[Atualizar Interface]
    J -->|Não| L[Aguardar]
    K --> L
    L --> I
    
    E --> M[Controle Bomba]
    M --> N[Enviar Comando]
    N --> O[Atualizar Status]
    O --> E
    
    E --> P[Desconectar]
    P --> D
```

## 🔧 Configuração de Rede

```mermaid
graph LR
    subgraph "Rede Local"
        ROUTER[WiFi Router]
        ESP32[ESP32]
        COMPUTER[Computer/Server]
        PHONE[Mobile Phone]
    end
    
    subgraph "Internet"
        WEBHOOK[Webhook Service]
        CLOUD[Cloud Services]
    end
    
    ROUTER --> ESP32
    ROUTER --> COMPUTER
    ROUTER --> PHONE
    ROUTER --> WEBHOOK
    WEBHOOK --> CLOUD
    
    style ROUTER fill:#ffd93d
    style ESP32 fill:#ff6b6b
    style COMPUTER fill:#4ecdc4
    style PHONE fill:#45b7d1
```

## 📈 Monitoramento de Performance

```mermaid
graph TB
    subgraph "Métricas de Sistema"
        LATENCY[Latência < 1s]
        SUCCESS_RATE[Taxa Sucesso > 95%]
        UPTIME[Uptime > 99%]
        DATA_QUALITY[Qualidade Dados]
    end
    
    subgraph "Alertas"
        HIGH_LATENCY[Latência Alta]
        LOW_SUCCESS[Baixa Taxa Sucesso]
        SYSTEM_DOWN[Sistema Offline]
        SENSOR_ERROR[Erro Sensor]
    end
    
    LATENCY --> HIGH_LATENCY
    SUCCESS_RATE --> LOW_SUCCESS
    UPTIME --> SYSTEM_DOWN
    DATA_QUALITY --> SENSOR_ERROR
    
    style LATENCY fill:#96ceb4
    style SUCCESS_RATE fill:#96ceb4
    style UPTIME fill:#96ceb4
    style DATA_QUALITY fill:#96ceb4
    style HIGH_LATENCY fill:#ff6b6b
    style LOW_SUCCESS fill:#ff6b6b
    style SYSTEM_DOWN fill:#ff6b6b
    style SENSOR_ERROR fill:#ff6b6b
```

## 🚀 Deploy e Escalabilidade

```mermaid
graph TB
    subgraph "Desenvolvimento"
        DEV_ESP[ESP32 Dev]
        DEV_API[API Local]
        DEV_APP[App Dev]
    end
    
    subgraph "Teste"
        TEST_ESP[ESP32 Test]
        TEST_API[API Test]
        TEST_APP[App Test]
    end
    
    subgraph "Produção"
        PROD_ESP[ESP32 Prod]
        PROD_API[API Prod]
        PROD_APP[App Prod]
        PROD_DB[Database Prod]
        PROD_CACHE[Redis Cache]
        PROD_LB[Load Balancer]
    end
    
    DEV_ESP --> DEV_API
    DEV_API --> DEV_APP
    
    TEST_ESP --> TEST_API
    TEST_API --> TEST_APP
    
    PROD_ESP --> PROD_LB
    PROD_LB --> PROD_API
    PROD_API --> PROD_DB
    PROD_API --> PROD_CACHE
    PROD_API --> PROD_APP
    
    style DEV_ESP fill:#ffd93d
    style TEST_ESP fill:#ff9800
    style PROD_ESP fill:#4caf50
```

---

**Diagramas criados com Mermaid! 📊** 