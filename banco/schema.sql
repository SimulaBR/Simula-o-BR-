-- =====================================================================
--  SimulaBr — banco de dados (Supabase / Postgres)
--  Como usar: Supabase → SQL Editor → New query → cole TUDO → Run.
--  Pode rodar de novo sem medo: o script recria funções e políticas.
--
--  Depois de criar a SUA conta no jogo, rode a linha do fim do arquivo
--  (com o seu nome de usuário) para virar administrador.
-- =====================================================================

create extension if not exists citext;

-- ---------------------------------------------------------------------
-- 1) PERFIS — um por conta (criado sozinho no cadastro)
-- ---------------------------------------------------------------------
create table if not exists public.perfis (
  id            uuid primary key references auth.users on delete cascade,
  usuario       citext unique not null
                check (usuario ~ '^[A-Za-z0-9_.]{3,20}$'),
  dinheiro      bigint not null default 5000 check (dinheiro >= 0),
  admin         boolean not null default false,
  veiculo_ativo bigint,
  criado_em     timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 2) CATÁLOGO — todos os veículos do jogo
--    status: 'beta'    = só o administrador vê e testa
--            'publico' = aparece na loja para todos, com preço
--            'oculto'  = fora da loja (quem já comprou continua com ele)
-- ---------------------------------------------------------------------
create table if not exists public.veiculos_catalogo (
  id            text primary key,          -- id do modelo no jogo
  tipo          text not null check (tipo in ('onibus','caminhao','carreta')),
  nome          text not null,
  status        text not null default 'beta' check (status in ('beta','publico','oculto')),
  preco         integer not null default 0 check (preco >= 0),
  atualizado_em timestamptz not null default now()
);

insert into public.veiculos_catalogo (id, tipo, nome, status, preco) values
  ('urbano',             'onibus',   'Urbano',                   'publico',  60000),
  ('rodoviario_2e',      'onibus',   'Rodoviário 2 eixos',       'publico',  90000),
  ('rodoviario_3e',      'onibus',   'Rodoviário 3 eixos',       'publico', 130000),
  ('rodoviario_4e',      'onibus',   'Rodoviário 4 eixos',       'publico', 190000),
  ('rodoviario_classico','onibus',   'Rodoviário clássico',      'oculto',   70000),
  ('urbano_classico',    'onibus',   'Urbano clássico',          'oculto',   45000),
  ('cav_azul',           'caminhao', 'Cavalo 4x2 azul',          'publico',  85000),
  ('cav_laranja',        'caminhao', 'Cavalo 4x2 laranja',       'publico',  85000),
  ('cav_cinza',          'caminhao', 'Cavalo 6x2 cinza',         'publico', 110000),
  ('cav_verde',          'caminhao', 'Cavalo 6x2 verde',         'publico', 110000),
  ('carreta_bau',        'carreta',  'Carreta baú',              'publico',  25000),
  ('carreta_grade3',     'carreta',  'Carreta grade 3 eixos',    'publico',  30000),
  ('carreta_grade5',     'carreta',  'Carreta grade alta 5 eixos','publico', 42000),
  ('carreta_bitrem',     'carreta',  'Carreta bitrem lonado',    'publico',  55000)
on conflict (id) do nothing;

-- ---------------------------------------------------------------------
-- 3) GARAGENS DO MAPA — onde se troca e compra veículo
--    (são as oficinas do jogo: capital, 6 cidades e postos da estrada)
-- ---------------------------------------------------------------------
create table if not exists public.garagens (
  id     serial primary key,
  nome   text not null,
  x      real not null,
  z      real not null,
  raio   real not null default 45
);

insert into public.garagens (id, nome, x, z) values
  (1,  'Capital',            -60,   -50),
  (2,  'Porto Azul',         2052,  265),
  (3,  'Nova Safra',        -2122,  185),
  (4,  'Serra Verde',        1368, -1822),
  (5,  'Santa Aurora',      -1532, -1622),
  (6,  'Pedra Seca',         1532,  1922),
  (7,  'Ribeira do Norte',  -1268,  1822),
  (8,  'Posto rodovia leste', 770,   65),
  (9,  'Posto rodovia oeste',-777,  -50),
  (10, 'Posto rodovia norte', -35, -674),
  (11, 'Posto rodovia sul',   -35,  642)
