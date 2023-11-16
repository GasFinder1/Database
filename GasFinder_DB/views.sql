create view if not exists dados_posto as
select p.id_posto,
	p.cnpj,
	p.nome_posto,
	p.endereco,
	p.cep,
	p.municipio,
	p.bandeira,
	p.numero,
	p.bairro,
	e.uf,
	e.estado,
	prc.valor,
	tc.nome_combustivel,
	tc.unid_medida,
	prc.data_informacao
from  tbl_posto as p,
	tbl_preco as prc,
	tbl_tipo_combustivel as tc,
	tbl_estado as e
where p.id_posto = prc.fk_id_posto
	and prc.fk_id_tipo_combustivel = tc.id_combustivel
	and p.uf = e.id_estado
order by p.id_posto;

create view if not exists localizacao_dados_posto as
select tlp.place_ID,
	p.id_posto,
	p.cnpj,
	p.nome_posto,
	p.endereco,
	p.cep,
	p.municipio,
	p.bandeira,
	p.numero,
	p.bairro,
	e.uf,
	e.estado,
	prc.valor,
	tc.nome_combustivel,
	tc.unid_medida,
	prc.data_informacao
from tbl_localizacao_posto as tlp,
	tbl_posto as p,
	tbl_preco as prc,
	tbl_tipo_combustivel as tc,
	tbl_estado as e
where tlp.fk_id_posto = p.id_posto	
	and p.id_posto = prc.fk_id_posto	
	and prc.fk_id_tipo_combustivel = tc.id_combustivel	
	and p.uf = e.id_estado
order by p.id_posto;