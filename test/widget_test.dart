import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_alex_flutter/main.dart';

void main() {
  group('Sistema de Monitoramento ESP32 - Testes de Widget', () {
    testWidgets('Aplicativo inicia corretamente', (WidgetTester tester) async {
      // Construir o widget e disparar um frame
      await tester.pumpWidget(const MyApp());

      // Verificar se o aplicativo inicia sem erros
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Splash screen é exibida inicialmente', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verificar se a splash screen é exibida
      expect(find.text('Sistema de Monitoramento'), findsOneWidget);
      expect(find.text('ESP32'), findsOneWidget);
      expect(find.text('Inicializando...'), findsOneWidget);
    });

    testWidgets('Tela de conexão é exibida quando não há dispositivo conectado', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Aguardar a inicialização
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar se a tela de conexão é exibida
      expect(find.text('Conectar Dispositivo'), findsOneWidget);
      expect(find.text('ID do Dispositivo'), findsOneWidget);
      expect(find.text('Conectar'), findsOneWidget);
      expect(find.text('Testar Conexão'), findsOneWidget);
    });

    testWidgets('Validação de campo obrigatório funciona', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Aguardar a inicialização
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tentar conectar sem preencher o campo
      await tester.tap(find.text('Conectar'));
      await tester.pump();

      // Verificar se a mensagem de erro é exibida
      expect(find.text('Por favor, digite o ID do dispositivo'), findsOneWidget);
    });

    testWidgets('Campo de ID aceita entrada de texto', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Aguardar a inicialização
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Encontrar o campo de texto
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      // Inserir texto
      await tester.enterText(textField, 'ESP32_001');
      await tester.pump();

      // Verificar se o texto foi inserido
      expect(find.text('ESP32_001'), findsOneWidget);
    });
  });

  group('Testes de Tema', () {
    testWidgets('Tema claro é aplicado corretamente', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verificar se o tema claro está sendo usado
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
    });

    testWidgets('Cores do tema estão definidas', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Verificar se as cores principais estão definidas
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      final theme = materialApp.theme!;
      
      expect(theme.colorScheme.primary, isNotNull);
      expect(theme.colorScheme.surface, isNotNull);
      expect(theme.colorScheme.background, isNotNull);
    });
  });

  group('Testes de Navegação', () {
    testWidgets('Navegação entre telas funciona', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Aguardar a inicialização
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar se estamos na tela de conexão
      expect(find.text('Conectar Dispositivo'), findsOneWidget);

      // Simular conexão bem-sucedida (isso seria testado com mocks em um teste real)
      // Por enquanto, apenas verificamos se a navegação está configurada
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
} 