on conflict (id) do nothing;
select setval(pg_get_serial_sequence('public.garagens','id'), (select max(id) from public.garagens));

-- ---------------------------------------------------------------------
-- 4) VEÍCULOS DE CADA JOGADOR (a garagem dele)
-- ---------------------------------------------------------------------
create table if not exists public.veiculos_jogador (
  id          bigserial primary key,
  dono        uuid not null references public.perfis on delete cascade,
  modelo      text not null references public.veiculos_catalogo,
  pintura     jsonb not null default '{}'::jsonb,   -- cores, peças, letreiro
  skin_url    text,                                 -- imagem da skin (Storage)
  km          real not null default 0,
  combustivel real not null default 100,
  motor       real not null default 100,
  pneus       real not null default 100,
  freios      real not null default 100,
  lataria     real not null default 100,
  comprado_em timestamptz not null default now(),
  unique (dono, modelo)
);

do $$ begin
  alter table public.perfis add constraint perfis_veiculo_ativo_fk
    foreign key (veiculo_ativo) references public.veiculos_jogador(id) on delete set null;
exception when duplicate_object then null; end $$;

-- ---------------------------------------------------------------------
-- 5) POSIÇÃO DE CADA JOGADOR (salva a cada poucos segundos;
--    o movimento ao vivo vai pelo Realtime, sem gravar no banco)
-- ---------------------------------------------------------------------
create table if not exists public.posicoes (
  jogador       uuid primary key references public.perfis on delete cascade,
  x             real not null,
  z             real not null,
  h             real not null default 0,
  modelo        text,
  atualizado_em timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 6) HISTÓRICO — fretes e linhas concluídos
-- ---------------------------------------------------------------------
create table if not exists public.historico (
  id        bigserial primary key,
  jogador   uuid not null references public.perfis on delete cascade,
  tipo      text not null check (tipo in ('frete','linha','gasto')),
  descricao text,
  valor     integer not null,
  criado_em timestamptz not null default now()
);
create index if not exists historico_jogador_idx on public.historico (jogador, criado_em desc);

-- ---------------------------------------------------------------------
-- 7) AJUSTES DO ADMINISTRADOR — lanternas (traseira) e faróis (dianteira)
--    valem para todos os jogadores
-- ---------------------------------------------------------------------
create table if not exists public.ajustes (
  modelo         text not null,
  tipo           text not null check (tipo in ('lanterna','farol')),
  dados          jsonb not null,
  atualizado_em  timestamptz not null default now(),
  atualizado_por uuid references public.perfis on delete set null,
  primary key (modelo, tipo)
);

-- =====================================================================
--  FUNÇÕES
-- =====================================================================

create or replace function public.eh_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce((select admin from perfis where id = auth.uid()), false)
$$;

-- cria o perfil quando a conta é criada (o nome vem do cadastro)
create or replace function public.novo_usuario() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into perfis (id, usuario)
  values (new.id, coalesce(new.raw_user_meta_data->>'usuario', 'jogador_' || substr(new.id::text, 1, 8)));
  return new;
end $$;

drop trigger if exists ao_criar_conta on auth.users;
create trigger ao_criar_conta after insert on auth.users
  for each row execute function public.novo_usuario();

-- o cadastro pergunta se o nome está livre antes de criar a conta
create or replace function public.usuario_livre(p_usuario text) returns boolean
language sql stable security definer set search_path = public as $$
  select p_usuario ~ '^[A-Za-z0-9_.]{3,20}$'
     and not exists (select 1 from perfis where usuario = p_usuario::citext)
$$;

-- o jogador está perto de uma garagem? (pela última posição salva)
create or replace function public.perto_garagem(p_uid uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from posicoes p join garagens g
      on (p.x - g.x)^2 + (p.z - g.z)^2 <= g.raio^2
    where p.jogador = p_uid and p.atualizado_em > now() - interval '2 minutes')
$$;

-- primeiro veículo: grátis, escolhido no início do jogo
create or replace function public.primeiro_veiculo(p_modelo text) returns bigint
language plpgsql security definer set search_path = public as $$
declare v_id bigint; c veiculos_catalogo;
begin
  if auth.uid() is null then raise exception 'Entre na sua conta'; end if;
  if exists (select 1 from veiculos_jogador where dono = auth.uid()) then
    raise exception 'Você já tem veículo: compre outros na garagem'; end if;
  select * into c from veiculos_catalogo where id = p_modelo;
  if c.id is null or c.tipo = 'carreta' or (c.status <> 'publico' and not eh_admin()) then
    raise exception 'Veículo indisponível'; end if;
  insert into veiculos_jogador (dono, modelo) values (auth.uid(), p_modelo) returning id into v_id;
  update perfis set veiculo_ativo = v_id where id = auth.uid();
  return v_id;
