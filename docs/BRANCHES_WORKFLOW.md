# Workflow de Branches - TaskMaster

## 📌 Convenção de Branches

```
aula/01-setup-inicial
aula/02-layouts-estaticos
aula/03-navigacao
...
```

## 🔄 Ciclo de Vida de uma Branch

### 1️⃣ Criação (a partir da branch anterior)

```bash
# Garantir que estamos na branch base atualizada
git checkout aula/01-setup-inicial
git pull origin aula/01-setup-inicial

# Criar nova branch
git checkout -b aula/02-layouts-estaticos
```

### 2️⃣ Desenvolvimento

```bash
# Editar arquivos, adicionar features
code lib/features/tasks/screens/tasks_screen.dart

# Commits pequenos e descritivos
git add .
git commit -m "feat: tela inicial de tarefas com Figma MCP"
git commit -m "fix: espaçamento do AppBar"
```

### 3️⃣ Validação Local

```bash
# Analisar código
flutter analyze

# Formatar código
flutter format .

# Testar no emulador/dispositivo
flutter run

# Executar testes (se existirem)
flutter test
```

### 4️⃣ Push e Criação Remota

```bash
# Fazer push da branch
git push -u origin aula/02-layouts-estaticos

# Verificar branches remotas
git branch -a
```

### 5️⃣ Merge (opcional, para documentação)

```bash
# Voltar para a branch anterior
git checkout aula/01-setup-inicial

# Fazer merge (com histórico de commits)
git merge --no-ff aula/02-layouts-estaticos

# Ou fazer squash (um commit só)
git merge --squash aula/02-layouts-estaticos
```

## ✅ Checklist Antes de Fazer Push

- [ ] Código compila sem erros (`flutter build`)
- [ ] Sem warnings de análise (`flutter analyze`)
- [ ] Código formatado (`flutter format .`)
- [ ] Testado no emulador/dispositivo
- [ ] Commits com mensagens claras
- [ ] README atualizado (se necessário)
- [ ] Dependências novas no pubspec.yaml estão documentadas

## 📖 Commits Bem-Formados

Use **Conventional Commits**:

```
feat: descrição curta da feature
fix: descrição do bug corrigido
chore: alterações de build, dependências, etc
docs: alterações na documentação
refactor: reorganização de código
test: adição ou correção de testes
```

### Exemplos

```bash
git commit -m "feat: tela de listagem com FutureBuilder"
git commit -m "feat: integração com Supabase Database"
git commit -m "fix: erro ao carregar tarefas com conexão lenta"
git commit -m "chore: adicionar flutter_lints"
git commit -m "docs: atualizar guia do Figma MCP"
```

## 🚨 Troubleshooting

### Conflito de Merge

```bash
# Se houver conflito durante merge
git status  # Ver arquivos com conflito

# Editar os arquivos e resolver conflitos manualmente
# Depois fazer:
git add .
git commit -m "merge: resolver conflitos em XYZ"
```

### Desfazer Last Commit (antes de push)

```bash
# Manter as mudanças
git reset --soft HEAD~1

# Descartar as mudanças
git reset --hard HEAD~1
```

### Branch Local Desatualizada

```bash
# Atualizar branch local com remota
git fetch origin
git merge origin/aula/01-setup-inicial
```

## 📊 Visualizar Histórico

```bash
# Ver branches com último commit
git branch -vv

# Ver histórico em grafo
git log --oneline --graph --all

# Ver commits entre branches
git log aula/01-setup-inicial..aula/02-layouts-estaticos
```

---

**Lembre-se**: Cada branch é acumulativa. O código anterior sempre deve estar funcional!
