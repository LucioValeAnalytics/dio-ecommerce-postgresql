-- =====================================================
-- BANCO DE DADOS: dio
-- SCHEMA: ecommerce
-- =====================================================

CREATE SCHEMA IF NOT EXISTS ecommerce;


-- =====================================================
-- TABELA: CLIENTE
-- =====================================================

CREATE TABLE ecommerce.cliente (
    id_cliente INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),

    CONSTRAINT pk_cliente
        PRIMARY KEY (id_cliente),

    CONSTRAINT uq_cliente_email
        UNIQUE (email)
);


-- =====================================================
-- TABELA: CLIENTE PF
-- =====================================================

CREATE TABLE ecommerce.cliente_pf (
    id_cliente INTEGER,
    cpf CHAR(11) NOT NULL,

    CONSTRAINT pk_cliente_pf
        PRIMARY KEY (id_cliente),

    CONSTRAINT fk_cliente_pf_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES ecommerce.cliente (id_cliente),

    CONSTRAINT uq_cliente_pf_cpf
        UNIQUE (cpf)
);


-- =====================================================
-- TABELA: CLIENTE PJ
-- =====================================================

CREATE TABLE ecommerce.cliente_pj (
    id_cliente INTEGER,
    cnpj CHAR(14) NOT NULL,

    CONSTRAINT pk_cliente_pj
        PRIMARY KEY (id_cliente),

    CONSTRAINT fk_cliente_pj_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES ecommerce.cliente (id_cliente),

    CONSTRAINT uq_cliente_pj_cnpj
        UNIQUE (cnpj)
);


-- =====================================================
-- REGRA DE ESPECIALIZAÇÃO: PF x PJ
-- Um cliente não pode ser simultaneamente PF e PJ.
-- =====================================================

CREATE OR REPLACE FUNCTION ecommerce.fn_validar_cliente_pf()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    IF EXISTS (
        SELECT 1
        FROM ecommerce.cliente_pj
        WHERE id_cliente = NEW.id_cliente
    ) THEN
        RAISE EXCEPTION
            'O cliente % já está cadastrado como PJ.',
            NEW.id_cliente;
    END IF;

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_validar_cliente_pf
BEFORE INSERT OR UPDATE
ON ecommerce.cliente_pf
FOR EACH ROW
EXECUTE FUNCTION ecommerce.fn_validar_cliente_pf();


CREATE OR REPLACE FUNCTION ecommerce.fn_validar_cliente_pj()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    IF EXISTS (
        SELECT 1
        FROM ecommerce.cliente_pf
        WHERE id_cliente = NEW.id_cliente
    ) THEN
        RAISE EXCEPTION
            'O cliente % já está cadastrado como PF.',
            NEW.id_cliente;
    END IF;

    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_validar_cliente_pj
BEFORE INSERT OR UPDATE
ON ecommerce.cliente_pj
FOR EACH ROW
EXECUTE FUNCTION ecommerce.fn_validar_cliente_pj();


-- =====================================================
-- TABELA: FORNECEDOR
-- =====================================================

CREATE TABLE ecommerce.fornecedor (
    id_fornecedor INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    cnpj CHAR(14),

    CONSTRAINT pk_fornecedor
        PRIMARY KEY (id_fornecedor),

    CONSTRAINT uq_fornecedor_cnpj
        UNIQUE (cnpj)
);


-- =====================================================
-- TABELA: VENDEDOR
-- =====================================================

CREATE TABLE ecommerce.vendedor (
    id_vendedor INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telefone VARCHAR(20),
    cnpj CHAR(14),

    CONSTRAINT pk_vendedor
        PRIMARY KEY (id_vendedor),

    CONSTRAINT uq_vendedor_email
        UNIQUE (email),

    CONSTRAINT uq_vendedor_cnpj
        UNIQUE (cnpj)
);


-- =====================================================
-- TABELA: PRODUTO
-- =====================================================

CREATE TABLE ecommerce.produto (
    id_produto INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(150) NOT NULL,
    descricao VARCHAR(255),
    preco NUMERIC(12,2) NOT NULL,

    CONSTRAINT pk_produto
        PRIMARY KEY (id_produto),

    CONSTRAINT ck_produto_preco
        CHECK (preco >= 0)
);

-- =====================================================
-- TABELA: PRODUTO_VENDEDOR
-- =====================================================

CREATE TABLE ecommerce.produto_vendedor (
    id_produto INTEGER NOT NULL,
    id_vendedor INTEGER NOT NULL,

    CONSTRAINT pk_produto_vendedor
        PRIMARY KEY (id_produto, id_vendedor),

    CONSTRAINT fk_produto_vendedor_produto
        FOREIGN KEY (id_produto)
        REFERENCES ecommerce.produto (id_produto),

    CONSTRAINT fk_produto_vendedor_vendedor
        FOREIGN KEY (id_vendedor)
        REFERENCES ecommerce.vendedor (id_vendedor)
);


-- =====================================================
-- TABELA: ESTOQUE
-- =====================================================

CREATE TABLE ecommerce.estoque (
    id_estoque INTEGER GENERATED ALWAYS AS IDENTITY,
    localizacao VARCHAR(150) NOT NULL,

    CONSTRAINT pk_estoque
        PRIMARY KEY (id_estoque)
);


-- =====================================================
-- TABELA: PRODUTO_ESTOQUE
-- =====================================================

