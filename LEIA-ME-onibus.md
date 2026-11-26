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

## Instalar no celular
Em ☰ → Trabalhos e ajustes → Ajustes, o botão **📲 Instalar no celular** coloca o SimulaBr na tela inicial como app (tela cheia, deitado).
No iPhone: Safari → Compartilhar → "Adicionar à Tela de Início". Arquivos: `manifest.webmanifest`, `sw.js` e a pasta `icones/`.
Os ônibus e sons ficam guardados no aparelho: da segunda vez o jogo abre mais rápido. Quando um ônibus é atualizado, a versão nova aparece na abertura seguinte.

## Carrocerias padrão (desde 26/11)
A frota agora são 4 carrocerias brancas, feitas a partir dos modelos de alta qualidade do Meshy com a redução nova (forma preservada):
urbano.glb (Urbano), rodoviario_2e.glb, rodoviario_3e.glb e rodoviario_4e.glb. Cada uma tem o seu modelo de pintura em modelos/onibus/skins/.
Os arquivos antigos (rodoviario_01…09, urbano_07/08/10 e os _branco.jpg) não são mais usados: pode apagar do repositório.

## Mapa grande (versão 0.8)
A capital continua igual. Dela saem 4 rodovias: BR-101 (leste), BR-364 (oeste), BR-040 (norte) e BR-116 (sul). A norte e a sul se dividem num trevo.
- Porto Azul: cidade grande do litoral, com praia, mar, prédios altos e favela. Rodoviária grande, com 8 plataformas.
- Nova Safra: cidade do agro, com lavouras e silos. Rodoviária de concreto com marquise em V.
- Serra Verde: cidade da serra, com chalés, pinheiros e montanhas. Rodoviária de madeira.
- Santa Aurora: cidade histórica do interior, com igreja matriz e coreto na praça. Rodoviária de tijolo.
- Pedra Seca: cidade do sertão, com chão vermelho, casas coloridas de laje e cactos. Rodoviária-praça aberta.
- Ribeira do Norte: cidade ribeirinha, com rio, ponte e palafitas. Rodoviária de vidro.

Cada cidade tem posto com oficina ao lado da rodoviária, 4 pontos de carga e descarga e 2 pontos de ônibus. Cada rodovia tem mais um posto.

Ônibus: o embarque começa na plataforma livre em que você parar de frente. Na viagem rodoviária, o desembarque acontece em qualquer plataforma livre da cidade de destino. As plataformas ocupadas por NPC ou por outro veículo não contam.
Caminhão: a carreta espera no pátio do ponto de origem. Ela deve ser levada até a área DESCARGA do ponto de destino.

Mapa do mundo: tecla N, toque no minimapa ou ☰ → Mapa do mundo. O guincho leva você ao posto mais próximo.

## Moldes de vidros e detalhes (versão 0.8)
Nos 4 ônibus de carroceria padrão, o painel 🎨 Pintura agora tem 3 moldes. Cada um você baixa, pinta e carrega:
- Carroceria (modelo_<id>.jpg): é o mesmo de antes.
- Vidros (modelo_<id>_vidros.jpg): só as áreas escuras de vidro são usadas. Cor escura continua com cara de vidro, com reflexo; cor clara vira adesivo.
- Detalhes (modelo_<id>_detalhes.png): quadros de farol, lanterna traseira, placa, letreiro e calota. O verde puro (#00FF00) fica transparente, e um quadro todo verde mantém a peça original do ônibus.
  - No farol, o branco acende como farol e o laranja como pisca.
  - Na lanterna, o vermelho é lanterna e freio, o laranja é pisca e o branco é ré.
  - O letreiro brilha à noite.
  - O lado direito é espelhado do esquerdo.
  - Com o molde de detalhes ativo, a lanterna desenhada passa a usar o seu desenho, e a posição continua a do painel de ajuste.
Tudo fica salvo no aparelho.
