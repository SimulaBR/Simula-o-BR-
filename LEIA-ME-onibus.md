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

## Peças prontas
No 🎨 Pintura, em "Peças prontas", você escolhe farol, lanterna, calota e letreiro (Original ou um modelo) e digita o texto do letreiro.
As imagens ficam em modelos/pecas/. O fundo_farol_<id>.png apaga o farol original por baixo da peça nova.
Para pôr peças novas, mande a imagem: eu recorto o fundo e coloco a peça na lista PECAS do index.html (o campo p diz em quais ônibus ela serve).
O molde de detalhes que você baixa já vem com as peças escolhidas desenhadas no lugar.

## Correção dos vidros (26/11)
Cada ônibus padrão agora tem uma máscara de janelas: o arquivo modelos/onibus/skins/vidro_<id>.png. Assim o molde de vidros pega as janelas com cortina e o vidro traseiro, e não só as partes escuras.
O teto e os frisos escuros deixaram de ser tratados como vidro: a skin da carroceria pinta essas partes também.
A calota ficou um pouco menor e para dentro, para não sobrar para fora da roda.

## Caminhões e carretas (versão 0.9)
Ficam em modelos/caminhoes/. São 4 cavalos: cav_cinza (6x2), cav_verde (6x2), cav_azul (4x2) e cav_laranja (4x2). Cada um tem a versão branca (_branco.jpg) e o molde de pintura em skins/.
Carretas: car_grade3 (grade 3 eixos), car_grade5 (grade alta 5 eixos) e bitrem_1 + bitrem_2 (bitrem lonado, as 2 carretas dobram na curva). O baú continua o antigo, até chegar um modelo 3D de baú.
Qualquer cavalo puxa qualquer carreta, porque o engate de cada um está medido.
Quem escolhe a carreta é a carga: grãos e fertilizante vão no bitrem; bebidas, cimento e sacaria na grade 3 eixos; frutas e madeira na grade alta; o resto no baú.
Grade e bitrem não têm portas: é só parar na área DESCARGA.
A garagem (☰) tem a lista "Caminhões". A pintura funciona igual à dos ônibus.

## Luz dos faróis e facho no chão
Cada farol pronto tem um mapa de luz em modelos/pecas/<farol>_luz.png, com 3 cores:
- vermelho: lentes do farol (acendem no baixo e ficam mais fortes no alto);
- verde: LED diurno (fica aceso com o motor ligado);
- azul: pisca.
Os caminhões têm o brilho do farol, da lanterna e do pisca na posição certa de cada modelo.
À noite, ônibus e caminhões projetam um facho de luz no chão, que fica maior no farol alto.

## Peça atrás das rodas (27/11)
Tirei dos 4 ônibus de carroceria padrão (também da parte de dentro da carroceria) o lameiro e o suporte que ficavam pendurados atrás das rodas.

## Molde único (27/11)
Nos 4 ônibus padrão, o molde da carroceria (modelos/onibus/skins/modelo_<id>.jpg) agora traz tudo numa imagem só:
- carroceria e vidros: o vidro escuro continua vidro, com reflexo; a cor clara vira adesivo;
- quadros de peças: lanterna, farol, placa, calota e letreiro.
O que você pinta num quadro vai para a peça; o outro lado é espelhado. A lanterna continua acendendo: vermelho no freio, laranja no pisca, branco na ré.
Quadro deixado como veio no molde = fica a peça original. As posições dos quadros e as miniaturas de comparação estão em skins/slots.json.
Peças prontas escolhidas no painel ficam por cima dos quadros da skin. Os moldes antigos separados (vidros e detalhes) continuam funcionando.

## Vidros na skin e caminhões (27/11)
A pintura da carroceria que "vaza" para o vidro (como acontece em skins feitas por IA) não vira mais adesivo: a cor parecida com a da carroceria fica como vidro. Adesivo só aparece onde a cor é diferente da carroceria.
A máscara de vidro agora também pega a parte do para-brisa que fica na faixa do teto.
Caminhões: a versão branca (_branco.jpg) e os moldes foram refeitos com o branco por igual, para a skin não sair manchada.

## Contas online, garagem e administrador (versão 0.9)
O jogo agora pode ter contas (Supabase). Enquanto `banco/config.js` estiver vazio, ele roda local como antes.

Para ligar:
1. Crie um projeto novo no Supabase (separado do Fator RP).
2. SQL Editor → New query → cole todo o `banco/schema.sql` → Run.
3. Authentication → URL Configuration: em **Site URL** e **Redirect URLs** coloque `https://simulabr.github.io/Simula-o-BR-/` (é para onde vão os links de confirmação de email e de recuperar senha).
4. Project Settings → API: copie **Project URL** e a chave **anon public** para `banco/config.js` (dá para editar direto no GitHub).
5. Abra o jogo, crie a sua conta e rode no SQL Editor (trocando o nome):
   `update public.perfis set admin = true where usuario = 'SEU_USUARIO';`

