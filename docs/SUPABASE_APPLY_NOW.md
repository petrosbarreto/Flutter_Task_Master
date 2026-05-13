# Aplicacao Rapida do Banco (Task Master)

## O que aconteceu
A aplicacao automatica por CLI falhou por permissao da conta no projeto Supabase `hozlbckkkzkaaimyijfx`.

Erro recebido ao tentar `supabase link --project-ref hozlbckkkzkaaimyijfx`:
- `Your account does not have the necessary privileges to access this endpoint`

## Como aplicar agora (1 passo)
1. Abra o projeto no Supabase Dashboard.
2. Entre em **SQL Editor**.
3. Copie e execute o arquivo:
   - `docs/sql/001_init_task_master.sql`

## O que o script cria
- Tabelas: `users`, `categories`, `tasks`
- Indices para performance (`user_id`, `status`, `due_date`)
- Trigger de `updated_at`
- RLS em todas as tabelas
- Policies de CRUD por usuario autenticado
- Grants explicitos para `anon` e `authenticated` (Data API)
- Bucket de storage `task-images` + policies

## Validacao apos rodar SQL
Execute no SQL Editor:

```sql
select table_name
from information_schema.tables
where table_schema = 'public'
  and table_name in ('users', 'categories', 'tasks')
order by table_name;
```

Esperado: 3 linhas (`categories`, `tasks`, `users`).

## Teste no app
Depois do SQL:
1. `flutter run`
2. Criar conta/login
3. Criar tarefa
4. Atualizar status
5. Excluir tarefa
