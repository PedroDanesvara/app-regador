# 🌱 Sistema de Monitoramento ESP32 - Versão Flutter

## 📱 Visão Geral

Esta é a versão Flutter do Sistema de Monitoramento ESP32, uma aplicação mobile moderna e responsiva para monitoramento de temperatura e umidade do solo em tempo real.

## ✨ Características

### 🎨 Interface Moderna
- **Material Design 3**: Interface seguindo as diretrizes mais recentes do Material Design
- **Tema Adaptativo**: Suporte a tema claro e escuro
- **Animações Suaves**: Transições e animações fluidas
- **Responsivo**: Adapta-se a diferentes tamanhos de tela

### 📊 Monitoramento em Tempo Real
- **Atualizações Automáticas**: Dados atualizados a cada 5 segundos
- **Visualizações Intuitivas**: Gráficos e indicadores visuais para umidade e temperatura
- **Status em Tempo Real**: Indicadores de status com cores dinâmicas
- **Histórico de Dados**: Estatísticas e histórico de leituras

### 🔧 Controle Remoto
- **Controle da Bomba**: Ativar/desativar sistema de irrigação
- **Status da Sessão**: Tempo de funcionamento atual
- **Histórico de Ativações**: Estatísticas de uso da bomba
- **Confirmações de Segurança**: Diálogos de confirmação para ações críticas

### 🔄 Gerenciamento de Estado
- **Provider Pattern**: Gerenciamento de estado eficiente
- **Cache Local**: Armazenamento de preferências do usuário
- **Reconexão Automática**: Reconecta automaticamente ao dispositivo salvo
- **Tratamento de Erros**: Feedback visual para erros de conexão

## 🏗️ Arquitetura

### Estrutura de Pastas
```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── device.dart          # Modelo de dispositivo
│   └── sensor_data.dart     # Modelo de dados dos sensores
├── providers/               # Gerenciamento de estado
│   └── device_provider.dart # Provider principal
├── screens/                 # Telas da aplicação
│   ├── splash_screen.dart   # Tela de inicialização
│   ├── device_connection_screen.dart # Tela de conexão
│   └── monitoring_screen.dart # Tela principal
├── services/                # Serviços
│   └── api_service.dart     # Serviço de API
├── utils/                   # Utilitários
│   └── app_theme.dart       # Configuração de tema
└── widgets/                 # Widgets personalizados
    ├── humidity_card.dart   # Card de umidade
    ├── temperature_card.dart # Card de temperatura
    ├── pump_control_card.dart # Card de controle da bomba
    └── stats_card.dart      # Card de estatísticas
```

### Padrões Utilizados
- **Provider Pattern**: Para gerenciamento de estado
- **Repository Pattern**: Para acesso a dados
- **Service Layer**: Para comunicação com API
- **Widget Composition**: Para reutilização de componentes

## 🚀 Instalação e Configuração

### Pré-requisitos
- Flutter SDK 3.0.0 ou superior
- Dart SDK 3.0.0 ou superior
- Android Studio / VS Code
- Dispositivo Android/iOS ou emulador

### Passos de Instalação

