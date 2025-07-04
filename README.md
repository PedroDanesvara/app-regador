# App Flutter - Sistema de Monitoramento IoT

## Descrição
Aplicativo móvel Flutter para monitoramento de dispositivos IoT, sensores e controle de bombas de água em tempo real.

## Funcionalidades
- Monitoramento em tempo real de temperatura e umidade
- Controle remoto de bombas de água
- Visualização de dados históricos
- Conexão com dispositivos IoT
- Interface intuitiva e responsiva
- Notificações de alerta
- Suporte para Android, iOS e Web

## Tecnologias
- Flutter 3.x
- Dart
- Provider (gerenciamento de estado)
- HTTP (requisições à API)
- Material Design 3
- Responsive Design

## Pré-requisitos
- Flutter SDK (versão 3.0 ou superior)
- Dart SDK
- Android Studio (para Android)
- Xcode (para iOS, apenas macOS)
- VS Code (recomendado)

## Instalação

1. Clone o repositório
2. Navegue até o diretório do projeto:
```bash
cd projeto-flutter
```

3. Instale as dependências:
```bash
flutter pub get
```

4. Execute o aplicativo:
```bash
flutter run
```

## Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── device.dart          # Modelo de dispositivo
│   └── sensor_data.dart     # Modelo de dados de sensor
├── providers/               # Gerenciamento de estado
│   └── device_provider.dart # Provider para dispositivos
├── screens/                 # Telas da aplicação
│   ├── splash_screen.dart   # Tela de splash
│   ├── device_connection_screen.dart # Tela de conexão
│   └── monitoring_screen.dart # Tela de monitoramento
├── services/               # Serviços
│   └── api_service.dart    # Serviço de API
├── utils/                  # Utilitários
│   └── app_theme.dart      # Tema da aplicação
└── widgets/                # Widgets reutilizáveis
    ├── temperature_card.dart
    ├── humidity_card.dart
    ├── pump_control_card.dart
    └── stats_card.dart
```

## Configuração da API

O aplicativo se conecta à API através do arquivo `lib/services/api_service.dart`. Certifique-se de que:

1. A API esteja rodando
2. O endereço da API esteja configurado corretamente
3. As rotas da API estejam funcionando

## Build e Deploy

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Funcionalidades Principais

### 1. Monitoramento em Tempo Real
- Exibição de temperatura e umidade atual
- Atualização automática dos dados
- Gráficos de tendência

### 2. Controle de Bombas
- Ativar/desativar bombas de água
- Configuração de horários
- Status em tempo real

### 3. Gerenciamento de Dispositivos
- Lista de dispositivos conectados
- Status de conexão
- Configurações individuais

### 4. Interface Responsiva
- Design adaptativo para diferentes tamanhos de tela
- Suporte para orientação paisagem/retrato
- Tema claro/escuro

## Desenvolvimento

### Comandos Úteis

```bash
# Verificar dependências
flutter doctor

# Executar testes
flutter test

# Análise de código
flutter analyze

# Formatação de código
dart format lib/

# Limpar cache
flutter clean
flutter pub get
```

### Estrutura de Estado

O aplicativo usa o Provider para gerenciamento de estado:

- `DeviceProvider`: Gerencia o estado dos dispositivos
- `ApiService`: Responsável pelas requisições HTTP
- `AppTheme`: Configurações de tema

## Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## Licença

Este projeto está sob a licença MIT.

## Suporte

Para suporte, entre em contato através dos canais oficiais do projeto.
