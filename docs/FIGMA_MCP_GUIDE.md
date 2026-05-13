# Guia: Figma MCP para Design-to-Code no TaskMaster

## 🎨 O que é Figma MCP?

Figma MCP (Model Context Protocol) é uma integração que permite:
- 🖼️ Capturar designs do Figma diretamente
- 📱 Gerar código Flutter a partir dos layouts
- 🔗 Mapear componentes Figma para código Flutter
- ⚡ Acelerar desenvolvimento UI

## 🚀 Como Usar (Passo a Passo)

### 1️⃣ Preparar no VS Code

Você já tem o MCP do Figma integrado (via extension). Verifique:

```
Extensions → Figma → instalar se não estiver
```

### 2️⃣ Acessar o Figma

1. Crie uma conta em [figma.com](https://figma.com)
2. Crie um arquivo novo chamado "TaskMaster Layouts"
3. Comece desenhando a primeira tela

### 3️⃣ Desenhar a Tela no Figma

**Exemplo: Tela de Listagem de Tarefas**

```
┌─────────────────────────────┐
│  TaskMaster         ⋮       │  ← AppBar
├─────────────────────────────┤
│  📌 Fazer compras           │  ← Task Item (Card)
│     Prioridade: Alta        │
├─────────────────────────────┤
│  ☑  Estudar Flutter        │
│     Prioridade: Média       │
├─────────────────────────────┤
│  ☑  Exercício              │
│     Prioridade: Baixa       │
├─────────────────────────────┤
│              [+ Tarefa]     │  ← FAB
└─────────────────────────────┘
```

### 4️⃣ Exportar do Figma para Flutter

#### Opção A: Usar MCP Direto no VS Code

1. Copie o link do arquivo Figma
2. No VS Code: `Ctrl+Shift+P` → "Figma"
3. Cole a URL do Figma
4. Selecione o frame/component
5. Escolha "Copy as Flutter"

#### Opção B: Usar Figma Design Plugin

1. No Figma: Plugins → "Code Connect" (ou similar)
2. Gere o código Flutter automaticamente
3. Copie para seu projeto

### 5️⃣ Adaptar o Código Gerado

O MCP gera código de **referência** em React+Tailwind. Você precisa adaptar para Flutter:

**Antes (gerado pelo MCP):**
```jsx
<div className="bg-blue-500 p-4 rounded">
  <h1 className="text-2xl font-bold">TaskMaster</h1>
</div>
```

**Depois (Flutter adaptado):**
```dart
Container(
  color: Colors.blue,
  padding: EdgeInsets.all(16),
  child: Text(
    'TaskMaster',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

## 📐 Estrutura de um Screen com Figma

Ao usar Figma MCP, organize assim:

```dart
// lib/features/tasks/screens/tasks_screen.dart

import 'package:flutter/material.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TaskMaster'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Componentes vêm do Figma Design
          TaskItem(
            title: 'Fazer compras',
            priority: 'Alta',
          ),
          TaskItem(
            title: 'Estudar Flutter',
            priority: 'Média',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTask(BuildContext context) {
    // Implementar depois
  }
}

// Componente reutilizável (extraído do Figma)
class TaskItem extends StatelessWidget {
  final String title;
  final String priority;

  const TaskItem({
    Key? key,
    required this.title,
    required this.priority,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Prioridade: $priority',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎯 Melhores Práticas

### ✅ Faça

- Extraia componentes reutilizáveis do Figma
- Organize layers no Figma com nomes lógicos
- Use estilos no Figma (cores, tipografia)
- Documente as cores e dimensões
- Mantenha componentes simples e focados

### ❌ Evite

- Designs muito complexos em um único component
- Nomes de layer confusos ("grupo 3", "retângulo 5")
- Copiar código 1:1 sem adaptação para Flutter
- Esquecer de testar a responsividade
- Misturar lógica de negócio com UI

## 🔗 Mapear Componentes Figma → Flutter

Você pode criar um mapeamento para reutilização:

| Figma Component | Flutter Widget | Arquivo |
|---|---|---|
| `TaskItem` | `TaskItem` | `widgets/task_item.dart` |
| `PriorityBadge` | `PriorityBadge` | `widgets/priority_badge.dart` |
| `Button/Primary` | `PrimaryButton` | `widgets/buttons.dart` |

**Arquivo de mapeamento** (`lib/core/constants/design_tokens.dart`):

```dart
// Cores do Figma
class DesignColors {
  static const primary = Color(0xFF2196F3);
  static const secondary = Color(0xFFFF9800);
  static const error = Color(0xFFE53935);
}

// Tipografia do Figma
class DesignTypography {
  static const heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
}
```

## 📱 Exemplo: Criando TasksScreen com Figma MCP

### Passo 1: Desenhar no Figma

Crie um frame chamado "TasksScreen" com:
- AppBar (topo)
- ListView de TaskItems
- FloatingActionButton

### Passo 2: Exportar via MCP

```
1. Selecionar o frame
2. Ctrl+Shift+P → "Figma: Export Flutter"
3. Copiar o código gerado
```

### Passo 3: Adaptar para Flutter

```dart
// Código gerado (referência)
// → Adapte para usar Provider, models, etc

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('TaskMaster'),
          ),
          body: ListView(
            children: taskProvider.tasks
                .map((task) => TaskItem(task: task))
                .toList(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTaskDialog(context),
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
```

### Passo 4: Testar

```bash
flutter run
# Verificar se o layout aparece corretamente
# Fazer ajustes de espaçamento/cores conforme necessário
```

## 🎓 Recursos

- [Figma Design Systems](https://www.figma.com/design-systems/)
- [Flutter Widget Inspector](https://flutter.dev/docs/development/tools/inspector)
- [Design Tokens em Flutter](https://flutter.dev/docs/development/ui/designsystems)
- [Figma MCP Docs](https://www.figma.com/developers/docs)

---

**Próximo Passo**: Na aula 02, vamos criar as primeiras telas com Figma MCP!
