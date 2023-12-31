select * from tbl_posto;
select * from tbl_preco;
select * from dados_posto where id_posto = 1;

insert into tbl_posto(cnpj) values(0);

-- procedure: insere posto pelas coordenadas
-- call InserirPostoELocalizacao(place_ID, id_posto(0 para "criar um posto"), saida_texto);
call InserirPostoELocalizacao("ChIJ4TOHb2mrz5QRqMCRPyacgwk", 100, @msg);
select @msg;
call InserirPostoELocalizacao("ChIJ4TOHb2mrz5QRqMCRPyacgwk1", 0, @msg);
select @msg;
select * from tbl_localizacao_posto;
select * from localizacao_dados_posto;
SELECT * FROM localizacao_dados_posto WHERE (latitude BETWEEN -23.596331819704066 AND -23.686263980295937 OR latitude BETWEEN -23.686263980295937 AND -23.596331819704066) AND (longitude BETWEEN -46.78685635417169 AND -46.885027645828316 OR longitude BETWEEN -46.885027645828316 AND -46.78685635417169);
select * from localizacao_dados_posto;

-- procedure: avaliação de posto, produto e atendimento e comentário  */
insert into tbl_usuario(nome_usuario, email, senha) values("teste", "teste@gmail.com", "123456789");
insert into tbl_usuario(nome_usuario, email, senha) values("teste2", "teste2@gmail.com", "123456789");

-- call pr_avaliacao(fk_id_usuario, fk_place_ID, av_posto(0-5), av_produto(0-5), av_atendimento(0-5), opinião_texto, saida_texto);
call pr_avaliacao(1, "ChIJ4TOHb2mrz5QRqMCRPyacgwk", 5, 5, 5, "", @msg);
call pr_avaliacao(2, "ChIJ4TOHb2mrz5QRqMCRPyacgwk", 5, 5, 5, "gostei do posto", @msg);

call getEvaluation("ChIJ4TOHb2mrz5QRqMCRPyacgwk", 1);

select * from tbl_avaliacao;
select * from tbl_comentario;



-- procedure: insere preço passando valores de cnpj, tipo de combustivel, valor_novo
call prc_verifica_preco('02086208000109', 5, 5.99);
select * from tbl_preco;
select * from tbl_historico_preco;
select * from tbl_tipo_combustivel;


call pr_avaliacao(1, 'ChIJ4TOHb2mrz5QRqMCRPyacgwk', 5, 5, 5, "gostei do posto", @msg);
call getEvaluation('ChIJ4TOHb2mrz5QRqMCRPyacgwk', 1);



select * from tbl_usuario;
select * from tbl_localizacao_posto where place_ID = "ChIJ4TOHb2mrz5QRqMCRPyacgwk";
select * from localizacao_dados_posto;
SELECT * FROM localizacao_dados_posto WHERE place_ID = "ChIJ4TOHb2mrz5QRqMCRPyacgwk";
select * from tbl_avaliacao;

select * from tbl_avaliacao where fk_id_tlp = 1 and fk_id_usuario = 1 and (av_posto <> 5 OR qualidade_prod <> 5 OR qualidade_atendimento <> 5);

select * from tbl_avaliacao where fk_id_tlp = 1 and fk_id_usuario = 1 and (av_posto <> 5 OR qualidade_prod <> 5 OR qualidade_atendimento <> 5);

select * from tbl_usuario;
select * from tbl_colaborativa;
