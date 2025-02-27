CREATE DATABASE Locadora_Veiculos;

USE Locadora_Veiculos;

CREATE TABLE Cliente(
    cod_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(255),
    endereco VARCHAR(255)
);


CREATE TABLE Pessoa_Fisica(
    cod_cliente INTEGER PRIMARY KEY,
    cpf BIGINT UNIQUE,
    sexo VARCHAR(1),
    data_nasc DATE,
    
    FOREIGN KEY (cod_cliente) 
        REFERENCES Cliente(cod_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE Pessoa_Juridica(
    cod_cliente INTEGER PRIMARY KEY,
    cnpj BIGINT UNIQUE,
    inscr_estado BIGINT,
    
    FOREIGN KEY (cod_cliente) 
        REFERENCES Cliente(cod_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE Motorista(
    cod_motorista SERIAL PRIMARY KEY,
    cod_cliente INTEGER,
    num_habili BIGINT UNIQUE,
    vencimento_habili DATE,
    ident_motorista BIGINT,

    FOREIGN KEY (cod_cliente) 
        REFERENCES Cliente(cod_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE Tipo_Veiculo(
    cod_tipo VARCHAR(5) PRIMARY KEY,
    horas_limpeza INTEGER,
    horas_revisao INTEGER
);


CREATE TABLE Tipo_Passageiro(
    cod_tipo VARCHAR(5) PRIMARY KEY,
    tamanho VARCHAR(1),
    num_lugares INTEGER,
    num_portas INTEGER,
    ar_condicionado BOOLEAN,
    radio BOOLEAN,
    mp3 BOOLEAN,
    cd BOOLEAN,
    dir_hidr BOOLEAN,
    cambio_auto BOOLEAN
);


CREATE TABLE Tipo_Carga(
    cod_tipo VARCHAR(5) PRIMARY KEY,
    capacidade INTEGER
);


CREATE TABLE Filial(
    cod_filial VARCHAR(10) PRIMARY KEY,
    localizacao VARCHAR(255)
);


CREATE TABLE Veiculo(
    cod_placa VARCHAR(10) PRIMARY KEY,
    cod_tipo VARCHAR(5),
    cod_filial_atual VARCHAR(10),
    num_chassi VARCHAR(10),
    num_motor VARCHAR(10),
    cor VARCHAR(20),
    km_atual INTEGER DEFAULT 0,
    revisao_pendente BOOLEAN DEFAULT FALSE,
    parado BOOLEAN DEFAULT TRUE,
    
    FOREIGN KEY (cod_tipo) 
        REFERENCES Tipo_Veiculo(cod_tipo) 
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (cod_filial_atual) 
        REFERENCES Filial(cod_filial) 
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE Revisao(
    cod_tipo VARCHAR(5),
    cod_revisao SERIAL,
    km_media INTEGER,
    

    PRIMARY KEY (cod_tipo, cod_revisao),
    FOREIGN KEY (cod_tipo) 
        REFERENCES Tipo_Veiculo(cod_tipo)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE Reserva(
    cod_reserva SERIAL PRIMARY KEY,
    cod_tipo VARCHAR(5),
    cod_filial_dest VARCHAR(10),
    cod_filial_orig VARCHAR(10),
    cod_cliente INTEGER,
    data_retirada DATE,
    data_entrega DATE,

    FOREIGN KEY (cod_tipo) 
        REFERENCES Tipo_Veiculo(cod_tipo)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    FOREIGN KEY (cod_filial_dest) 
        REFERENCES Filial(cod_filial)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    FOREIGN KEY (cod_filial_orig) 
        REFERENCES Filial(cod_filial)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    FOREIGN KEY (cod_cliente) 
        REFERENCES Cliente(cod_cliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE Locacao(
    cod_locacao SERIAL PRIMARY KEY,
    cod_placa VARCHAR(10),
    cod_filial_dest VARCHAR(10),
    cod_motorista INTEGER,
    data_entrega DATE,

    FOREIGN KEY (cod_placa) 
        REFERENCES Veiculo(cod_placa)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    FOREIGN KEY (cod_filial_dest) 
        REFERENCES Filial(cod_filial)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    FOREIGN KEY (cod_motorista) 
        REFERENCES Motorista(cod_motorista)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE VIEW locacoes_recentes AS 
	SELECT l1.*
	FROM Locacao AS l1 LEFT JOIN Locacao AS l2
	ON (l1.cod_placa = l2.cod_placa AND l1.data_entrega < l2.data_entrega)
	WHERE l2.data_entrega IS NULL

CREATE VIEW reservas_recentes AS 
	SELECT *
	FROM Reserva
	WHERE data_entrega > NOW()


CREATE OR REPLACE FUNCTION contar_clientes(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_cliente) FROM cliente;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_filiais(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_filial) FROM filial;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_locacao(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_locacao) FROM locacao;
END;
$BODY$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION contar_motoristas(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_motoristas) FROM motorista;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_pessoa_fisica(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_cliente) FROM pessoa_fisica;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_pessoa_juridica(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_cliente) FROM pessoa_juridica;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_reservas(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_reserva) FROM reserva;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_revisoes(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_revisao) FROM revisao;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_tipo_carga(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_tipo) FROM tipo_carga;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_tipo_passageiro(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_tipo) FROM tipo_passageiro;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_tipos(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_tipo) FROM tipo_veiculo;
END;
$BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_veiculos(OUT total integer)
  RETURNS integer AS
$BODY$
BEGIN
	total = COUNT(cod_placa) FROM veiculo;
END;
$BODY$
  LANGUAGE plpgsql;

