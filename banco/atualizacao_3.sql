-- SimulaBr · atualização 3: skins oficiais (só o administrador cria; jogador compra e escolhe)
create table if not exists public.skins_oficiais (
  id         bigserial primary key,
  modelo     text not null,                 -- veículo dessa skin (ex.: rodoviario_g7)
  nome       text not null,
  url        text not null,                 -- imagem no Storage (bucket skins/oficial/...)
  status     text not null default 'beta' check (status in ('beta','publico','oculto')),
  preco      integer not null default 0 check (preco >= 0),
  padrao     boolean not null default false, -- skin de fábrica do veículo
  criado_em  timestamptz not null default now()
);
create index if not exists skins_modelo_idx on public.skins_oficiais (modelo);
create table if not exists public.skins_jogador (
  dono       uuid not null references public.perfis on delete cascade,
  skin       bigint not null references public.skins_oficiais on delete cascade,
  comprado_em timestamptz not null default now(),
  primary key (dono, skin)
);
alter table public.veiculos_jogador add column if not exists skin_id bigint references public.skins_oficiais on delete set null;

alter table public.skins_oficiais enable row level security;
alter table public.skins_jogador  enable row level security;
drop policy if exists sk_ler on public.skins_oficiais;
create policy sk_ler on public.skins_oficiais for select using (status = 'publico' or padrao or eh_admin());
drop policy if exists sk_admin on public.skins_oficiais;
create policy sk_admin on public.skins_oficiais for all to authenticated using (eh_admin()) with check (eh_admin());
drop policy if exists skj_ler on public.skins_jogador;
create policy skj_ler on public.skins_jogador for select to authenticated using (dono = auth.uid() or eh_admin());

-- comprar skin (dinheiro do jogo)
create or replace function public.comprar_skin(p_skin bigint) returns bigint
language plpgsql security definer set search_path = public as $$
declare s skins_oficiais; novo bigint; adm boolean := eh_admin();
begin
  if auth.uid() is null then raise exception 'Entre na sua conta'; end if;
  select * into s from skins_oficiais where id = p_skin;
  if s.id is null or (s.status <> 'publico' and not adm) then raise exception 'Skin indisponível'; end if;
  if exists (select 1 from skins_jogador where dono = auth.uid() and skin = p_skin) then raise exception 'Você já tem essa skin'; end if;
  if not adm and s.preco > 0 and not s.padrao then
    update perfis set dinheiro = dinheiro - s.preco where id = auth.uid() and dinheiro >= s.preco returning dinheiro into novo;
    if novo is null then raise exception 'Dinheiro insuficiente'; end if;
    insert into historico (jogador, tipo, descricao, valor) values (auth.uid(), 'gasto', 'Skin: ' || s.nome, -s.preco);
  end if;
  insert into skins_jogador (dono, skin) values (auth.uid(), p_skin);
  return coalesce(novo, (select dinheiro from perfis where id = auth.uid()));
end $$;

-- usar skin num veículo (null = sem skin / padrão)
create or replace function public.usar_skin(p_veiculo bigint, p_skin bigint) returns void
language plpgsql security definer set search_path = public as $$
declare v veiculos_jogador; s skins_oficiais;
begin
  select * into v from veiculos_jogador where id = p_veiculo and dono = auth.uid();
  if v.id is null then raise exception 'Esse veículo não é seu'; end if;
  if p_skin is not null then
    select * into s from skins_oficiais where id = p_skin;
    if s.id is null or s.modelo <> v.modelo then raise exception 'Essa skin não serve neste veículo'; end if;
    if not s.padrao and not eh_admin() and not exists (select 1 from skins_jogador where dono = auth.uid() and skin = p_skin) then
      raise exception 'Compre a skin antes'; end if;
  end if;
  update veiculos_jogador set skin_id = p_skin where id = p_veiculo;
end $$;
grant execute on function public.comprar_skin(bigint), public.usar_skin(bigint, bigint) to authenticated;
grant update (pintura, skin_url, km, combustivel, motor, pneus, freios, lataria) on public.veiculos_jogador to authenticated;

-- imagens das skins oficiais: só o administrador envia (pasta oficial/)
drop policy if exists skins_admin on storage.objects;
create policy skins_admin on storage.objects for all to authenticated
  using (bucket_id = 'skins' and eh_admin()) with check (bucket_id = 'skins' and eh_admin());
