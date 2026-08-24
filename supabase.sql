-- Tabela de leads da landing page do DeBoa.
-- Rode isto no SQL Editor do Supabase (projeto hmasenjcnpajirpeushg).
-- É idempotente: pode rodar de novo sem quebrar nada.

create table if not exists public.leads (
  id          uuid primary key default gen_random_uuid(),
  email       text not null,
  origem      text,
  criado_em   timestamptz not null default now()
);

-- Um cadastro por e-mail. Se a pessoa enviar de novo, a API devolve 409 e a
-- landing page trata isso como sucesso (ela já está na lista).
create unique index if not exists leads_email_unique
  on public.leads (lower(email));

-- ─────────────────────────────────────────────────────────────────────────
-- SEGURANÇA
--
-- A landing page é estática: a chave `anon` fica visível no HTML para
-- qualquer visitante. Isso só é seguro com RLS ligado e uma policy que
-- permita APENAS inserir. Sem a linha `enable row level security`, essa
-- mesma chave pública deixaria qualquer pessoa baixar a lista inteira de
-- e-mails.
-- ─────────────────────────────────────────────────────────────────────────

alter table public.leads enable row level security;

-- Qualquer visitante pode se cadastrar...
drop policy if exists "anon pode cadastrar" on public.leads;
create policy "anon pode cadastrar"
  on public.leads
  for insert
  to anon
  with check (
    email is not null
    and length(email) between 5 and 254
    and position('@' in email) > 1
  );

-- ...e ninguém anônimo pode ler, alterar ou apagar. Não criamos policy de
-- select/update/delete para `anon`: com RLS ligado, a ausência de policy já
-- nega tudo. Você lê os leads pelo painel do Supabase (que usa outra chave).

-- Conferir depois de rodar:
--   select count(*) from public.leads;
-- E confirme no painel: Authentication → Policies → leads deve mostrar
-- apenas a policy de INSERT.
