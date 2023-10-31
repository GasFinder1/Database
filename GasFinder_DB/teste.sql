select * from tbl_posto;
select * from dados_posto where id_posto = 1;

-- procedure: insere posto pelas coordenadas
-- call InserirPostoELocalizacao(place_ID, id_posto(0 para "criar um posto"), saida_texto);
call InserirPostoELocalizacao(5467897654897, 2, @msg);
call InserirPostoELocalizacao(4567865435678, 0, @msg);
select * from tbl_localizacao_posto;
select * from localizacao_dados_posto;

-- procedure: avaliação de posto, produto e atendimento e comentário  */
insert into tbl_usuario(nome_usuario, email, senha) values("teste", "teste@gmail.com", "123456789");
insert into tbl_usuario(nome_usuario, email, senha) values("teste2", "teste2@gmail.com", "123456789");

-- call pr_avaliacao(fk_id_usuario, fk_place_ID, av_posto(0-5), av_produto(0-5), av_atendimento(0-5), opinião_texto, saida_texto);
call pr_avaliacao(1, "ChIJ4TOHb2mrz5QRqMCRPyacgwk", 5, 5, 5, "", @msg);
call pr_avaliacao(2, "ChIJ4TOHb2mrz5QRqMCRPyacgwk", 5, 5, 5, "gostei do posto", @msg);
select * from tbl_avaliacao;
select * from tbl_comentario;

-- procedure: insere preço passando valores de cnpj, tipo de combustivel, valor_novo
call prc_verifica_preco('02086208000109', 5, 5.99);
select * from tbl_preco;
select * from tbl_historico_preco;
select * from tbl_tipo_combustivel;

select * from tbl_usuario;