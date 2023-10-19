create database gasfinder;
use gasfinder;

create table tbl_estado (
	id_estado int primary key auto_Increment,
	estado varchar(50),
	uf varchar(2)
);

INSERT INTO tbl_estado (estado, uf)
VALUES
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
	unid_medida varchar (10)
);

INSERT INTO tbl_tipo_combustivel(nome_combustivel, unid_medida)
VALUES
	("Gasolina", "R$ / litro"),
	("Gasolina Aditivada", "R$ / litro"),
	("Etanol", "R$ / litro"),
	("Diesel S10", "R$ / litro"),
	("Diesel S500", "R$ / litro"),
	("GNV", "R$ / m³");

create table tbl_posto (
	id_posto int primary key auto_increment,
	cnpj varchar (14),
	nome_posto varchar (115) not null,
	endereco varchar (65) not null default "",
	logradouro varchar (65),
	cep varchar (8) not null,
	municipio varchar (45) not null,
	bandeira varchar (45) not null,
	numero int (6),
	bairro varchar (50),
	complemento varchar (125),
	uf int not null,
	foreign key(uf) references tbl_estado(id_estado)
);

create table tbl_usuario (
	id_usuario int primary key auto_increment,
	nome_usuario varchar(45) not null,
	email varchar (60) not null unique,
	senha varchar (20) not null
);

create table tbl_preco (
	fk_id_posto INT NOT NULL,
	fk_id_tipo_combustivel INT NOT NULL,
	foreign key(fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_tipo_combustivel) references tbl_tipo_combustivel(id_combustivel),
	valor FLOAT not null
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
	fk_id_posto int primary key auto_increment,
	fk_id_combustivel int not null,
	ultimo_valor float not null,
	dt_atualizacao date not null,
	foreign key (fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_combustivel) references tbl_tipo_combustivel(id_combustivel)
);

CREATE TABLE tbl_localizacao_posto (
	id_tlc INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	lat DOUBLE not null,
	lon DOUBLE not null,
	fk_id_posto int,
	foreign key(fk_id_posto) references tbl_posto(id_posto)
);

create table tbl_favoritos (
	id_favorito int primary key auto_increment,
	FK_id_usuario int,
	FK_id_posto int(11),
	foreign key(FK_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_usuario) references tbl_usuario(id_usuario)
);

-- | ====================== VIEWS ====================== | -- 
CREATE VIEW dados_posto AS
SELECT	p.id_posto,	
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
FROM 	tbl_posto AS p, 
	tbl_preco AS prc, 
	tbl_tipo_combustivel AS tc, 
	tbl_estado AS e
WHERE	p.id_posto = prc.fk_id_posto	
	AND prc.fk_id_tipo_combustivel = tc.id_combustivel	
	AND p.uf = e.id_estado
ORDER BY p.id_posto;

CREATE VIEW localizacao_dados_posto AS
SELECT	tlp.lat,	
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
FROM	tbl_localizacao_posto AS tlp,	
	tbl_posto AS p,	
	tbl_preco AS prc,	
	tbl_tipo_combustivel AS tc,	
	tbl_estado AS e
WHERE	tlp.fk_id_posto = p.id_posto	
	AND p.id_posto = prc.fk_id_posto	
	AND prc.fk_id_tipo_combustivel = tc.id_combustivel	
	AND p.uf = e.id_estado
ORDER BY	p.id_posto;

DELIMITER $
CREATE PROCEDURE InserirPostoELocalizacao(IN latitude DECIMAL(10, 6), IN longitude DECIMAL(10, 6), IN id int, OUT msg varchar(100))
BEGIN
	DECLARE contador INT;
    DECLARE novo_posto_id INT;
    SET contador = 0;
    SELECT COUNT(*) INTO contador FROM localizacao_posto WHERE lat = latitude AND lon = longitude;
    IF contador = 0 THEN
		IF id = 0 THEN
			INSERT INTO tbl_posto (CNPJ) VALUES (0);
			SET novo_posto_id = LAST_INSERT_ID();
			INSERT INTO localizacao_posto (fk_id_posto, lat, lon) VALUES (novo_posto_id, latitude, longitude);
		ELSE
			SELECT COUNT(*) INTO contador FROM tbl_posto WHERE id_posto = id;
            IF contador < 1 THEN
				INSERT INTO localizacao_posto (fk_id_posto, lat, lon) VALUES (id, latitude, longitude);
            END IF;
        END IF;
    END IF;
END $
DELIMITER ;