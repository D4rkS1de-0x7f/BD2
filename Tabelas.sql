DROP TABLE IF EXISTS Endereco, Inventario, ItemPedido, Pedido, Cliente, Produto, Localizacao CASCADE;

CREATE TABLE Cliente(
	cliente_id serial primary key,
	nome char(50),
	sobrenome char(50),
	email varchar(30),
	telefone varchar(14),
	datacadastro date NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Endereco(
	endereco_id serial primary key,
	cliente_id int,
	foreign key (cliente_id) references Cliente(cliente_id),
	rua varchar(100),
	numero int,
	complemento varchar(100),
	cep varchar(9),
	cidade varchar(50),
	pais varchar(50)
);

CREATE TABLE Produto(
 	produto_id SERIAL PRIMARY KEY,
 	nome VARCHAR(255) NOT NULL,
 	descricao TEXT,
 	preco NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Localizacao(
 	localizacao_id SERIAL PRIMARY KEY,
 	rua VARCHAR(255) NOT NULL,
 	numero VARCHAR(20) NOT NULL,
 	complemento VARCHAR(100),
 	cep VARCHAR(10) NOT NULL,
 	cidade VARCHAR(100) NOT NULL,
 	pais VARCHAR(100) NOT NULL
);

CREATE TABLE Inventario(
 	localizacao_id INTEGER,
 	produto_id INTEGER ,
 	FOREIGN KEY (localizacao_id) REFERENCES Localizacao(localizacao_id),
 	FOREIGN KEY (produto_id) REFERENCES Produto(produto_id),
  	quantidade INTEGER,
  	PRIMARY KEY (localizacao_id,produto_id)
);

CREATE TABLE Pedido(
  	pedido_id SERIAL PRIMARY KEY,
  	cliente_id INTEGER NOT NULL,
  	FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
  	datapedido DATE NOT NULL DEFAULT CURRENT_DATE,
  	status VARCHAR(50) NOT NULL,
  	--CONSTRAINT CHK_Status CHECK (status='Pendente' OR status='Entregue' or status='Cancelado')
		CONSTRAINT CHK_Status CHECK (status IN ('Pendente','Entregue','Cancelado'))
);

CREATE TABLE ItemPedido(
  	pedido_id INTEGER NOT NULL,
  	produto_id INTEGER NOT NULL,
  	FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id),
  	FOREIGN KEY (produto_id) REFERENCES Produto(produto_id),
  	quantidade INTEGER,
  	preco NUMERIC(10, 2) NOT NULL
);

INSERT INTO Cliente(nome, sobrenome, email, telefone) 
VALUES
('John', 'Wayne', 'johnwayne@gmail.com', '(63)93313-3818'),
('Henry', 'Fonda', 'henryfonda@gmail.com', '(17)92681-3445'),
('Clint', 'Eastwood','clinteastwood@gmail.com', '(55)92376-4613'),
('Lee', 'Van Cleef','leevancleef@gmail.com', '(96)92257-2174'),
('Eli', 'Wallach','eliwallach@gmail.com', '(81)92522-3586'),
('Chuck', 'Connors','chuckconnors@gmail.com', '(98)92167-2343'),
('Franco', 'Nero', 'franconero@gmail.com', '(81)92910-5244');

INSERT INTO Endereco(cliente_id, rua, numero, complemento, cep, cidade, pais) 
VALUES 
(1, 'Rua Frei Caneca', 250, 'Apto 101', '01307-001', 'São Paulo', 'Brasil'),
(2, 'Avenida Atlântica', 1500, 'Cobertura 2', '22021-001', 'Rio de Janeiro', 'Brasil'),
(3, 'Rua Oscar Freire', 1000, 'Sala 200', '01426-001', 'São Paulo', 'Brasil'),
(4, 'Avenida Paulista', 1000, 'Conjunto 1501', '01310-100', 'São Paulo', 'Brasil'),
(5, 'Rua 25 de Março', 500, 'Loja 20', '01021-200', 'São Paulo', 'Brasil'),
(6, 'Rua Augusta', 1500, 'Apto 501', '01305-100', 'São Paulo', 'Brasil'),
(7, 'Avenida Brigadeiro Faria Lima', 3500, 'Conjunto 2001', '04538-133', 'São Paulo', 'Brasil');

INSERT INTO Produto(produto_id, nome, descricao, preco)
VALUES
(1, 'Mouse', 'Mouse Multilaser sem fio 2.4 Ghz preto', 29.89),
(2, 'Adaptador Bluetooth PC USB', 'Receptor Dongle Bluetooth 5.0', 27.90),
(3, 'Teclado Slim', 'Teclado Slim Preto USB TC213', 31.99),
(4, 'Wacom One CTL472', 'Mesa Digitalizadora Wacom CTL472', 198.90),
(5, 'Expansor Hub', 'Expansor Hub USB 3.0 Portas', 19.35),
(6, 'SSD A400', 'Kingston, SA400S37 / 240G', 147.90),
(7, 'Impressora Multifuncional HP', 'Impressora HP Deskjet 3776 Wi-Fi Scanner', 384.90),
(8, 'Notebook Lenovo', 'Notebook Lenovo IdeaPad 3i Celeron 4GB 128GB SSD', 1799.90),
(9, 'Repetidor deSinal Wi-Fi', 'Repetidor Wi-Fi, Amplificador Roteador Beezo IEEE 802.11/ngb', 43.45),
(10, 'Monitor Ultrawide LG', 'Monitor LG 25UM58-PF Gamer Led 25 Full HD Preto', 1495.00);

INSERT INTO Localizacao(rua, numero, complemento, cep, cidade, pais)
VALUES 
('Rua Reinado do Cavalo Marinho', '13', 'Loja 40', '68905-390', 'São Paulo', 'Brasil'),
('Travessa Na Paz do Seu Sorriso', '90', 'Loja 55', '45203-220', 'São Paulo', 'Brasil'),
('Rua Verão do Cometa', '70', 'Loja 201', '27113-570', 'São Paulo', 'Brasil');

INSERT INTO Inventario(localizacao_id, produto_id, quantidade)
VALUES
(1,1,50),
(1,2,43),
(1,3,74),
(1,4,87),
(1,5,56),
(1,6,50),
(1,7,90),
(1,8,78),
(1,9,67),
(1,10,68),
(2,1,100),
(2,2,24),
(2,3,57),
(2,4,64),
(2,5,53),
(2,6,47),
(2,7,86),
(2,8,87),
(2,9,90),
(2,10,69),
(3,1,13),
(3,2,24),
(3,3,0),
(3,4,89),
(3,5,64),
(3,6,35),
(3,7,75),
(3,8,43),
(3,9,9),
(3,10,13);

INSERT INTO Pedido(cliente_id, datapedido, status) 
VALUES
(1, '2023-04-11', 'Pendente'),
(2, '2023-04-09', 'Entregue'),
(3, '2023-04-08', 'Cancelado'),
(1, '2023-04-11', 'Pendente'),
(3, '2023-04-08', 'Cancelado'),
(6, '2023-04-05', 'Pendente'),
(2, '2023-04-09', 'Entregue'),
(1, '2023-04-11', 'Pendente'),
(7, '2023-04-03', 'Cancelado'),
(7, '2023-04-05', 'Pendente');

INSERT INTO ItemPedido(pedido_id, produto_id, quantidade, preco)
VALUES
(1, 1, 3, 29.89),
(1, 5, 2, 19.35),
(2, 3, 1, 31.99),
(3, 2, 4, 27.90),
(4, 7, 1, 384.90),
(5, 6, 1, 147.90),
(5, 9, 1, 43.45),
(6, 4, 2, 198.90),
(7, 10, 4, 1495.00),
(8, 8, 1, 1799.90),
(8, 5, 2, 19.35),
(9, 3, 5, 31.90);
