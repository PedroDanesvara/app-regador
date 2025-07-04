# Guia para Criar Repositórios Separados

Este guia explica como criar repositórios separados para cada projeto do sistema de monitoramento IoT.

## 📋 Pré-requisitos

- Conta no GitHub/GitLab
- Git instalado localmente
- Acesso aos projetos separados

## 🚀 Passo a Passo

### 1. Criar Repositórios no GitHub

#### Repositório da API
1. Acesse [GitHub](https://github.com)
2. Clique em "New repository"
3. Nome: `sistema-monitoramento-api`
4. Descrição: "API REST para sistema de monitoramento IoT"
5. Público ou Privado (sua escolha)
6. **NÃO** inicialize com README (já temos)
7. Clique em "Create repository"

#### Repositório do ESP32
1. Clique em "New repository"
2. Nome: `sistema-monitoramento-esp32`
3. Descrição: "Firmware ESP32 para coleta de dados de sensores"
4. Público ou Privado
5. **NÃO** inicialize com README
6. Clique em "Create repository"

#### Repositório do App Mobile
1. Clique em "New repository"
2. Nome: `sistema-monitoramento-app`
3. Descrição: "Aplicativo mobile React Native para monitoramento IoT"
4. Público ou Privado
5. **NÃO** inicialize com README
6. Clique em "Create repository"

### 2. Configurar Repositórios Locais

#### API
```bash
# Navegue para o projeto API
cd projeto-api

# Inicialize o git
git init

# Adicione todos os arquivos
git add .

# Faça o primeiro commit
git commit -m "Initial commit: API do sistema de monitoramento IoT"

# Adicione o repositório remoto (substitua pela sua URL)
git remote add origin https://github.com/seu-usuario/sistema-monitoramento-api.git

# Envie para o GitHub
git branch -M main
git push -u origin main
```

#### ESP32
```bash
# Navegue para o projeto ESP32
cd projeto-esp32

# Inicialize o git
git init

# Adicione todos os arquivos
git add .

# Faça o primeiro commit
git commit -m "Initial commit: Firmware ESP32 para monitoramento IoT"

# Adicione o repositório remoto
git remote add origin https://github.com/seu-usuario/sistema-monitoramento-esp32.git

# Envie para o GitHub
git branch -M main
git push -u origin main
```

#### App Mobile
```bash
# Navegue para o projeto App Mobile
cd projeto-app-mobile

# Inicialize o git
git init

# Adicione todos os arquivos
git add .

# Faça o primeiro commit
git commit -m "Initial commit: App mobile para monitoramento IoT"

# Adicione o repositório remoto
git remote add origin https://github.com/seu-usuario/sistema-monitoramento-app.git

# Envie para o GitHub
git branch -M main
git push -u origin main
```

### 3. Atualizar Links no README Principal

Após criar os repositórios, atualize o arquivo `README.md` principal com os links corretos:

```markdown
### 1. **projeto-api/** - Backend API
- **Tecnologia**: Node.js + Express + SQLite
- **Função**: API REST para gerenciar dispositivos, sensores e bombas
- **Repositório**: https://github.com/seu-usuario/sistema-monitoramento-api

### 2. **projeto-esp32/** - Firmware ESP32
- **Tecnologia**: Arduino C++ + Python (simulador)
- **Função**: Coleta dados de sensores e envia para API
- **Repositório**: https://github.com/seu-usuario/sistema-monitoramento-esp32

### 3. **projeto-app-mobile/** - Aplicativo Mobile
- **Tecnologia**: React Native + Expo
- **Função**: Interface móvel para monitoramento e controle
- **Repositório**: https://github.com/seu-usuario/sistema-monitoramento-app
```

### 4. Script Automatizado (Opcional)

Crie um script para automatizar o processo:

```bash
#!/bin/bash
# criar-repositorios.sh

# Configurações
GITHUB_USER="seu-usuario"
API_REPO="sistema-monitoramento-api"
ESP32_REPO="sistema-monitoramento-esp32"
APP_REPO="sistema-monitoramento-app"

# Função para criar repositório
criar_repositorio() {
    local projeto=$1
    local nome_repo=$2
    local descricao=$3
    
    echo "Criando repositório para $projeto..."
    
    cd $projeto
    
    # Inicializar git
    git init
    git add .
    git commit -m "Initial commit: $descricao"
    
    # Adicionar remote e push
    git remote add origin https://github.com/$GITHUB_USER/$nome_repo.git
    git branch -M main
    git push -u origin main
    
    cd ..
    echo "Repositório $nome_repo criado com sucesso!"
}

# Criar repositórios
criar_repositorio "projeto-api" $API_REPO "API do sistema de monitoramento IoT"
criar_repositorio "projeto-esp32" $ESP32_REPO "Firmware ESP32 para monitoramento IoT"
criar_repositorio "projeto-app-mobile" $APP_REPO "App mobile para monitoramento IoT"

echo "Todos os repositórios foram criados com sucesso!"
```

## 🔧 Configurações Adicionais

### Proteger Branches (Recomendado)
1. Vá para Settings > Branches em cada repositório
2. Adicione regra de proteção para a branch `main`
3. Configure review obrigatório para Pull Requests

### Configurar GitHub Pages (Opcional)
Para documentação online:
1. Vá para Settings > Pages
2. Selecione branch `main` e pasta `/docs`
3. Ative GitHub Pages

### Configurar Actions (Opcional)
Para CI/CD automático:
1. Crie pasta `.github/workflows` em cada projeto
2. Adicione arquivos de workflow para testes e deploy

## 📝 Próximos Passos

Após criar os repositórios:

1. **Configure colaboradores** se necessário
2. **Crie issues** para próximas funcionalidades
3. **Configure branch protection** para segurança
4. **Adicione badges** no README (build status, coverage, etc.)
5. **Configure dependabot** para atualizações automáticas

## 🎯 Benefícios da Separação

- **Desenvolvimento independente** de cada componente
- **Deploy separado** para cada projeto
- **Controle de versão** específico
- **Equipes especializadas** podem trabalhar em paralelo
- **Reutilização** de componentes em outros projetos

## 📞 Suporte

Se encontrar problemas:

1. Verifique se o Git está configurado corretamente
2. Confirme as URLs dos repositórios
3. Verifique as permissões de acesso
4. Consulte a documentação do GitHub

---

**Repositórios separados criados com sucesso! 🚀** 