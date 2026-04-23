---
id: google-pmax
name: Performance Max Campaigns
category: google
version: 1.0.0
last_updated: 2026-04-22
loaded_by: [google]
---

# Performance Max (PMAX) Campaigns

## Overview
PMAX roda em todos os inventarios Google (Search, Display, YouTube, Gmail, Discover, Maps) via uma campanha unica controlada por IA. Sacrifica granularidade por alcance total e otimizacao cross-inventory. Requer data-driven attribution e audience signals bem construidas para nao virar black box sem controle.

## When to load (triggers)
- E-commerce com Merchant Center feed + pixel/GA4 funcionando (mandatory)
- Cliente com > 30 conversoes/mes (abaixo disso, PMAX trava em learning perpetuo)
- Replacing Smart Shopping ou Local campaigns (forced migration)
- Briefing com "PMAX", "Performance Max", "asset group", "audience signal"

## Core concepts

1. **Asset groups** — Equivalente a ad group. Cada asset group = 1 tema (ex: "Feminino Verao"). Cada group precisa dos 5 tipos de asset:
   - **Headlines** (3-15, 30 chars) + **Long headlines** (1-5, 90 chars)
   - **Descriptions** (1-5, 90 chars)
   - **Images** (1-20, multiplos aspect ratios: 1:1, 1.91:1, 4:5)
   - **Logos** (1-5, 1:1 e 4:1)
   - **Videos** (0-5 — se nao fornecer, Google gera auto-video; qualidade ruim)

2. **Audience signals** — NAO e targeting, e **seed** para Google aprender. 3 tipos:
   - **Your data segments**: customer list (email hash), site visitors, app users
   - **Custom segments**: keywords + URLs + apps que a audience usa
   - **Interests & demographics**: in-market, affinity, detalhes demograficos
   - Audience signal de qualidade acelera learning em 40-60%.

3. **Asset performance ratings** — Google classifica cada asset individualmente: `Low`, `Good`, `Best`, ou `Pending` (< 2000 impressions). Substituir Low por novos assets quinzenalmente.

4. **Final URL expansion** — Google pode mandar trafego para qualquer URL do seu dominio (nao so a que voce definiu). Desligar se LPs internas sao frageis. URL exclusions: lista de paths a ignorar.

5. **Brand exclusions** — Unica forma de evitar PMAX comprando queries de brand (canibalizando Search brand). Solicitar via lista de brand keywords (ate 10.000).

6. **Data-driven attribution (DDA)** — Default para PMAX. Requer GA4 conectado e > 3000 interactions/30d. Sem DDA, PMAX usa last-click e sub-otimiza cross-channel.

7. **Insights report** — Unica janela de visibilidade. Mostra: audience insights (quem converteu), search terms insights (agregado, sem granularidade de queries), asset performance.

## Key frameworks / decision heuristics

- **IF** cliente tem < 30 conversoes/mes **THEN** nao usar PMAX — ficar em Search + Standard Shopping manual.
- **IF** e-commerce **THEN** feed do Merchant Center e mandatorio (PMAX sem feed = so Search + Display, perde 50% do potencial).
- **IF** lead gen **THEN** PMAX so vale se conversoes de qualidade > 50/mes E Enhanced Conversions ativo E offline conversions import configurado.
- **IF** asset group tem > 1 asset com rating "Low" **THEN** substituir no proximo ciclo semanal.
- **IF** PMAX canibalizando brand Search **THEN** solicitar brand exclusion a Google (ticket via conta gerenciada).
- **IF** campanha ja roda 14 dias e tROAS > target **THEN** subir budget em 20% (nao > 20% para nao resetar learning).
- Sempre fornecer videos proprios (mesmo que simples) — auto-videos gerados pelo Google sao visualmente pobres e prejudicam brand.

## Concrete examples

### Exemplo 1: E-commerce moda feminina
- PMAX "Feminino Verao 2026"
- Asset group 1: Vestidos (15 headlines + 5 long + 5 desc + 20 imgs 1:1 + 10 imgs 4:5 + 2 logos + 3 videos 15s)
- Asset group 2: Biquinis
- Asset group 3: Sandalias
- Audience signal: lista de compradoras ultimos 180d + site visitors 30d + custom segment (kw "vestido midi", "biquini cortininha" + URLs de fashion e-commerces concorrentes)
- Final URL: expansion OFF (LPs fragil) + URL exclusions: /admin, /checkout-legacy

### Exemplo 2: SaaS B2B lead gen
- PMAX so roda se offline conversion import ativo (lead -> MQL -> SQL -> closed won)
- Asset group 1: CMOs de agencia (imagens: dashboards + depoimentos, videos: product demo 30s)
- Audience signal: customer list (500+ emails hash) + site visitors (paginas /produtos, /cases) + custom (kw "CRM agencia", "gestao clientes B2B")
- Conversion goals: Form submit (primary) + Demo booked (secondary, higher value)

### Exemplo 3: Troubleshoot PMAX com CAC subindo
- Checar: audience signal ainda relevante? (customer list de 2 anos atras vira ruido)
- Checar: asset performance? (substituir Low por novos a cada 14d)
- Checar: brand queries canibalizadas? (pedir brand exclusion)
- Checar: final URL expansion mandando trafego para /blog? (adicionar URL exclusion para /blog/*)

## Anti-patterns

1. **PMAX sem audience signal** — learning fase de 3-4 semanas (vs 1-2 com signal). Queima budget no processo.
2. **1 asset group com tudo misturado** — Google nao consegue otimizar por intent. Sempre 1 asset group = 1 tema coeso.
3. **Auto-generated videos aceitos** — Google gera slideshows genericos que ferram brand. Sempre subir video proprio minimo.
4. **Final URL expansion ON sem exclusion list** — trafego vai para /blog, /sobre, /politica-privacidade. Exclusoes obrigatorias.
5. **Sem brand exclusion em e-commerce estabelecido** — PMAX compra queries de brand a preco de ads, tROAS apparent alto mas incrementalidade zero.
6. **Ignorar Insights report** — unica visibilidade disponivel. Auditar semanal minimo.
7. **Mudar target tROAS/tCPA em > 15%** — trigger re-learning (2 semanas de performance degradada).
8. **Rodar PMAX com < 30 conversoes/mes** — learning nunca completa, budget vira passeio aleatorio.

## Platform specs / constraints

- **Asset groups por campanha**: ate 100.
- **Headlines**: 30 chars (3-15). **Long headlines**: 90 chars (1-5).
- **Descriptions**: 90 chars (1-5). Primeira description aparece primeiro.
- **Images**: 1200x1200 (1:1), 1200x628 (1.91:1), 960x1200 (4:5). Minimo 600px menor lado.
- **Logos**: 1200x1200 (1:1) + 1200x300 (4:1). Transparent background recomendado.
- **Videos**: minimo 10s, recomendado 15-30s. Se nao fornecer, Google auto-gera (qualidade inferior).
- **Final URL**: 1 por asset group. Expansion pode levar para qualquer URL do dominio.
- **Budget minimo recomendado**: R$ 100/dia (sem isso, learning impossivel). <!-- example -->
- **Learning phase**: 2-6 semanas. Nao fazer mudancas > 15% em budget/target durante.

## References
- MCP tools: `mcp__supabase__execute_sql` (exportar customer list para Audience Signal), `mcp__firecrawl__firecrawl_scrape` (auditar LPs inclusas em URL expansion)
- Related skills: `google-shopping`, `google-bidding`, `google-conversion-setup`
- Agent: `AioxAds:kasim-aslam`, `AioxAds:campaign-manager`, `AioxAds:creative-analyst`
