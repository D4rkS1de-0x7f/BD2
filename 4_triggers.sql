DROP TRIGGER IF EXISTS criarOuDeletarItemPedido ON ItemPedido;
DROP FUNCTION IF EXISTS incrementarPrecoTotal;
DROP TRIGGER IF EXISTS produtoEstaComEntregaPendente ON Produto;
DROP FUNCTION IF EXISTS avisoDeleteOnProduto;
DROP TRIGGER IF EXISTS verificaQuantidade ON ItemPedido;
DROP FUNCTION IF EXISTS verificaQuantidadeDisponivel;

-- (A) Trigger que verifica se a quantidade de um produto no inventário é suficiente 
-- para um pedido antes de permitir sua inserção na tabela de itens de pedido.
CREATE OR REPLACE FUNCTION verificaQuantidadeDisponivel()
RETURNS TRIGGER AS $$
DECLARE
    total_qtd INTEGER;
BEGIN
    SELECT SUM(quantidade) INTO total_qtd
    FROM Inventario
    WHERE produto_id = NEW.produto_id;

    IF total_qtd < NEW.quantidade THEN
        RAISE EXCEPTION 'Quantidade excede a disponível no inventário.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificaQuantidade
BEFORE INSERT ON ItemPedido
FOR EACH ROW
EXECUTE PROCEDURE verificaQuantidadeDisponivel();


-- (B) Trigger que atualiza o preço total de um pedido automaticamente 
-- toda vez que um item é adicionado ou removido do pedido.
CREATE OR REPLACE FUNCTION incrementarPrecoTotal()
RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'INSERT' THEN
		UPDATE Pedido SET precototal = precototal + NEW.preco * NEW.quantidade WHERE pedido_id = NEW.pedido_id;
		RETURN NEW;
	ELSIF TG_OP = 'DELETE' THEN
		UPDATE Pedido SET precototal = precototal - OLD.preco * OLD.quantidade WHERE pedido_id = OLD.pedido_id;
		RETURN OLD;
	END IF;
	RETURN NULL;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER criarOuDeletarItemPedido
AFTER INSERT OR DELETE ON ItemPedido
FOR EACH ROW
EXECUTE PROCEDURE incrementarPrecoTotal();

-- (C) Trigger que impede a remoção de um produto da tabela de produtos caso
-- ainda existam itens desse produto em pedidos não entregues.
CREATE OR REPLACE FUNCTION avisoDeleteOnProduto()
RETURNS TRIGGER AS $$
BEGIN
	IF Pr.produto_id = ANY(SELECT I.produto_id 
			FROM ItemPedido AS I, Produto AS Pr, Pedido AS P 
			WHERE P.status = 'Pendente' AND I.produto_id = OLD.produto_id AND I.pedido_id = P.pedido_id) 
			FROM Produto AS Pr
			WHERE Pr.produto_id = OLD.produto_id THEN
		RAISE EXCEPTION 'Nao eh permitido % para Produto que tenha entrega pendente' , TG_OP;
	END IF;
	RETURN NULL;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER produtoEstaComEntregaPendente
BEFORE DELETE ON Produto
FOR EACH ROW
EXECUTE PROCEDURE avisoDeleteOnProduto();

-- (D) Trigger notifica quando um novo pedido é criado.
CREATE OR REPLACE FUNCTION nova_notificacao() RETURNS TRIGGER AS $$
	BEGIN
		RAISE NOTICE 'novo pedido criado! (%, %, %, %, %)', TG_NAME, TG_LEVEL, TG_WHEN, TG_OP, TG_TABLE_NAME;
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER nova_notificacao_insercao AFTER INSERT ON Pedido
FOR EACH ROW 
EXECUTE PROCEDURE nova_notificacao();

INSERT INTO Pedido(cliente_id, datapedido, status) 
VALUES (1, '2023-05-01', 'Pendente');

-- (E) Gera uma notificação referente a novas atualizações no inventário,
CREATE OR REPLACE FUNCTION notificacao_inventario() RETURNS TRIGGER AS $$
	BEGIN
		RAISE NOTICE 'nova atualizacao no inventario! (%, %, %, %, %)', TG_NAME, TG_LEVEL, TG_WHEN, TG_OP, TG_TABLE_NAME;
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER nova_notificacao_inventario
AFTER UPDATE ON Inventario
FOR EACH ROW
EXECUTE PROCEDURE notificacao_inventario();

UPDATE Inventario 
set quantidade = 700
where localizacao_id = 3 and produto_id = 2;