end $$;

-- comprar na garagem
create or replace function public.comprar_veiculo(p_modelo text) returns bigint
language plpgsql security definer set search_path = public as $$
declare v_id bigint; c veiculos_catalogo; adm boolean := eh_admin();
begin
  if auth.uid() is null then raise exception 'Entre na sua conta'; end if;
  select * into c from veiculos_catalogo where id = p_modelo;
  if c.id is null or (c.status <> 'publico' and not adm) then raise exception 'Veículo indisponível'; end if;
  if exists (select 1 from veiculos_jogador where dono = auth.uid() and modelo = p_modelo) then
    raise exception 'Você já tem esse veículo'; end if;
  if not adm and not perto_garagem(auth.uid()) then raise exception 'Vá até uma garagem para comprar'; end if;
  if not adm then
    update perfis set dinheiro = dinheiro - c.preco where id = auth.uid() and dinheiro >= c.preco;
    if not found then raise exception 'Dinheiro insuficiente'; end if;
    insert into historico (jogador, tipo, descricao, valor) values (auth.uid(), 'gasto', 'Compra: ' || c.nome, -c.preco);
  end if;
  insert into veiculos_jogador (dono, modelo) values (auth.uid(), p_modelo) returning id into v_id;
  return v_id;
end $$;

-- trocar de veículo (só na garagem; o administrador troca em qualquer lugar)
create or replace function public.trocar_veiculo(p_veiculo bigint) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not exists (select 1 from veiculos_jogador where id = p_veiculo and dono = auth.uid()) then
    raise exception 'Esse veículo não é seu'; end if;
  if not eh_admin() and (select veiculo_ativo from perfis where id = auth.uid()) is not null
     and not perto_garagem(auth.uid()) then
    raise exception 'Vá até uma garagem para trocar de veículo'; end if;
  update perfis set veiculo_ativo = p_veiculo where id = auth.uid();
end $$;

-- receber pagamento de frete/linha (com limites contra trapaça)
create or replace function public.receber(p_tipo text, p_valor integer, p_desc text) returns bigint
language plpgsql security definer set search_path = public as $$
declare novo bigint;
begin
  if auth.uid() is null then raise exception 'Entre na sua conta'; end if;
  if p_tipo not in ('frete','linha') or p_valor < 1 or p_valor > 20000 then raise exception 'Valor inválido'; end if;
  if exists (select 1 from historico where jogador = auth.uid() and tipo in ('frete','linha')
             and criado_em > now() - interval '45 seconds') then
    raise exception 'Pagamento repetido'; end if;
  insert into historico (jogador, tipo, descricao, valor) values (auth.uid(), p_tipo, left(p_desc, 120), p_valor);
  update perfis set dinheiro = dinheiro + p_valor where id = auth.uid() returning dinheiro into novo;
  return novo;
end $$;

-- gastar (combustível, oficina, guincho)
create or replace function public.gastar(p_valor integer, p_motivo text) returns bigint
language plpgsql security definer set search_path = public as $$
declare novo bigint;
begin
  if auth.uid() is null then raise exception 'Entre na sua conta'; end if;
  if p_valor < 1 then raise exception 'Valor inválido'; end if;
  update perfis set dinheiro = dinheiro - p_valor where id = auth.uid() and dinheiro >= p_valor
    returning dinheiro into novo;
  if novo is null then raise exception 'Dinheiro insuficiente'; end if;
  insert into historico (jogador, tipo, descricao, valor) values (auth.uid(), 'gasto', left(p_motivo, 120), -p_valor);
  return novo;
end $$;

-- =====================================================================
--  SEGURANÇA (RLS) — cada jogador só mexe no que é dele
-- =====================================================================
alter table public.perfis            enable row level security;
alter table public.veiculos_catalogo enable row level security;
alter table public.garagens          enable row level security;
alter table public.veiculos_jogador  enable row level security;
alter table public.posicoes          enable row level security;
alter table public.historico         enable row level security;
alter table public.ajustes           enable row level security;

