create database gasfinder;
use gasfinder;

create table tbl_estado (
	id_estado int primary key auto_Increment,
	estado varchar(50),
	uf varchar(2)
);

insert into tbl_estado (estado, uf)
values
	('Acre', 'AC'),
	('Alagoas', 'AL'),
	('Amapá', 'AP'),
	('Amazonas', 'AM'),
	('Bahia', 'BA'),
	('Ceará', 'CE'),
	('Distrito Federal', 'DF'),
	('Espírito Santo', 'ES'),
	('Goiás', 'GO'),
	('Maranhão', 'MA'),
	('Mato Grosso', 'MT'),
	('Mato Grosso do Sul', 'MS'),
	('Minas Gerais', 'MG'),
	('Pará', 'PA'),
	('Paraíba', 'PB'),
	('Paraná', 'PR'),
	('Pernambuco', 'PE'),
	('Piauí', 'PI'),
	('Rio de Janeiro', 'RJ'),
	('Rio Grande do Norte', 'RN'),
	('Rio Grande do Sul', 'RS'),
	('Rondônia', 'RO'),
	('Roraima', 'RR'),
	('Santa Catarina', 'SC'),
	('São Paulo', 'SP'),
	('Sergipe', 'SE'),
	('Tocantins', 'TO');

create table tbl_tipo_combustivel (
	id_combustivel int primary key auto_increment,
	nome_combustivel varchar(30) not null,
	unid_medida varchar(10)
);

insert into tbl_tipo_combustivel(nome_combustivel, unid_medida)
values
	("Gasolina", "R$ / litro"),
	("Gasolina Aditivada", "R$ / litro"),
	("Etanol", "R$ / litro"),
	("Diesel S10", "R$ / litro"),
	("Diesel S500", "R$ / litro"),
	("GNV", "R$ / m³");

create table tbl_posto (
	id_posto int primary key auto_increment,
	cnpj varchar(14),
	nome_posto varchar(115) not null,
	endereco varchar(65) not null default "",
	fantasia varchar(65),
	cep varchar(8) not null,
	municipio varchar(45) not null,
	bandeira varchar(45) not null,
	numero int,
	bairro varchar(50),
	complemento varchar(125),
	uf int not null,
	foreign key(uf) references tbl_estado(id_estado)
);

create table tbl_usuario (
	id_usuario int primary key auto_increment,
	nome_usuario varchar(45) not null,
	email varchar(60) not null unique,
	senha varchar(20) not null
);

create table tbl_preco (
	fk_id_posto int not null,
	fk_id_combustivel int not null,
	foreign key(fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_combustivel) references tbl_tipo_combustivel(id_combustivel),
	valor float not null
);

create table tbl_colaborativa (
	valor_inserido float not null,
	dt_atualização date not null,
	fk_id_combustivel int not null,
	fk_id_posto int not null,
	fk_id_usuario int not null,
	foreign key(fk_id_usuario) references tbl_usuario(id_usuario),
	foreign key(fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_combustivel) references tbl_tipo_combustivel(id_combustivel)
);

create table tbl_historico_preco (
	fk_id_posto int auto_increment,
	fk_id_combustivel int not null,
	ultimo_valor float not null,
	dt_atualizacao date not null,
	foreign key(fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_combustivel) references tbl_tipo_combustivel(id_combustivel)
);

create table tbl_localizacao_posto (
	id_tlc INT not null auto_increment primary key,
	lat double not null,
	lon double not null,
	fk_id_posto int,
	foreign key(fk_id_posto) references tbl_posto(id_posto)
);

create table tbl_favoritos (
	id_favorito int primary key auto_increment,
	fk_id_usuario int,
	fk_id_posto int,
	foreign key(fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_usuario) references tbl_usuario(id_usuario)
);

create table tbl_avaliacao (
		-- serão double, pois para avaliar serão utilizadas as 5 estrelas
		av_posto double,
		qualidade_prod double,
    qualidade_atendimento double,
		opiniao varchar (500),
		fk_id_posto int not null,
    fk_id_usuario int not null,
    foreign key(fk_id_posto) references tbl_posto(id_posto),
    foreign key(fk_id_usuario) references tbl_usuario(id_usuario)
); 

-- parceiro irá inserir essas informações no seu cadastro
create table tbl_parceiros (     
	id_parceiro int primary key auto_increment not null,
	cnpj varchar(14) not null,
    nome_parceiro varchar(50) not null,
    ramo varchar(40) not null, -- para poder fazer busca por "mecanica", "borracharia", "auto-eletricas"
    endereco varchar (65) not null default "",
	fantasia varchar (65),
    cep varchar (8) not null,
	municipio varchar (45) not null,
	numero int,
	bairro varchar (50),
	complemento  varchar (125),
    uf int not null,
    foreign key(uf) references tbl_estado(id_estado)
);