CREATE TABLE ecommerce.produto_estoque (
    id_produto INTEGER NOT NULL,
    id_estoque INTEGER NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT pk_produto_estoque
        PRIMARY KEY (id_produto, id_estoque),

    CONSTRAINT fk_produto_estoque_produto
        FOREIGN KEY (id_produto)
        REFERENCES ecommerce.produto (id_produto),

    CONSTRAINT fk_produto_estoque_estoque
        FOREIGN KEY (id_estoque)
        REFERENCES ecommerce.estoque (id_estoque),

    CONSTRAINT ck_produto_estoque_quantidade
        CHECK (quantidade >= 0)
);


-- =====================================================
-- TABELA: PRODUTO_FORNECEDOR
-- =====================================================

CREATE TABLE ecommerce.produto_fornecedor (
    id_produto INTEGER NOT NULL,
    id_fornecedor INTEGER NOT NULL,

    CONSTRAINT pk_produto_fornecedor
        PRIMARY KEY (id_produto, id_fornecedor),

    CONSTRAINT fk_produto_fornecedor_produto
        FOREIGN KEY (id_produto)
        REFERENCES ecommerce.produto (id_produto),

    CONSTRAINT fk_produto_fornecedor_fornecedor
        FOREIGN KEY (id_fornecedor)
        REFERENCES ecommerce.fornecedor (id_fornecedor)
);

-- =====================================================
-- TABELA: PEDIDO
-- =====================================================

CREATE TABLE ecommerce.pedido (
    id_pedido INTEGER GENERATED ALWAYS AS IDENTITY,
    id_cliente INTEGER NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'ABERTO',

    CONSTRAINT pk_pedido
        PRIMARY KEY (id_pedido),

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES ecommerce.cliente (id_cliente),

    CONSTRAINT ck_pedido_status
        CHECK (
            status IN (
                'ABERTO',
                'PROCESSANDO',
                'ENVIADO',
                'ENTREGUE',
                'CANCELADO'
            )
        )
);


-- =====================================================
-- TABELA: ITEM_PEDIDO
-- =====================================================

CREATE TABLE ecommerce.item_pedido (
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    preco_unitario NUMERIC(12,2) NOT NULL,

    CONSTRAINT pk_item_pedido
        PRIMARY KEY (id_pedido, id_produto),

    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES ecommerce.pedido (id_pedido),

    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (id_produto)
        REFERENCES ecommerce.produto (id_produto),

    CONSTRAINT ck_item_pedido_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT ck_item_pedido_preco
        CHECK (preco_unitario >= 0)
);


-- =====================================================
-- TABELA: FORMA_PAGAMENTO
-- =====================================================

CREATE TABLE ecommerce.forma_pagamento (
    id_forma_pagamento INTEGER GENERATED ALWAYS AS IDENTITY,
    descricao VARCHAR(50) NOT NULL,

    CONSTRAINT pk_forma_pagamento
        PRIMARY KEY (id_forma_pagamento),

    CONSTRAINT uq_forma_pagamento_descricao
        UNIQUE (descricao)
);


-- =====================================================
-- TABELA: PAGAMENTO
-- =====================================================

CREATE TABLE ecommerce.pagamento (
    id_pagamento INTEGER GENERATED ALWAYS AS IDENTITY,
    id_pedido INTEGER NOT NULL,
    id_forma_pagamento INTEGER NOT NULL,
    valor NUMERIC(12,2) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDENTE',
    data_pagamento TIMESTAMP,

    CONSTRAINT pk_pagamento
        PRIMARY KEY (id_pagamento),

    CONSTRAINT fk_pagamento_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES ecommerce.pedido (id_pedido),

    CONSTRAINT fk_pagamento_forma
        FOREIGN KEY (id_forma_pagamento)
        REFERENCES ecommerce.forma_pagamento (id_forma_pagamento),

    CONSTRAINT ck_pagamento_valor
        CHECK (valor > 0),

    CONSTRAINT ck_pagamento_status
        CHECK (
            status IN (
                'PENDENTE',
                'APROVADO',
                'RECUSADO',
                'ESTORNADO'
            )
        )
);


-- =====================================================
-- TABELA: ENTREGA
-- =====================================================

CREATE TABLE ecommerce.entrega (
    id_entrega INTEGER GENERATED ALWAYS AS IDENTITY,
    id_pedido INTEGER NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'AGUARDANDO',
    codigo_rastreio VARCHAR(50),
    data_envio TIMESTAMP,
    data_entrega TIMESTAMP,

    CONSTRAINT pk_entrega
        PRIMARY KEY (id_entrega),

    CONSTRAINT uq_entrega_pedido
        UNIQUE (id_pedido),

    CONSTRAINT uq_entrega_codigo_rastreio
        UNIQUE (codigo_rastreio),

    CONSTRAINT fk_entrega_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES ecommerce.pedido (id_pedido),

    CONSTRAINT ck_entrega_status
        CHECK (
            status IN (
                'AGUARDANDO',
                'ENVIADA',
                'EM_TRANSITO',
                'ENTREGUE',
                'CANCELADA'
            )
        )
);


-- =====================================================
-- TABELA: CLIENTE_FORMA_PAGAMENTO
-- =====================================================

CREATE TABLE ecommerce.cliente_forma_pagamento (
    id_cliente INTEGER NOT NULL,
    id_forma_pagamento INTEGER NOT NULL,

    CONSTRAINT pk_cliente_forma_pagamento
        PRIMARY KEY (id_cliente, id_forma_pagamento),

    CONSTRAINT fk_cliente_forma_pagamento_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES ecommerce.cliente (id_cliente),

    CONSTRAINT fk_cliente_forma_pagamento_forma
        FOREIGN KEY (id_forma_pagamento)
        REFERENCES ecommerce.forma_pagamento (id_forma_pagamento)
);

