# Banco de dados da aplicação GasFinder

O código contém:
- criação de tabelas;
- criação de views;
- criação de procedures.

Para testá-lo:
- Se o MySQL Workbench (na versão mais recente, de preferência) já estiver instalado em sua máquina, crie uma conexão (ou entre em uma já criada), depois abra o script.sql;
- É possível rodar todas as linhas do código de uma vez, sem apresentar erros relevantes (pode aparecer um erro na chamada da procedure de verificação de preço, mas não afeta a estrura do banco);
- Se quiser, pode testar alguns inserts e consultar as tabelas, para ver se a procedure funciona, por exemplo:

  /* RECOMENDAÇÃO: cole o trecho de código abaixo entre a 'DELIMITER ;' E A 'call prc_verifica_preco()'  */
  
  insert into tbl_posto ( cnpj, nome_posto, endereco, fantasia, cep, municipio, bandeira, numero, bairro, complemento, uf ) 
  values ( '02086208000109', 'POSTO URSA MENOR LTDA', 'AVENIDA ROTARY', '', '06816100', 'EMBU DAS ARTES', 'VIBRA', '2991', 'PARQUE LUIZA', '', 25 );

  /* inserindo esse preço antes de chamar a procedure, você poderá consultar a tabela de histórico de preço, onde são armazenados os valores e a data de atualização*/
  
  insert into tbl_preco (	fk_id_posto,	fk_id_combustivel,	valor )
  values ( 1, 1, 5.00 );
