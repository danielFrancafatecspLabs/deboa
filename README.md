# DeBoa — landing page

Site de captação de leads do DeBoa, um agente que lê o contexto financeiro da
pessoa e intervém antes de uma decisão de compra.

Publicado via GitHub Pages: **https://danielfrancafatecsplabs.github.io/deboa/**

## Como funciona

São arquivos estáticos, **sem build**. `index.html` carrega tudo: marcação,
estilos e comportamento. Para publicar, basta servir esta pasta como raiz.

## Captura de leads

Os cadastros vão por `POST` para a tabela `leads` do Supabase, marcados com a
origem (`hero`, `cta-final` ou `demo`).

> **Rode `supabase.sql` no SQL Editor do Supabase antes de divulgar a página.**
> Ele cria a tabela e liga o RLS com uma policy que permite apenas INSERT. A
> chave `anon` fica visível no HTML — é assim que ela é feita para funcionar —
> mas sem RLS essa mesma chave deixaria qualquer visitante baixar a lista
> inteira de e-mails.

Se o insert falhar, o formulário mostra erro em vez de uma confirmação falsa:
melhor a pessoa tentar de novo do que o cadastro sumir em silêncio. Uma cópia
fica no `localStorage` apenas como rede de segurança.

## Relação com o app

O produto em si vive em
[`debboa-think-ahead`](https://github.com/danielFrancafatecspLabs/debboa-think-ahead),
que roda com SSR e não caberia em hospedagem estática. Lá existe a mesma
landing page em React (`src/routes/lancamento.tsx`).

São duas cópias do mesmo conteúdo. Ao mudar texto ou a lógica de recomendação
de um lado, replique no outro:

| Aqui | No app |
| --- | --- |
| `index.html` | `src/routes/lancamento.tsx` |
| função `evaluate()` | `src/services/decisionEngine.ts` |
| perfil de teste (R$ 2.800) | `DEFAULT_CONTEXT` em `src/data/seed.ts` |

Os links "Ver demo" apontam para o app publicado. Se ele for renomeado no
Lovable, atualize-os — procure pelos comentários `<!-- APP_URL -->`.
