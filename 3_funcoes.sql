-- (A) Função que retorna o endereço completo de um cliente, dado o id.
CREATE OR REPLACE FUNCTION obterEnderecoCliente(cliente_id INTEGER)
RETURNS TEXT
AS $$
  SELECT e.rua || ', ' || e.numero || ' ' || e.complemento || ', ' || e.cep || ', ' || e.cidade || ', ' || e.pais 
  FROM endereco e
  WHERE e.cliente_id = cliente_id;
$$
LANGUAGE SQL;

-- (B) Função que retorna a quantidade total de um produto em estoque em todas as localizações.
CREATE FUNCTION quantidadeProdutoEmTodasAsLocalizacoes( produtoParametro INTEGER )
RETURNS bigint AS $$
	SELECT SUM(i.quantidade) FROM Inventario AS i
	WHERE i.produto_id = produtoParametro
$$ LANGUAGE SQL;

-- (C) Função que retorna a média de preço de todos os produtos vendidos em um determinado mês/ano.
CREATE FUNCTION mediaPreco (data VARCHAR) RETURNS NUMERIC AS $$
	SELECT AVG(i.preco) FROM itempedido i, pedido p
	WHERE i.pedido_id = p.pedido_id AND TO_CHAR(p.datapedido, 'YYYY-MM') = data;
$$ LANGUAGE SQL;

-- (D) Função que retorna a quantidade de produtos vendidos em um determinado mês/ano.
CREATE OR REPLACE FUNCTION obterQuantidadeProdutosVendidos(mes INTEGER, ano INTEGER)
RETURNS INTEGER
AS $$
  SELECT SUM(ip.quantidade)
  FROM itempedido ip
  JOIN pedido p ON ip.pedido_id = p.pedido_id
  WHERE EXTRACT(MONTH FROM p.datapedido) = mes AND EXTRACT(YEAR FROM p.datapedido) = ano;
$$
LANGUAGE SQL;

-- (E) Função que retorna o cliente que mais comprou em um determinado período.
CREATE FUNCTION clienteComMaisComprasEmUmPeriodo( inicio DATE , fim DATE )
RETURNS int AS $$
	SELECT p.cliente_id FROM Pedido AS p
	WHERE inicio <= p.datapedido AND fim >= p.datapedido
	GROUP BY p.cliente_id
    ORDER BY count(*) DESC LIMIT 1
$$ LANGUAGE SQL ;

-- (F) Função que retorna todos os pedidos de todos os usuario partir do primeiro nome.
CREATE FUNCTION clienteStatus (n VARCHAR) RETURNS TABLE (nome CHAR(50), sobrenome CHAR(50), pedido_id INTEGER, status VARCHAR(50)) AS $$
	SELECT c.nome, c.sobrenome, p.pedido_id, p.status FROM cliente c, pedido p
	WHERE c.cliente_id = p.cliente_id AND c.nome = n;
$$ LANGUAGE SQL;
