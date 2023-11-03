create database if not exists gasfinder;
use gasfinder;

create table if not exists tbl_estado (
	id_estado int primary key auto_Increment,
	estado varchar(50),
	uf varchar(2)
);

create table if not exists tbl_tipo_combustivel (
	id_combustivel int primary key auto_increment,
	nome_combustivel varchar(30) not null,
	unid_medida varchar (10)
);

create table if not exists tbl_posto (
	id_posto int primary key auto_increment,
	cnpj varchar(14),
	nome_posto varchar(115) default "",
	endereco varchar(65) default "",
	fantasia varchar(65) default "",
	cep varchar(8) default "",
	municipio varchar(45) default "",
	bandeira varchar(45) default "",
	numero int(6) default 0,
	bairro varchar(50) default "",
	complemento varchar(125) default "",
	uf int default 28,
	foreign key(uf) references tbl_estado(id_estado)
);

create table if not exists tbl_usuario (
	id_usuario int primary key auto_increment,
	nome_usuario varchar(100) not null,
	email varchar(60) not null unique,
	senha varchar(20) not null,
  dt_cad datetime default current_timestamp(),
  dt_alt datetime default current_timestamp()
);

create table if not exists tbl_preco (
	fk_id_posto int not null,
	fk_id_combustivel int not null,
	foreign key(fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_combustivel) references tbl_tipo_combustivel(id_combustivel),
	valor float not null
);

create table if not exists tbl_colaborativa (
	valor_inserido float not null,
	dt_atualização date not null,
	fk_id_combustivel int not null,
	fk_id_posto int not null,
	fk_id_usuario int not null,
	foreign key(fk_id_usuario) references tbl_usuario(id_usuario),
	foreign key(fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_combustivel) references tbl_tipo_combustivel(id_combustivel),
  unique key combustivel_posto_usuario (fk_id_combustivel, fk_id_posto, fk_id_usuario)
);

create table if not exists tbl_historico_preco (
	fk_id_posto int not null,
	fk_id_combustivel int not null,
	ultimo_valor float not null,
	dt_atualizacao date not null,
	foreign key(fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_combustivel) references tbl_tipo_combustivel(id_combustivel)
);

create table if not exists tbl_localizacao_posto (
	id_tlp int primary key auto_Increment,
	place_ID varchar(150) not null unique,
	media_ava_atendimento double,
	media_ava_posto double,
	media_ava_produto double,
	fk_id_posto int,
	foreign key(fk_id_posto) references tbl_posto(id_posto)
);

create table if not exists tbl_favoritos (
	id_favorito int primary key auto_increment,
	fk_id_usuario int,
	fk_id_tlp int not null,
	foreign key(fk_id_tlp) references tbl_localizacao_posto(id_tlp),
	foreign key(fk_id_usuario) references tbl_usuario(id_usuario),
  unique key unique_user_localizacao_posto (fk_id_usuario, fk_id_tlp)
);

create table if not exists tbl_avaliacao (
	av_posto int,
	qualidade_prod int,
	qualidade_atendimento int,
	dt_ava date not null,
	fk_id_tlp int not null,
	fk_id_usuario int not null,
	foreign key(fk_id_tlp) references tbl_localizacao_posto(id_tlp),
	foreign key(fk_id_usuario) references tbl_usuario(id_usuario),
  unique key unique_user_localizacao_posto (fk_id_usuario, fk_id_tlp)
);

create table if not exists tbl_comentario (
	comentario varchar(500),
	dt_comentario date,
	fk_id_tlp int not null,
	fk_id_usuario int not null,
	foreign key(fk_id_tlp) references tbl_localizacao_posto(id_tlp),
	foreign key(fk_id_usuario) references tbl_usuario(id_usuario),
  unique key unique_user_localizacao_posto (fk_id_usuario, fk_id_tlp)
);

create table if not exists tbl_parceiros (     
	id_parceiro int primary key auto_increment not null,
	cnpj varchar(14) not null,
	nome_parceiro varchar(50) not null,
	ramo varchar(40) not null,
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