-- | ====================== VIEWS ====================== | -- 
create view dados_posto as
select	p.id_posto,	
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
	tc.unid_medida
from 	tbl_posto as p, 
	tbl_preco as prc, 
	tbl_tipo_combustivel as tc, 
	tbl_estado as e
where	p.id_posto = prc.fk_id_posto	
	and prc.fk_id_combustivel = tc.id_combustivel	
	and p.uf = e.id_estado
order by p.id_posto;

create view localizacao_dados_posto as
select	tlp.lat,	
	tlp.lon,	
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
	tc.unid_medida
from	tbl_localizacao_posto as tlp,	
	tbl_posto as p,	
	tbl_preco as prc,	
	tbl_tipo_combustivel as tc,	
	tbl_estado as e
where	tlp.fk_id_posto = p.id_posto	
	and p.id_posto = prc.fk_id_posto	
	and prc.fk_id_combustivel = tc.id_combustivel	
	and p.uf = e.id_estado
order by p.id_posto;


DELIMITER $
create procedure prc_verifica_preco (
	in new_cnpj varchar(14),
	in tipo_comb int,
	in valor_novo double(10, 2)
)
begin
	declare new_id_posto int;
	declare new_id_combustivel int;
	declare valor_atual double(10, 2);
    declare contador int;
	
	/* 
		PEGAR DADOS CADASTRADOS E COLOCAR NAS VARIAVEIS DECLARADAS ACIMA
	*/ 
	-- obtém o ID da tbl_posto com base no parâmetro 'new_cnpj'
	select id_posto into new_id_posto from tbl_posto
	where cnpj = new_cnpj;

	-- obtém o ID da tipo_combusível com base no parâmetro 'tipo_comb'
	select id_combustivel into new_id_combustivel from tbl_tipo_combustivel
	where id_combustivel = tipo_comb;

	-- obtém o valor do combusível com base nos parâmetros 'new_id_posto' e 'new_id_combustivel'
	select valor  into valor_atual from tbl_preco
	where fk_id_posto = new_id_posto and fk_id_combustivel = new_id_combustivel;

	-- conta quantas linhas há na tbl_preco e insere esse valor na variavel 'contador'
	select count(*) into contador from tbl_preco
	where fk_id_posto = new_id_posto and fk_id_combustivel = new_id_combustivel;

	-- se em 	'contador' o valor de linhas for menos que 1, é inserido o valor passado na chamada da procedure  
	-- se ele for maior ou igual a 1 e valor_atual for diferente do valor_novo, atualiza o valor
	if contador < 1 then
			insert into tbl_preco(	fk_id_posto,	fk_id_combustivel,	valor ) 
			values ( new_id_posto, new_id_combustivel, valor_novo );
	else
		if valor_atual <> valor_novo then
			insert into tbl_historico_preco (	fk_id_posto, 	fk_id_combustivel, 	ultimo_valor,	dt_atualizacao ) 
			values (	new_id_posto,	new_id_combustivel, 	valor_atual,	current_timestamp() );
	
			update tbl_preco set valor = valor_novo
			where fk_id_posto = new_id_posto and fk_id_combustivel = new_id_combustivel;
		end if;
	end if ;
end $
DELIMITER ;

/* 
	O seguinte insert na tbl_posto só serve para testar. Se for inserir os postos 
	com o back-end: exclua este insert da tbl_posto, delete o banco, insira os 
	postos (back-end) e só depois chame a procedure.
*/
insert into tbl_posto ( cnpj, nome_posto, endereco, fantasia, cep, municipio, bandeira, numero, bairro, complemento, uf ) 
values ( '2086208000109', 'POSTO URSA MENOR LTDA', 'AVENIDA ROTARY', '', '6816100', 'EMBU DAS ARTES', 'VIBRA', '2991', 'PARQUE LUIZA', '', 25 );

/*
	você pode testar excluir este insert na tbl_preco seguindo a mesma recomendação acima, 
	para testar a condição em que não tem nenhuma linha cadastrada 
	nela e é inserido o valor da chamada da procedure
*/
insert into tbl_preco (	fk_id_posto,	fk_id_combustivel,	valor )
values ( 1, 1, 5.00 );

-- chamada da procedure, passando valores de cnpj, tipo de combustivel, valor_novo
call prc_verifica_preco('02086208000109', 5, 5.99);

-- consulta para constatação de funcionamento da procedure
select*from tbl_preco;
select*from tbl_tipo_combustivel;
select*from tbl_historico_preco;
select*from tbl_posto where municipio='EMBU DAS ARTES';
select*from tbl_posto;