Como funciona:
- Cadastro com email, senha e nome de usuário; "Esqueci a senha" manda um link por email.
- No primeiro acesso o jogador escolhe um veículo grátis. Os outros são comprados com o dinheiro do jogo.
- Comprar e trocar só nas garagens (as oficinas, **O** laranja no mapa). O jogador só tem o veículo ativo no mapa.
- Dinheiro, veículos e estado (combustível, desgaste) ficam no servidor.
- O bagageiro não abre mais.
- ☰ → **🛠 Administrador** (só para a sua conta): lanternas traseiras e faróis dianteiros (salvam para todos) e a lista de veículos.
  Veículo novo entra como **Beta**: só você vê e testa ("Testar"). Aprovado, mude para **Público**, coloque o preço e salve.
- `?ajuste` no endereço continua funcionando no modo local (agora com o botão 💡 Faróis também).

Importante: `banco/config.js` só vem neste pacote. Os próximos pacotes não trazem ele, para não apagar a sua chave.

## Novos G7, interior e rodoviários antigos (27/11)
- **Rodoviário G7 3 eixos** (novo, `rodoviario_g7`): base branca lisa, vidros lisos, porta da frente abrindo, faróis e lanternas de verdade, interior com cabine e poltronas (aparece na câmera de dentro).
- **Rodoviário 4 eixos** agora é o G7 de dois andares (sem a pintura da 1001), com interior completo. Skins antigas do 4 eixos antigo não servem mais: baixe o molde novo.
- Os moldes dos dois G7 não têm quadros de peças: faróis, lanternas e cromados já são peças do ônibus.
- Faróis dos ônibus: sem os retângulos brancos, só o brilho (igual ao caminhão).
- Rodoviários clássicos 01, 02, 03, 04, 05, 06 e 09 voltaram como **Beta**.
- Linhas urbanas podem ser feitas com rodoviário.
- Rode `banco/atualizacao_2.sql` no SQL Editor (urbanos fora da loja e novos veículos como Beta).
- Créditos (CC-BY-4.0): Marcopolo g7 1200 FREE, por SquielOFICIAL; Marcopolo G7 1200 VOLVO Auto Viação 1001, por miguterj2106.

## Som do motor Scania V8 (27/11)
Um som só para ônibus e caminhões, separado do áudio enviado (pasta `sons`):
`scania_partida` (ligar), `scania_lenta` (parado), `scania_acelera` (acelerar e soltar, parado), `scania_alto` (acelerar sem soltar),
`scania_reducao` (soltar o acelerador em giro alto, andando), `scania_desliga` (desligar). O ruído de tambor saiu do motor e virou
`freio_tambor`, que só toca quando você freia andando.

## Tourismo e FH16 (27/11)
- **Rodoviário Tourismo 3 eixos** (`rodoviario_tourismo`) e **Cavalo 4x2 FH16** (`cav_fh16`), no mesmo padrão dos G7: base branca, vidros lisos, faróis e lanternas de verdade, interior na câmera de dentro. O Tourismo tem a porta da frente abrindo; o FH16 engata as carretas normalmente.
- Os dois entram como **Beta** (já estão no `banco/atualizacao_2.sql`; se você já rodou, rode de novo, ele só acrescenta o que falta).
- Créditos: "Mercedes-Benz Tourismo" e "Volvo FH16", por Nieve5677 (CC-BY-4.0).

## Correções (27/11, tarde)
- Trocar de veículo pelos botões rápidos (☰ → Garagem: Caminhão/Rodoviário/Urbano) no modo online levava a câmera para fora do mapa. Agora esses botões abrem a garagem do menu.
- G7 de dois andares: carroceria 12 cm mais alta (estava rebaixado), vidros e partes escuras corrigidos (a "película" de reflexo que cobria o ônibus inteiro saiu), para-brisa de baixo de volta.

## Skins oficiais (27/11)
- Agora só o administrador cria skins. Rode `banco/atualizacao_3.sql` no SQL Editor.
- ☰ → 🛠 Administrador → **Skins**: escolha o veículo, **Baixar molde**, faça a skin e **Enviar skin** (PNG ou JPG, 2048 x 2048). Ela entra como Beta (só você vê). Teste no veículo, depois deixe **Pública** com o preço e salve. Marque **Padrão** na skin de fábrica (grátis; é a que o veículo usa quando o jogador não escolheu nenhuma).
- Cada skin é de um veículo só (a do G7 não aparece no New Road).
- Jogador: na garagem, em "Skins do …", toca na skin para comprar e usar. Não há mais envio de arquivos pelo jogador; as peças (farol, lanterna, calota) e o texto do letreiro continuam à escolha dele e ficam salvos na conta.
- Sem conta (modo local) continua tudo como antes.

## Suspensão, som antigo de volta e farol do G7 DD (27/11)
- **Suspensão** em todos os veículos: na garagem, "Suspensão" com dianteira e traseira separadas (sobe/abaixa). O limite é do administrador:
  ☰ → 🛠 Administrador → "Suspensão · (veículo atual)": altura de fábrica dianteira/traseira e até quantos cm o jogador pode mexer. "Ver" testa, "Salvar" vale para todos.
  Rode `banco/atualizacao_4.sql` (libera esse ajuste no banco). O G7 DD já sai 8 cm mais alto de fábrica.
