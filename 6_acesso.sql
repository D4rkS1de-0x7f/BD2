-- (A) Crie um dois usuários: gerente e cliente;
CREATE USER GERENTE WITH PASSWORD 'Pass345x';
CREATE USER CLIENTE WITH PASSWORD 'Pass128y';

-- (B) Conceda privilégios de leitura e escrita para o usuário "gerente" na tabela de inven- tário e na tabela de pedidos.
GRANT SELECT, UPDATE
ON Inventario, Pedido
TO GERENTE;

-- (C) Revogar o privilégio de leitura e escrita das tabelas de inventário para o usuário “cliente”.
CREATE USER CLIENTE WITH PASSWORD 'Pass128y';
GRANT SELECT, UPDATE, INSERT ON Inventario TO CLIENTE;
REVOKE ALL ON Inventario FROM CLIENTE;

-- (D) Cria view para acesso a dados dos produtos e revoga acesso do cliente às tabelas inventario e pedido.
CREATE VIEW produtosDisponiveis AS
SELECT p.nome, p.preco
FROM Produto p
INNER JOIN Inventario i ON p.produto_id = i.produto_id
WHERE i.quantidade > 0;

CREATE USER CLIENTE WITH PASSWORD 'Pass128y';
GRANT SELECT ON produtosDisponiveis TO CLIENTE;

REVOKE SELECT, INSERT, UPDATE, DELETE ON Inventario FROM CLIENTE;
REVOKE SELECT, INSERT, UPDATE, DELETE ON Pedido FROM CLIENTE;

