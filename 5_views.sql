-- Letra (A) View que retorna os dados do cliente juntamente com seu endereço.
DROP VIEW IF EXISTS retorneClienteEndereco;
CREATE OR REPLACE VIEW retorneClienteEndereco(cliente_id, nome, sobrenome, email, telefone, datacadastro, rua, numero, complemento, cep, cidade, pais) AS
SELECT C.cliente_id, C.nome, C.sobrenome, C.email, C.telefone, C.datacadastro, E.rua, E.numero, E.complemento, E.cep, E.cidade, E.pais
FROM Cliente AS C, Endereco AS E
WHERE E.cliente_id = C.cliente_id;


-- (B) View que retorna a quantidade de produtos em cada localização.
-- select l.cep, sum(i.quantidade) from localizacao l, inventario i where l.localizacao_id = i.localizacao_id group by l.cep;
DROP VIEW IF EXISTS view_qtd;
CREATE OR REPLACE VIEW view_qtd (cep, quantidade) AS
SELECT l.cep, SUM(i.quantidade) FROM localizacao l, inventario i WHERE l.localizacao_id = i.localizacao_id GROUP BY l.cep;


-- (C) View que retorna o valor de todas as vendas por mês. OBS: alterado para dia pois todos os dados são do mesmo mês.
DROP VIEW IF EXISTS view_vendas;
CREATE OR REPLACE VIEW view_vendas (data, total_vendas_dia) AS
SELECT p.datapedido, SUM(i.preco) FROM itempedido i, pedido p WHERE i.pedido_id = p.pedido_id GROUP BY datapedido;


-- (D) Para cada localizacao_id em ordem crescente referente aos produtos destinados as lojas.
-- Exibir localização id, nome do produto, descrição e a quantidade referente ao inventário.
DROP VIEW IF EXISTS view_localizacao;
CREATE OR REPLACE VIEW view_localizacao (localizacao_id, nome, descricao, quantidade) AS
SELECT i.localizacao_id, p.nome, p.descricao, i.quantidade FROM produto p, inventario i WHERE p.produto_id = i.produto_id ORDER BY i.localizacao_id;