- **Som**: voltou o som antigo do motor. Novo: parado (freio, freio de mão ou neutro), pisar no acelerador faz o motor roncar e o giro cai ao soltar. O som de tambor continua só no freio.
- **G7 DD**: o brilho do farol foi para fora do farol (estava dentro do buraco da peça) e ficou menor.

## Luzes novas (27/11)
- As lanternas montadas saíram. Cada veículo tem **pontos de brilho**: farol baixo (bola branca), farol alto, lanterna/freio, ré e seta.
- ☰ → 🛠 Administrador → **💡 Luzes** (ou `?ajuste` no modo local): escolha o ponto, mude tipo, lado, altura, frente/trás, largura e altura do brilho; "Os dois lados" espelha. "Novo" acrescenta quantos pontos quiser. Teste farol baixo/alto, freio, ré e setas; "Ver traseira/frente" gira a câmera. 💾 Salvar vale para todos.
- Peças farol e lanterna saíram da escolha do jogador: a skin traz tudo (farol, lanterna, placa, calota e letreiro, quando o molde tem esses quadros).

## Cabine e entrada (27/11)
- Com a porta aberta aparece a entrada: degraus com borda amarela, corrimão e mureta (ônibus antigos e 360/380/Urbano). Nos G7, DD e Tourismo aparece o interior do próprio modelo.
- Atrás do motorista há uma divisória com porta: na primeira pessoa não se veem as poltronas.
- Primeira pessoa: a câmera fica presa à cabine; por dentro a lataria não tapa mais a visão (só o cenário passa pelos vidros); colunas e moldura do para-brisa próprias; menos tranco.
- Caminhões: cabine com assoalho, fundo com cortina da cama, portas por dentro e teto.

## Cabine do G7 1200, lanternas 3D, portas e skins novas (27/11, noite)
- **Cabine do G7 1200 em todos os ônibus** que não têm interior próprio (clássicos 01 a 09, 2 eixos, 3 eixos, clássico): painel, volante, coluna, pedais, câmbio, poltrona do motorista, divisória com porta, teto e escada de entrada. A câmera da 1ª pessoa acompanha a cabine.
- **Caminhões antigos** (azul, cinza, laranja e verde): painel, volante e bancos do FH16, com as paredes da cabine. Agora tudo isso só aparece na 1ª pessoa ou com a porta aberta; antes umas placas escuras apareciam por fora.
- **Ajuste da cabine** (administrador): ☰ → 🛠 Administrador → Suspensão → "Cabine (1ª pessoa)": frente/trás, altura e largura. Use "Ver", feche o painel e confira na 1ª pessoa; "Salvar" vale para todos. Fica guardado junto com a suspensão, então não precisa de SQL novo para isso.
- **Lanternas 3D: retiradas** (ficaram feias). A iluminação fica só com o efeito de brilho dos pontos do painel 💡 Luzes (farol baixo, alto, lanterna/freio, ré e seta).
- **Portas**: o lado de dentro das portas, que ficava invisível, agora é cinza.
- **Skins novas, todas em BETA** (só o administrador vê): rode `banco/atualizacao_5.sql` no SQL Editor (pode rodar de novo, não duplica). As imagens ficam na pasta `skins_oficiais/` do site.
  - G7 1200: Cronos Viações, Expresso SimBR, Expert Bus, Maximus Brasil preto e cinza.
  - G7 DD: Kondoe, Merlin Prata, Expresso SimBR.
  - Rodoviário 3 eixos: Expresso Kondoe, Expert SBR, Merlin Prata, Kondoe.
  - Rodoviário 2 eixos: Expresso Kondoe, SimBR, Merlin Prata.
  - Clássico 03: Cronos, Expresso SimBR, Merlin Prata. Clássico 09: Cronos, Chapadinha, Maximus Brasil.
  - Caminhões (azul, cinza, laranja, verde e FH16): FIVE Transportes em 11 cores (branco, prata, grafite, preto, vermelho, vinho, laranja, amarelo, verde, azul e azul-marinho). A grade e os cromados da frente não mudam de cor.
  - Todas entram com **preço 0**. Antes de deixar uma skin Pública, defina o preço (com preço 0 ela fica grátis para todos).

## G7 1200 com skin na lanterna e rasgo do G7 DD (27/11, noite)
- **G7 1200**: a lanterna traseira agora recebe a skin, como o resto da lataria. As skins e o molde continuam valendo; nada muda no desenho. O brilho do freio, da ré e das setas continua pelos pontos do painel 💡 Luzes.
- **G7 DD (1800)**: o rasgo na traseira foi fechado. Umas áreas escuras da traseira e das grelhas do motor eram tratadas como vidro, e dava para ver o céu e o lado de dentro através delas. Agora a traseira e as duas grelhas laterais são lataria.
- Na primeira abertura depois de atualizar pode aparecer ainda o modelo antigo (o jogo guarda cópia no aparelho); na abertura seguinte vem o novo.
