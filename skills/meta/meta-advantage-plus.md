---
id: meta-advantage-plus
name: Meta Advantage+ Features
category: meta
version: 1.0.0
last_updated: 2026-04-22
loaded_by: [meta]
---

# Meta Advantage+ — Features Beyond ASC

## Overview
Advantage+ é um guarda-chuva de features de automação da Meta. ASC (Advantage+ Shopping) é uma delas, mas existem várias outras: Advantage+ Audience, Advantage+ Placements, Advantage+ Creative, Advantage+ App Campaigns. Cobre: o que cada uma faz, quando ajuda vs restringe, e qualidade de sinal que cada uma precisa para funcionar.

## When to load (triggers)
- Cliente vê toggle "Advantage+" em alguma tela do Ads Manager e pergunta se deve ligar
- Performance platô em campanhas manuais e time quer testar automação incremental (não ASC full)
- Campanha de app install ou retenção mobile
- Criativo está saturando (frequência >3.5) e time quer expandir sem produzir mais assets
- Discussão menciona "audience expansion", "auto placement", "standard enhancements", "App ads", "AAA"

## Core concepts

**1. Advantage+ Audience** (antigo "Detailed Targeting Expansion"):
- Você define audiência seed (interesses, custom audiences, lookalike)
- Meta EXPANDE para fora do seed se achar conversão melhor
- Não é all-or-nothing: seed continua sendo prioridade, expansão é "caso sobre budget"
- **Default ON em novos ad sets** a partir de 2024

**2. Advantage+ Placements** (antigo "Automatic Placements"):
- Meta distribui impressões entre Feed, Stories, Reels, Marketplace, Audience Network, Messenger, etc
- Otimiza por custo por resultado, não por CTR bruto
- Economia de 10-30% no CPA vs placement manual na maioria dos casos

**3. Advantage+ Creative** (antigo "Standard Enhancements"):
- Meta aplica micro-edições no criativo: filtros, crops, music templates, text overlay variations
- Gera até 10 variações auto do mesmo asset
- Afeta aparência sem intervenção do creative team
- Pode ser desligado por nível (desligar texto dinâmico, manter crop auto)

**4. Advantage+ Audience Lookalike**:
- Gera LAL dinâmico a partir de custom audience sem você definir %
- Meta escolhe o tamanho ideal (1%, 3%, 5%) baseado em volume

**5. Advantage+ App Campaigns (AAA)**:
- Para apps mobile (iOS/Android)
- Otimiza por app event (install, registration, purchase in-app)
- 1 campanha → Meta distribui entre feed, stories, reels, audience network
- Substitui App Install Campaigns antigas

## Key frameworks / decision heuristics

**IF ad set novo, sem histórico específico → Advantage+ Audience ON (default)**
**IF ad set testando audience hipótese específica → Advantage+ Audience OFF (senão Meta "foge" do teste)**
**IF criativo novo, não sabemos qual placement performa → Advantage+ Placements ON**
**IF criativo 9:16 puro (Reels/Stories only) → Advantage+ Placements OFF + manual Reels+Stories (economiza testes em feed 1:1 ruim)**
**IF cliente tem aprovação estrita de criativo (pharma, finance, B2B enterprise) → Advantage+ Creative OFF (auto-text pode criar desvio de compliance)**
**IF app install campaign → AAA sempre (não existe boa alternativa em 2026)**

**Qualidade de sinal por feature:**

| Feature | Sinal mínimo para funcionar |
|---------|----------------------------|
| Advantage+ Audience | 50 conversões na audience seed |
| Advantage+ Placements | 25 conversões no conjunto de placements |
| Advantage+ Creative | 1 criativo base de qualidade (garbage in = garbage out ×10) |
| AAA | 100 app events na janela de 7 dias |

## Concrete examples

