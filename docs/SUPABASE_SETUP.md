# Setup Supabase - TaskMaster

## 🚀 Criar Projeto Supabase

### 1. Acessar Supabase

1. Vá para [https://supabase.com](https://supabase.com)
2. Clique "Sign Up"
3. Use e-mail ou GitHub

### 2. Criar Novo Projeto

1. Click "New Project"
2. **Nome do Projeto**: `TaskMaster-DEV`
3. **Senha do banco**: Gere uma senha forte (guardar em local seguro!)
4. **Região**: Escolha mais próxima ao seu local
5. Click "Create New Project"

⏳ **Aguarde ~2 minutos enquanto o banco é criado...**

## 🔑 Copiar Chaves de Conexão

Na página do projeto:

1. Vá para **Settings** (engrenagem no rodapé)
2. Selecione **API**
3. Copie:
   - `Project URL` → `supabaseUrl`
   - `anon public key` → `supabaseAnonKey`

## 📝 Atualizar Configuração no Flutter

No arquivo `lib/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  /// URL do seu projeto Supabase (colar aqui)
  static const String supabaseUrl = 'https://seu-projeto-xxx.supabase.co';
  
  /// Chave pública (colar aqui)
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
  
  // ...resto do código
}
```

## 📊 Criar Tabelas no Banco

### Tabela: `users`

Na interface Supabase → **SQL Editor**:

```sql
create table users (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  full_name text,
  avatar_url text,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

-- Ativar RLS (Row Level Security)
alter table users enable row level security;

-- Política: usuário só pode ver seus próprios dados
create policy "users_can_read_own"
on users
for select
using (auth.uid() = id);
```

### Tabela: `tasks`

```sql
create table tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  title text not null,
  description text,
  priority text default 'medium', -- 'low', 'medium', 'high'
  status text default 'pending', -- 'pending', 'in_progress', 'completed'
  due_date timestamp,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

-- RLS
alter table tasks enable row level security;

-- Política: usuário só pode ver suas próprias tarefas
create policy "tasks_can_read_own"
on tasks
for select
using (auth.uid() = user_id);

-- Política: usuário pode inserir suas próprias tarefas
create policy "tasks_can_insert_own"
on tasks
for insert
with check (auth.uid() = user_id);

-- Política: usuário pode atualizar suas próprias tarefas
create policy "tasks_can_update_own"
on tasks
for update
using (auth.uid() = user_id);

-- Política: usuário pode deletar suas próprias tarefas
create policy "tasks_can_delete_own"
on tasks
for delete
using (auth.uid() = user_id);
```

### Tabela: `categories`

```sql
create table categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  name text not null,
  color text default '#2196F3',
  created_at timestamp default now()
);

-- RLS
alter table categories enable row level security;

create policy "categories_can_read_own"
on categories
for select
using (auth.uid() = user_id);

create policy "categories_can_insert_own"
on categories
for insert
with check (auth.uid() = user_id);

create policy "categories_can_update_own"
on categories
for update
using (auth.uid() = user_id);

create policy "categories_can_delete_own"
on categories
for delete
using (auth.uid() = user_id);
```

## 🗂️ Configurar Storage

Na interface Supabase → **Storage**:

1. Click **+ New Bucket**
2. **Nome**: `task-images`
3. **Público**: Deixe marcado para que as imagens fiquem acessíveis
4. Click **Create Bucket**

### Política de Upload

No bucket `task-images`, vá para **Policies** e crie:

```sql
-- Usuário pode fazer upload de seus próprios arquivos
create policy "authenticated_uploads"
on storage.objects
for insert
with check (
  auth.role() = 'authenticated'
  and bucket_id = 'task-images'
);
```

## 🔐 Ativar Autenticação

Na interface Supabase → **Authentication**:

1. Vá para **Providers**
2. Ative **Email** (já vem ativado por padrão)
3. Configure outras provedoras se quiser (Google, GitHub, etc)

## ✅ Testar Conexão

No seu projeto Flutter:

```dart
// Adicione em lib/main.dart (temporariamente)
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';

void main() async {
  try {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
    print('✅ Supabase conectado com sucesso!');
  } catch (e) {
    print('❌ Erro ao conectar: $e');
  }
  
  runApp(const TaskMasterApp());
}
```

Abra o console (DevTools) e procure pela mensagem ✅ ou ❌.

## 🚨 Segurança

### ⚠️ IMPORTANTE: Nunca commitar chaves no Git!

1. Crie um arquivo `.env` (nunca commit):
```
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOi...
```

2. Adicione `.env` ao `.gitignore`:
```
.env
.env.local
```

3. Use biblioteca para ler variáveis:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
```

## 🧪 Testar com Insomnia/Postman

Para testar endpoints:

1. Copie `SUPABASE_ANON_KEY`
2. Faça requisição para: `https://seu-projeto.supabase.co/rest/v1/tasks`
3. Header: `Authorization: Bearer {ANON_KEY}`
4. Header: `Content-Type: application/json`

Deve retornar `[]` (lista vazia de tarefas).

## 📚 Próximos Passos

- [ ] Configurar Supabase conforme este guia
- [ ] Atualizar `supabase_config.dart` com suas chaves
- [ ] Testar conexão no Flutter
- [ ] Criar primeira aula com Figma MCP
- [ ] Implementar telas base

## 🔗 Recursos

- [Supabase Docs](https://supabase.com/docs)
- [RLS Policies](https://supabase.com/docs/guides/auth/row-level-security)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/dart)
- [Database Schema Planning](https://supabase.com/docs/guides/database)

---

**Dúvidas?** Consulte a documentação do Supabase ou abra um issue no repositório!
