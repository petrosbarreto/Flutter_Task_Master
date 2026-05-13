# TaskMaster

Projeto Flutter desenvolvido de forma evolutiva por aulas, com branches cumulativas.

## 🎯 Objetivo do Fluxo

A ideia é simples:

- Cada aula gera uma **branch própria**
- Essa branch sempre **nasce da aula anterior** já funcional
- Ao fazer merge da branch atual, o projeto deve **continuar buildando e funcionando**

## 📋 Configuração Inicial

### 1. Instalar Dependências

```bash
cd Flutter_Task_Master
flutter pub get
```

### 2. Configurar Supabase

**Arquivo**: `lib/config/supabase_config.dart`

Atualize com suas credenciais:
```dart
static const String supabaseUrl = 'https://seu-projeto.supabase.co';
static const String supabaseAnonKey = 'sua-chave-publica';
```

Obtenha essas informações em: [https://supabase.io](https://supabase.io)

### 3. Estrutura de Branches

Convenção adotada:

```
aula/01-setup-inicial        # Base técnica + Supabase config
aula/02-layouts-estaticos    # Primeiras telas com Figma MCP
aula/03-navigacao            # Navigation + Flutter Router
aula/04-models-providers     # Modelos de dados + Provider
aula/05-banco-dados          # Integração com Supabase Database
aula/06-autenticacao         # Auth + JWT
aula/07-realtime             # Sincronização em tempo real
aula/08-storage              # Upload de arquivos
...
```

### 4. Regra das Branches

- ✅ Cada branch nasce de `aula/XX-anterior`
- ✅ Sempre pullable e buildable
- ✅ Commits organizados por tópico
- ✅ Merge local com sucesso antes de push

## 🚀 Como Usar as Branches

### Criar Nova Branch (para a próxima aula)

```bash
# 1. Garantir que a branch anterior está atualizada
git checkout aula/01-setup-inicial
git pull origin aula/01-setup-inicial

# 2. Criar nova branch a partir dela
git checkout -b aula/02-layouts-estaticos

# 3. Fazer as alterações e commits
# ... editar arquivos ...
git add .
git commit -m "chore: layouts iniciais com Figma MCP"

# 4. Push para criar a branch remota
git push -u origin aula/02-layouts-estaticos
```

### Verificar Status

```bash
# Ver branches locais e remotas
git branch -a

# Ver histórico de commits
git log --oneline --graph --all
```

## 📱 Tecnologias

- **Flutter 3.x** - Framework UI
- **Supabase** - Backend + Database (Postgres)
- **Provider** - State Management
- **Figma MCP** - Design-to-Code

## 📚 Estrutura de Pastas

```
lib/
├── config/                 # Configurações (Supabase, etc)
├── core/
│   ├── services/          # Serviços (Supabase, HTTP, etc)
│   ├── constants/         # Constantes da app
│   └── utils/             # Utilitários
├── features/
│   ├── tasks/             # Feature de Tarefas
│   │   ├── models/
│   │   ├── providers/
│   │   └── screens/
│   └── auth/              # Feature de Autenticação
│       ├── models/
│       ├── providers/
│       └── screens/
└── main.dart

docs/                       # Documentação
├── BRANCHES_WORKFLOW.md   # Este arquivo
├── FIGMA_MCP_GUIDE.md    # Guia do Figma MCP
└── SUPABASE_SETUP.md     # Setup detalhado do Supabase
```

## 🔄 Workflow Recomendado

1. **Estude o material da aula** (`docs/figma-mcp-guide.md` para layout)
2. **Crie a branch** a partir da anterior
3. **Implemente incrementalmente** com commits pequenos
4. **Teste no emulador/dispositivo** com `flutter run`
5. **Commit local** com mensagens descritivas
6. **Push para origin**
7. **Prepare material para próxima aula**

## 💡 Dicas

- Use `flutter analyze` para verificar código
- Use `flutter format .` para padronizar
- Teste em Android e iOS se possível
- Mantenha commits lógicos e pequenos
- Branch deve ser o estado final da aula, pronto para a próxima

## 📖 Documentação Adicional

- [Guia Figma MCP](./docs/FIGMA_MCP_GUIDE.md) - Como usar o MCP do Figma
- [Setup Supabase](./docs/SUPABASE_SETUP.md) - Configurar banco de dados
- [Flutter Docs](https://flutter.dev/docs)
- [Supabase Docs](https://supabase.io/docs)

---

**Projeto**: TaskMaster  
**Disciplina**: Desenvolvimento Mobile  
**Instituição**: UNIT  
**Data**: Maio 2026
