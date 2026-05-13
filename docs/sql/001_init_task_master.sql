-- Task Master - Supabase Bootstrap
-- Execute este script no Supabase SQL Editor (projeto: hozlbckkkzkaaimyijfx)

begin;

-- Extensao para UUID aleatorio
create extension if not exists pgcrypto;

-- Tabela de perfil publico do usuario
create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Tabela de categorias
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  color text not null default '#2196F3',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, name)
);

-- Tabela de tarefas
create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid references public.categories(id) on delete set null,
  title text not null,
  description text,
  priority text not null default 'medium' check (priority in ('low', 'medium', 'high')),
  status text not null default 'pending' check (status in ('pending', 'in_progress', 'completed')),
  due_date timestamptz,
  image_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Indices
create index if not exists idx_tasks_user_id on public.tasks(user_id);
create index if not exists idx_tasks_status on public.tasks(status);
create index if not exists idx_tasks_due_date on public.tasks(due_date);
create index if not exists idx_categories_user_id on public.categories(user_id);

-- Trigger para updated_at
create or replace function public.handle_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_users_updated_at on public.users;
create trigger trg_users_updated_at
before update on public.users
for each row execute function public.handle_updated_at();

drop trigger if exists trg_categories_updated_at on public.categories;
create trigger trg_categories_updated_at
before update on public.categories
for each row execute function public.handle_updated_at();

drop trigger if exists trg_tasks_updated_at on public.tasks;
create trigger trg_tasks_updated_at
before update on public.tasks
for each row execute function public.handle_updated_at();

-- RLS
alter table public.users enable row level security;
alter table public.categories enable row level security;
alter table public.tasks enable row level security;

-- Policies: users
drop policy if exists users_select_own on public.users;
create policy users_select_own
on public.users
for select
using (auth.uid() = id);

drop policy if exists users_insert_own on public.users;
create policy users_insert_own
on public.users
for insert
with check (auth.uid() = id);

drop policy if exists users_update_own on public.users;
create policy users_update_own
on public.users
for update
using (auth.uid() = id)
with check (auth.uid() = id);

-- Policies: categories
drop policy if exists categories_select_own on public.categories;
create policy categories_select_own
on public.categories
for select
using (auth.uid() = user_id);

drop policy if exists categories_insert_own on public.categories;
create policy categories_insert_own
on public.categories
for insert
with check (auth.uid() = user_id);

drop policy if exists categories_update_own on public.categories;
create policy categories_update_own
on public.categories
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists categories_delete_own on public.categories;
create policy categories_delete_own
on public.categories
for delete
using (auth.uid() = user_id);

-- Policies: tasks
drop policy if exists tasks_select_own on public.tasks;
create policy tasks_select_own
on public.tasks
for select
using (auth.uid() = user_id);

drop policy if exists tasks_insert_own on public.tasks;
create policy tasks_insert_own
on public.tasks
for insert
with check (auth.uid() = user_id);

drop policy if exists tasks_update_own on public.tasks;
create policy tasks_update_own
on public.tasks
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists tasks_delete_own on public.tasks;
create policy tasks_delete_own
on public.tasks
for delete
using (auth.uid() = user_id);

-- Breaking change (2026): tabelas podem nao ficar expostas automaticamente na Data API.
-- Grants explicitos para anon/authenticated (com RLS ativo).
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on table public.users to anon, authenticated;
grant select, insert, update, delete on table public.categories to anon, authenticated;
grant select, insert, update, delete on table public.tasks to anon, authenticated;

-- Storage bucket (idempotente)
insert into storage.buckets (id, name, public)
values ('task-images', 'task-images', true)
on conflict (id) do update set public = excluded.public;

-- Storage policies
create policy if not exists task_images_select
on storage.objects
for select
using (bucket_id = 'task-images');

create policy if not exists task_images_insert
on storage.objects
for insert
with check (
  bucket_id = 'task-images'
  and auth.role() = 'authenticated'
);

create policy if not exists task_images_update
on storage.objects
for update
using (
  bucket_id = 'task-images'
  and auth.role() = 'authenticated'
)
with check (
  bucket_id = 'task-images'
  and auth.role() = 'authenticated'
);

create policy if not exists task_images_delete
on storage.objects
for delete
using (
  bucket_id = 'task-images'
  and auth.role() = 'authenticated'
);

commit;
