-- SimulaBr · atualização 4: ajuste de suspensão do administrador
alter table public.ajustes drop constraint if exists ajustes_tipo_check;
alter table public.ajustes add constraint ajustes_tipo_check check (tipo in ('lanterna','farol','suspensao'));
