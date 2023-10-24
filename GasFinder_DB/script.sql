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
	fk_id_posto int not null,
	fk_id_combustivel int not null,
	ultimo_valor float not null,
	dt_atualizacao date not null,
	foreign key (fk_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_combustivel) references tbl_tipo_combustivel(id_combustivel)
);

create table tbl_localizacao_posto (
    id_tlc INT not null auto_increment primary key,
    lat double not null,
    lon double not null,
    media_ava_atendimento double,
    media_ava_posto double,
    media_ava_produto double,
    fk_id_posto int,
    foreign key(fk_id_posto) references tbl_posto(id_posto),
	unique key unique_lat_lon (lat, lon)
);

create table tbl_favoritos (
	id_favorito int primary key auto_increment,
	FK_id_usuario int,
	FK_id_posto int(11),
	foreign key(FK_id_posto) references tbl_posto(id_posto),
	foreign key(fk_id_usuario) references tbl_usuario(id_usuario)
);

create table tbl_avaliacao (
    av_posto int,
    qualidade_prod int,
    qualidade_atendimento int,
    dt_ava date not null,
    fk_id_tlc int not null,
    fk_id_usuario int not null,
    foreign key(fk_id_tlc) references tbl_localizacao_posto(id_tlc),
    foreign key(fk_id_usuario) references tbl_usuario(id_usuario)
); 

create table tbl_comentario (
    comentario varchar(500),
    dt_comentario date,
    fk_id_tlc int not null,
    fk_id_usuario int not null,
    foreign key(fk_id_tlc) references tbl_localizacao_posto(id_tlc),
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

-- | ====================== PROCEDURES ====================== | -- 

DELIMITER $
CREATE PROCEDURE InserirPostoELocalizacao(
	IN latitude DECIMAL(10, 6), 
	IN longitude DECIMAL(10, 6), 
	IN id int, 
	OUT msg varchar(100)
)
BEGIN
	DECLARE contador INT;
    DECLARE novo_posto_id INT;
    SET contador = 0;
    SELECT COUNT(*) INTO contador FROM tbl_localizacao_posto WHERE lat = latitude AND lon = longitude;
    IF contador = 0 THEN
		IF id = 0 THEN
			INSERT INTO tbl_posto (CNPJ) VALUES (0);
			SET novo_posto_id = LAST_INSERT_ID();
			INSERT INTO tbl_localizacao_posto (fk_id_posto, lat, lon) VALUES (novo_posto_id, latitude, longitude);
		ELSE
			SET msg = "essa mensagem não deveria aparecer!";
			SELECT COUNT(*) INTO contador FROM tbl_posto WHERE id_posto = id;
            IF contador >= 1 THEN
				INSERT INTO tbl_localizacao_posto (fk_id_posto, lat, lon) VALUES (id, latitude, longitude);
                SET msg = "tudo ocorreu certo";
			ELSE
				SET msg = "o posto não existe";
            END IF;
		END IF;
	ELSE
		SET msg = "posto já cadastrado!";
    END IF;
END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE pr_avaliacao(
	IN usuario INT,
	IN posto INT,
	IN avaliacao_posto INT,
	IN avaliacao_produto INT,
	IN avaliacao_atendimento INT,
	IN opiniao_usuario VARCHAR(500),
	OUT msg VARCHAR(100)
)
BEGIN
	DECLARE m_pos DOUBLE;
	DECLARE m_pro DOUBLE;
	DECLARE m_ate DOUBLE;
	SET m_pos = 0;
	SET m_pro = 0;
	SET m_ate = 0;
    IF avaliacao_posto >= 0 AND avaliacao_posto <= 5 
    AND avaliacao_produto >= 0 AND avaliacao_produto <= 5 
    AND avaliacao_atendimento >= 0 AND avaliacao_atendimento <= 5 THEN
        IF EXISTS (SELECT 1 FROM tbl_usuario WHERE id_usuario = usuario) THEN
            IF EXISTS (SELECT 1 FROM tbl_localizacao_posto WHERE id_tlc = posto) THEN
                IF EXISTS (SELECT 1 FROM tbl_avaliacao WHERE fk_id_tlc = posto AND fk_id_usuario = usuario AND (av_posto <> avaliacao_posto OR qualidade_prod <> avaliacao_produto OR qualidade_atendimento <> avaliacao_atendimento)) THEN
					UPDATE tbl_avaliacao
					SET av_posto = avaliacao_posto, 
					qualidade_prod = avaliacao_produto,
					qualidade_atendimento = avaliacao_atendimento,
					dt_ava = CURDATE()
					WHERE fk_id_tlc = posto AND fk_id_usuario = usuario;
					IF (SELECT ROW_COUNT()) = 0 THEN
						SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao atualizar os dados de avaliação';
					END IF;
					SET msg = "avaliação atualizada";
                ELSE
                    INSERT INTO tbl_avaliacao(av_posto, qualidade_prod, qualidade_atendimento, dt_ava, fk_id_tlc, fk_id_usuario)
                    VALUES (avaliacao_posto, avaliacao_produto, avaliacao_atendimento, CURDATE(), posto, usuario);
					IF (SELECT ROW_COUNT()) = 0 THEN
						SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao inserir os dados de avaliação';
					END IF;
					SET msg = "avaliação inserida";
                END IF;
				SELECT AVG(COALESCE(qualidade_prod, -1)) AS m_pro,
						AVG(COALESCE(qualidade_atendimento, -1)) AS m_ate,
						AVG(COALESCE(av_posto, -1)) AS m_pos
					INTO m_pro, m_ate, m_pos
					FROM tbl_avaliacao;
				UPDATE tbl_localizacao_posto
					SET media_ava_atendimento = m_ate,
					media_ava_posto = m_pos,
					media_ava_produto = m_pro
				WHERE id_tlc = posto;
				
                IF opiniao_usuario IS NOT NULL AND opiniao_usuario != "" THEN
                    IF EXISTS (SELECT 1 FROM tbl_comentario WHERE fk_id_tlc = posto AND fk_id_usuario = usuario AND comentario <> opiniao_usuario) THEN
                        UPDATE tbl_comentario
                        SET comentario = opiniao_usuario, 
                        dt_comentario = CURDATE()
                        WHERE fk_id_tlc = posto AND fk_id_usuario = usuario;
						IF (SELECT ROW_COUNT()) = 0 THEN
							SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao atualizar o comentario';
						END IF;
                    ELSE
                        INSERT INTO tbl_comentario(comentario, dt_comentario, fk_id_tlc, fk_id_usuario)
                        VALUES (opiniao_usuario, CURDATE(), posto, usuario);
						IF (SELECT ROW_COUNT()) = 0 THEN
							SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao inserir o comentario';
						END IF;
                    END IF;
                END IF;
            ELSE
                SET msg = "posto inexistente";
                SIGNAL SQLSTATE '23000' SET MESSAGE_TEXT = 'Erro ao inserir na tabela de avaliação, posto inexistente';
            END IF;
        ELSE
            SET msg = "usuario inexistente";
            SIGNAL SQLSTATE '23000' SET MESSAGE_TEXT = 'Erro ao inserir na tabela de avaliação, usuario inexistente';
        END IF;
    ELSE
        SET msg = "valores de avaliacao fora do escopo";
    END IF;
END $
DELIMITER ;