**Example 1 — Startup SaaS B2B, audience teste hipótese**
- Ad set A: interesse "CEO Finance SaaS" + Advantage+ Audience OFF (queremos validar se esse interesse converte)
- Ad set B: mesma audience + Advantage+ Audience ON (deixa Meta expandir se tiver sinal)
- Diferença de 5-15% no CPA; decisão entre testar limpo (A) vs performance (B) depende do objetivo do teste

**Example 2 — Ecomm moda, teste de Reels creative**
- Criativo é 9:16 produzido especificamente para Reels
- Advantage+ Placements OFF + manual select "Reels + Stories"
- Economia: 20-30% vs automático (que gastaria em feed 1:1 com o vídeo recortado mal)

**Example 3 — App fintech, migração para AAA**
- Antes: App Install Campaigns manuais, CPI R$8-12, budget 40% Audience Network <!-- example -->
- Pós-AAA: Meta rebalanceia, CPI R$5-8, 60% do budget migra para Reels + Feed, AN cai para 20% <!-- example -->
- Resultado: CPI -35%, D7 retention +20% (user quality melhor)

**Example 4 — Auto-enhancement saturado (anti-exemplo)**
- Cliente de finance ativou Advantage+ Creative com "auto text variations"
- Meta adicionou texto "ganhe R$ extra hoje" por cima do criativo
- Violou compliance regulatório, 3 anúncios reprovados, risco de ban
- Correção: Advantage+ Creative OFF para conta inteira, compliance-first

## Anti-patterns
- **Ligar todos os Advantage+ de uma vez em conta nova** — não sabe qual contribuiu com o ganho/perda. Ligue um por vez por 5-7 dias.
- **Advantage+ Audience ON em teste de hipótese** — Meta foge da audiência testada, você não aprende nada sobre ela.
- **Advantage+ Placements em criativo single-format** — desperdício de impressions em placement errado.
- **Advantage+ Creative em setor regulado** — risco de compliance alto (auto-text pode criar claim proibida).
- **AAA com <100 app events/semana** — Meta não tem sinal, CPI explode.
- **Esperar 1-2 dias para avaliar** — Advantage+ precisa de 5-7 dias para estabilizar. Julgamento precoce = pausar feature que ia performar.
- **Comparar Advantage+ vs manual com budgets diferentes** — teste inválido. Mesmo budget, mesma janela, audiences idênticas.
- **Desligar Advantage+ Placements assumindo que "sabemos o placement que funciona"** — dados históricos mudam. Re-teste a cada 90 dias.

## Platform specs / constraints
- **Default status (contas novas, 2026):**
  - Advantage+ Audience: ON
  - Advantage+ Placements: ON
  - Advantage+ Creative (Standard Enhancements): ON por default mas granular por feature
  - Advantage+ Lookalike: opt-in

- **Advantage+ Creative sub-features (toggle individual):**
  - Image brightness & contrast
  - Image filters
  - Image templates (music, effects)
  - Text improvements (rewrite primary text)
  - Image animation (still → subtle motion)
  - Visual touch-ups
  - Music additions
  - 3D image creation

- **AAA specs:**
  - Requer SDK configurado (Meta SDK ou MMP: AppsFlyer, Adjust, Singular)
  - App event mínimo rastreado: Install
  - Optimization events comuns: Complete Registration, Purchase, Subscribe
  - Objetivo único por AAA (não mistura install + purchase na mesma)
  - Budget mínimo: R$100-300/dia para sair de learning <!-- example -->

- **Reporting:**
  - Breakdown por placement: disponível
  - Breakdown por "Audience Expansion" on/off: disponível
  - Breakdown por "Creative Enhancement": limitado (Meta não revela qual variação performou)

## References
- Skills relacionadas: `meta-asc`, `meta-dct`, `meta-reels-stories`, `creative-analyst`
- MCP tools: nenhum nativo; validar via Ads Manager breakdown reports
- Internal testing framework: `meta-ab-test-setup` para isolar variável Advantage+ vs manual
- Meta doc: business.facebook.com/business/help/advantage-suite
- Related: `pixel-specialist` para validar sinal de eventos antes de ligar Advantage+
