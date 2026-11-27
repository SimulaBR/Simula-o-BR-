-- SimulaBr · atualização 2 (rodar uma vez no SQL Editor)
-- Urbanos saem da loja (quem já tem continua com eles)
update public.veiculos_catalogo set status = 'oculto' where id in ('urbano', 'urbano_classico');
-- G7 de dois andares novo no lugar do 4 eixos: troca o nome
update public.veiculos_catalogo set nome = 'Rodoviário 4 eixos' where id = 'rodoviario_4e';
-- Novos rodoviários entram como Beta (só o administrador vê; libere no painel)
insert into public.veiculos_catalogo (id, tipo, nome, status, preco) values
  ('rodoviario_g7', 'onibus', 'Rodoviário G7 3 eixos',     'beta', 150000),
  ('rodoviario_01', 'onibus', 'Rodoviário clássico 01', 'beta',  80000),
  ('rodoviario_02', 'onibus', 'Rodoviário clássico 02', 'beta', 100000),
  ('rodoviario_03', 'onibus', 'Rodoviário clássico 03', 'beta',  80000),
  ('rodoviario_04', 'onibus', 'Rodoviário clássico 04', 'beta', 100000),
  ('rodoviario_05', 'onibus', 'Rodoviário clássico 05', 'beta',  80000),
  ('rodoviario_06', 'onibus', 'Rodoviário clássico 06', 'beta', 120000),
  ('rodoviario_09', 'onibus', 'Rodoviário clássico 09', 'beta',  80000)
on conflict (id) do nothing;
