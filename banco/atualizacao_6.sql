-- SimulaBr · atualização 6: brilho do farol do G7 DD (1800) menor, só em cima do farol.
-- Diminui o tamanho dos pontos de farol baixo e alto que já estavam salvos para o G7 DD. Pode rodar mais de uma vez.
update public.ajustes a
set dados = jsonb_set(a.dados, '{pontos}', (
  select jsonb_agg(case when p->>'t' in ('farol','alto')
                        then p || jsonb_build_object('w', least(coalesce((p->>'w')::numeric, 0.5), 0.4), 'h', least(coalesce((p->>'h')::numeric, 0.5), 0.4))
                        else p end)
  from jsonb_array_elements(a.dados->'pontos') p))
where a.modelo = 'rodoviario_4e' and a.tipo = 'farol' and jsonb_typeof(a.dados->'pontos') = 'array';
