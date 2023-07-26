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
	precototal NUMERIC(10, 2) NOT NULL,
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