-- perfis: todos veem os nomes; dinheiro/admin só mudam pelas funções acima
drop policy if exists perfis_ler on public.perfis;
create policy perfis_ler on public.perfis for select to authenticated using (true);
drop policy if exists perfis_admin on public.perfis;
create policy perfis_admin on public.perfis for update to authenticated using (eh_admin()) with check (eh_admin());

-- catálogo: público para todos; beta/oculto só para o administrador
drop policy if exists cat_ler on public.veiculos_catalogo;
create policy cat_ler on public.veiculos_catalogo for select using (status = 'publico' or eh_admin());
drop policy if exists cat_admin on public.veiculos_catalogo;
create policy cat_admin on public.veiculos_catalogo for all to authenticated using (eh_admin()) with check (eh_admin());

-- garagens: todos leem; só o administrador muda
drop policy if exists gar_ler on public.garagens;
create policy gar_ler on public.garagens for select using (true);
drop policy if exists gar_admin on public.garagens;
create policy gar_admin on public.garagens for all to authenticated using (eh_admin()) with check (eh_admin());

-- veículos do jogador: todos veem (para mostrar a skin dos outros);
-- o dono só altera estado e pintura (compra/troca é pelas funções)
drop policy if exists vj_ler on public.veiculos_jogador;
create policy vj_ler on public.veiculos_jogador for select to authenticated using (true);
drop policy if exists vj_dono on public.veiculos_jogador;
create policy vj_dono on public.veiculos_jogador for update to authenticated
  using (dono = auth.uid()) with check (dono = auth.uid());
revoke insert, update, delete on public.veiculos_jogador from authenticated, anon;
grant update (pintura, skin_url, km, combustivel, motor, pneus, freios, lataria)
  on public.veiculos_jogador to authenticated;

-- posições: todos veem; cada um grava a própria
drop policy if exists pos_ler on public.posicoes;
create policy pos_ler on public.posicoes for select to authenticated using (true);
drop policy if exists pos_ins on public.posicoes;
create policy pos_ins on public.posicoes for insert to authenticated with check (jogador = auth.uid());
drop policy if exists pos_upd on public.posicoes;
create policy pos_upd on public.posicoes for update to authenticated using (jogador = auth.uid()) with check (jogador = auth.uid());

-- histórico: cada um vê o seu (gravação só pelas funções)
drop policy if exists hist_ler on public.historico;
create policy hist_ler on public.historico for select to authenticated using (jogador = auth.uid() or eh_admin());

-- ajustes: todos leem; só o administrador grava
drop policy if exists aj_ler on public.ajustes;
create policy aj_ler on public.ajustes for select using (true);
drop policy if exists aj_admin on public.ajustes;
create policy aj_admin on public.ajustes for all to authenticated using (eh_admin()) with check (eh_admin());

-- quem pode chamar cada função
revoke execute on function public.perto_garagem(uuid) from public, anon, authenticated;
grant execute on function public.usuario_livre(text) to anon, authenticated;
grant execute on function public.eh_admin(), public.primeiro_veiculo(text), public.comprar_veiculo(text),
  public.trocar_veiculo(bigint), public.receber(text, integer, text), public.gastar(integer, text) to authenticated;

-- =====================================================================
--  STORAGE — imagens das skins (todos veem; cada um grava na sua pasta)
-- =====================================================================
insert into storage.buckets (id, name, public) values ('skins', 'skins', true)
on conflict (id) do nothing;

drop policy if exists skins_ler on storage.objects;
create policy skins_ler on storage.objects for select using (bucket_id = 'skins');
drop policy if exists skins_gravar on storage.objects;
create policy skins_gravar on storage.objects for insert to authenticated
  with check (bucket_id = 'skins' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists skins_trocar on storage.objects;
create policy skins_trocar on storage.objects for update to authenticated
  using (bucket_id = 'skins' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists skins_apagar on storage.objects;
create policy skins_apagar on storage.objects for delete to authenticated
  using (bucket_id = 'skins' and (storage.foldername(name))[1] = auth.uid()::text);

-- =====================================================================
--  DEPOIS DE CRIAR SUA CONTA NO JOGO: troque SEU_USUARIO e rode só esta linha
-- =====================================================================
-- update public.perfis set admin = true where usuario = 'SEU_USUARIO';