1. **Clonar o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd projeto_alex_flutter
   ```

2. **Instalar dependências**
   ```bash
   flutter pub get
   ```

3. **Configurar API**
   - Editar `lib/services/api_service.dart`
   - Alterar `baseUrl` para o endereço da sua API
   ```dart
   static const String baseUrl = 'http://192.168.1.100:3000/api';
   ```

4. **Executar a aplicação**
   ```bash
   flutter run
   ```

### Configuração para Dispositivo Físico

Para testar em dispositivo físico, certifique-se de:

1. **API acessível**: A API deve estar rodando e acessível pela rede
2. **IP correto**: Use o IP da máquina onde a API está rodando
3. **Firewall**: Configure o firewall para permitir conexões na porta 3000
4. **Rede WiFi**: Dispositivo e API devem estar na mesma rede

## 📱 Funcionalidades

### 1. Tela de Inicialização (Splash Screen)
- **Animação de entrada**: Fade in e scale animation
- **Carregamento automático**: Reconecta ao último dispositivo
- **Navegação inteligente**: Direciona para tela apropriada

### 2. Tela de Conexão (Device Connection)
- **Campo de ID**: Entrada do ID do dispositivo
- **Validação**: Verificação de campos obrigatórios
- **Teste de conexão**: Verifica conectividade com API
- **Dicas de ajuda**: Informações para solução de problemas

### 3. Tela de Monitoramento (Monitoring Screen)
- **App Bar dinâmica**: Informações do dispositivo conectado
- **Cards informativos**: Umidade, temperatura, controle da bomba
- **Atualizações em tempo real**: Dados atualizados automaticamente
- **Controles de ação**: Botões para desconectar e atualizar

### 4. Cards Especializados

#### Card de Umidade
- **Indicador visual**: Barra de progresso colorida
- **Status dinâmico**: Cores baseadas no valor da umidade
- **Escala de valores**: Referência visual (0%, 50%, 100%)
- **Timestamp**: Hora da última atualização

#### Card de Temperatura
- **Termômetro visual**: Representação gráfica da temperatura
- **Escala de temperatura**: Valores de 0°C a 40°C
- **Status colorido**: Cores baseadas na faixa de temperatura
- **Ícones dinâmicos**: Mudam conforme a temperatura

#### Card de Controle da Bomba
- **Status visual**: Ícone e cor indicam estado atual
- **Botão de controle**: Ativar/desativar com confirmação
- **Sessão atual**: Tempo de funcionamento em andamento
- **Estatísticas**: Total de ativações e histórico

#### Card de Estatísticas
- **Médias**: Valores médios de umidade e temperatura
- **Extremos**: Valores mínimos e máximos
- **Período**: Tempo total de monitoramento
- **Leituras**: Número total de leituras realizadas

## 🎨 Temas e Personalização

### Cores Principais
- **Primary**: Verde (#4CAF50) - Cor principal da aplicação
- **Primary Dark**: Verde escuro (#388E3C) - Para elementos destacados
- **Accent**: Verde claro (#8BC34A) - Para elementos secundários

### Cores de Status
- **Umidade Baixa**: Vermelho (#F44336) - < 30%
- **Umidade Média**: Laranja (#FF9800) - 30-50%
- **Umidade Ideal**: Verde (#4CAF50) - 50-70%
- **Umidade Alta**: Azul (#2196F3) - > 70%

- **Temperatura Fria**: Azul (#2196F3) - < 15°C
- **Temperatura Ideal**: Verde (#4CAF50) - 15-25°C
- **Temperatura Quente**: Laranja (#FF9800) - 25-35°C
- **Temperatura Muito Quente**: Vermelho (#F44336) - > 35°C

## 🔧 Configuração Avançada

### Personalização de Tema
Edite `lib/utils/app_theme.dart` para personalizar:
- Cores da aplicação
- Estilos de texto
- Configurações de cards
- Tema escuro/claro

### Configuração de API
Edite `lib/services/api_service.dart` para:
- Alterar URL da API
- Configurar timeouts
- Adicionar headers customizados
- Implementar autenticação

### Armazenamento Local
O aplicativo usa `SharedPreferences` para:
- Salvar ID do dispositivo conectado
- Cache de configurações
- Preferências do usuário

## 🐛 Solução de Problemas

### Problemas Comuns

1. **Erro de conexão com API**
   - Verifique se a API está rodando
   - Confirme o IP e porta corretos
   - Teste conectividade de rede

2. **Dispositivo não encontrado**
   - Verifique se o ID está correto
   - Confirme se o ESP32 está conectado
   - Teste a API diretamente

3. **Dados não atualizam**
   - Verifique conectividade de rede
   - Confirme se o ESP32 está enviando dados
   - Teste o endpoint da API

4. **Erro de build**
   - Execute `flutter clean`
   - Execute `flutter pub get`
   - Verifique versão do Flutter

### Logs e Debug
- Use `flutter logs` para ver logs em tempo real
- Adicione `print()` statements para debug
- Use o DevTools do Flutter para análise

## 📦 Dependências Principais

- **provider**: Gerenciamento de estado
- **dio**: Cliente HTTP para API
- **shared_preferences**: Armazenamento local
- **intl**: Formatação de datas e números
- **flutter_svg**: Suporte a SVG
- **lottie**: Animações avançadas

## 🔄 Compatibilidade

- **Flutter**: 3.0.0+
- **Dart**: 3.0.0+
- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Suporte experimental

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📞 Suporte

Para suporte e dúvidas:
- Abra uma issue no GitHub
- Consulte a documentação da API
- Verifique os logs de erro

---

**Desenvolvido com ❤️ usando Flutter** 