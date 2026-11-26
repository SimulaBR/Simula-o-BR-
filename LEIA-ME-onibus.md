# SimulaBr — frota de ônibus por arquivo

## Pastas
- `index.html` — o jogo (agora ~120 KB; os ônibus não ficam mais dentro dele)
- `modelos/onibus/` — um `.glb` por ônibus + `roda_onibus.glb` (roda usada por todos os da frota)
- `modelos/lanternas/` — desenhos das lanternas traseiras (base + LED + seta + ré)
- `sons/` — partida, marcha lenta, rotação alta e bipe de ré

O arquivo `onibus.glb` que estava na raiz do repositório não é mais usado (virou `modelos/onibus/rodoviario_classico.glb`). Pode apagar.

Abrir o `index.html` direto do celular (file://) não carrega os modelos. Pelo GitHub Pages funciona normal.

## Ônibus
| Arquivo | Nome no jogo | Origem (Fator RP) |
|---|---|---|
| rodoviario_classico | Rodoviário clássico | SimulaBr |
| urbano_classico | Urbano clássico | SimulaBr (crédito CC-BY mantido) |
| rodoviario_01 | Rodoviário 01 | onibus_rod_vermelho |
| rodoviario_02 | Rodoviário 02 | onibus_rod_02 |
| rodoviario_03 | Rodoviário 03 | onibus_rod_dourado |
| rodoviario_04 | Rodoviário 04 | onibus_rod_04 |
| rodoviario_05 | Rodoviário 05 | onibus_rod_amarelo |
| rodoviario_06 | Rodoviário 06 | onibus_rod_06 |
| rodoviario_09 | Rodoviário 09 | onibus_rod_branco |
| urbano_07 | Urbano 07 | onibus_amarelo |
| urbano_08 | Urbano 08 | onibus_branco |
| urbano_10 | Urbano 10 | onibus_laranja |

Cada `.glb` da frota tem estas peças: `carroceria` (sem as rodas antigas), `carroceria_dentro` (a casca de dentro, que some na visão do motorista), `porta_frente` (abre pelo lado direito) e `chassi` (caixas de roda, fundo da porta e assoalho).

## Lanternas
A configuração está no `index.html`, no campo `lant` de cada ônibus em `FROTA_FATOR`, com o mesmo formato do `LANT_PADRAO` do Fator RP. Os desenhos ganharam nomes genéricos:
leds_x, rod_vertical_a, rod_vertical_b, rod_vertical_c, rod_fina, urbano_3leds, urbano07_*, redonda_*.

Se você ajustou alguma lanterna pela aba Lanternas do Fator RP, esse ajuste ficou salvo no Supabase e não no código. Para pegar os valores, rode no SQL do Supabase:

```sql
select modelo, cfg from lanternas_onibus;
```

## Painel de ajuste das lanternas
1. Abra o jogo com `?ajuste` no fim do endereço (ex.: `.../Simula-o-BR-/?ajuste`). Aparece o botão **🚌 Lanternas**.
2. Escolha o ônibus, a peça e o lado, e ajuste com − e +. Os botões Lanterna / Freio / Alerta / Ré acendem para testar.
3. **💾 Salvar** guarda neste aparelho. Faça todos os ônibus que quiser.
4. **⬇ Exportar** baixa o `lanternas-ajustes.json` com todos os ajustes. Suba esse arquivo na raiz do repositório: o robô coloca em `modelos/lanternas/ajustes.json` e aí vale para todos os jogadores.

## Pintura e skins (ônibus da frota)
Na Garagem (☰ → Garagem → Escolher modelo de ônibus), com você dentro de um ônibus da frota:
- **Original**: a pintura do Fator RP.
- **Branco**: o ônibus todo branco.
- **Minha skin**: a imagem que você carregou.
- **⬇ Baixar modelo de pintura**: baixa `modelo_<ônibus>.jpg` (2048 × 2048) com a lataria aberta: lado esquerdo, lado direito, frente, traseira e teto.
- **📷 Carregar skin**: escolha a imagem pintada. Ela fica salva neste aparelho (cada ônibus tem a sua).

Os vidros continuam escuros (com reflexo) mesmo se a skin pintar por cima deles. Partes transparentes de um PNG mostram o ônibus branco.

Arquivos: `modelos/onibus/<ônibus>_branco.jpg` (lataria branca) e `modelos/onibus/skins/modelo_<ônibus>.jpg` (modelo de pintura).
