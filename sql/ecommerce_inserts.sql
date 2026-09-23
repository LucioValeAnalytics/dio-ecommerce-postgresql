-- =====================================================
-- DADOS DE TESTE: E-COMMERCE
-- SCHEMA: ecommerce
-- =====================================================

-- =====================================================
-- CLIENTES
-- =====================================================

INSERT INTO ecommerce.cliente
(nome, email, telefone)
VALUES
('João da Silva', 'joao.silva@email.com', '81999990001'),
('Maria Oliveira', 'maria.oliveira@email.com', '81999990002'),
('Carlos Santos', 'carlos.santos@email.com', '81999990003'),
('Ana Costa', 'ana.costa@email.com', '81999990004'),
('Tech Solutions LTDA', 'contato@techsolutions.com', '81999990005'),
('Comercial Nordeste LTDA', 'contato@comercialnordeste.com', '81999990006');

-- =====================================================
-- CLIENTES PF
-- =====================================================

INSERT INTO ecommerce.cliente_pf
(id_cliente, cpf)
VALUES
(1, '11111111101'),
(2, '22222222202'),
(3, '33333333303'),
(4, '44444444404');

-- =====================================================
-- CLIENTES PJ
-- =====================================================

INSERT INTO ecommerce.cliente_pj
(id_cliente, cnpj)
VALUES
(5, '11111111000101'),
(6, '22222222000102');

-- =====================================================
-- FORNECEDORES
-- =====================================================

INSERT INTO ecommerce.fornecedor
(nome, cnpj)
VALUES
('Tech Distribuidora', '33333333000103'),
('Global Eletrônicos', '44444444000104'),
('Nordeste Informática', '55555555000105'),
('Alpha Componentes', '66666666000106'),
('Comercial Nordeste LTDA', '22222222000102');

-- =====================================================
-- VENDEDORES
-- =====================================================

INSERT INTO ecommerce.vendedor
(nome, email, telefone, cnpj)
VALUES
('Tech Distribuidora', 'vendas@techdistribuidora.com', '81988880001', '33333333000103'),
('Global Eletrônicos', 'vendas@globaleletronicos.com', '81988880002', '44444444000104'),
('Loja Digital Nordeste', 'vendas@lojadigital.com', '81988880003', '77777777000107'),
('Mega Store', 'vendas@megastore.com', '81988880004', '88888888000108');

-- =====================================================
-- PRODUTOS
-- =====================================================

INSERT INTO ecommerce.produto
(nome, descricao, preco)
VALUES
('Notebook Pro 15', 'Notebook com 16GB de RAM e SSD de 512GB', 4599.90),
('Notebook Basic 14', 'Notebook com 8GB de RAM e SSD de 256GB', 2899.90),
('Monitor 24 Full HD', 'Monitor LED de 24 polegadas Full HD', 899.90),
('Teclado Mecânico', 'Teclado mecânico ABNT2 com iluminação', 349.90),
('Mouse Gamer', 'Mouse gamer com sensor de alta precisão', 199.90),
('Headset Gamer', 'Headset com microfone e áudio surround', 299.90),
('SSD 1TB', 'SSD NVMe de 1TB', 649.90),
('Memória RAM 16GB', 'Memória DDR4 16GB', 389.90);


-- =====================================================
-- ESTOQUES
-- =====================================================

INSERT INTO ecommerce.estoque
(localizacao)
VALUES
('Centro de Distribuição Recife'),
('Centro de Distribuição Caruaru'),
('Centro de Distribuição São Paulo'),
('Loja Física Recife');

-- =====================================================
-- PRODUTO_ESTOQUE
-- =====================================================

INSERT INTO ecommerce.produto_estoque
(id_produto, id_estoque, quantidade)
VALUES
(1, 1, 15),
(1, 2, 8),
(1, 3, 20),

(2, 1, 25),
(2, 2, 12),

(3, 1, 30),
(3, 4, 10),

(4, 2, 18),
(4, 4, 7),

(5, 1, 40),
(5, 2, 20),

(6, 1, 22),
(6, 3, 15),

(7, 3, 35),

(8, 1, 50),
(8, 2, 25);


-- =====================================================
-- PRODUTO_FORNECEDOR
-- =====================================================

INSERT INTO ecommerce.produto_fornecedor
(id_produto, id_fornecedor)
VALUES
(1, 1),
(1, 2),
(1, 3),

(2, 1),
(2, 3),

(3, 2),
(3, 4),

(4, 3),
(4, 4),

(5, 1),
(5, 2),

(6, 2),
(6, 3),

(7, 2),
(7, 4),

(8, 1),
(8, 4);

-- =====================================================
-- PRODUTO_VENDEDOR
-- =====================================================

INSERT INTO ecommerce.produto_vendedor
(id_produto, id_vendedor)
VALUES
(1, 1),
(1, 2),
(1, 3),

(2, 1),
(2, 3),

(3, 2),
(3, 4),

(4, 1),
(4, 3),

(5, 1),
(5, 2),
(5, 4),

(6, 2),
(6, 3),

(7, 2),
(7, 4),

(8, 1),
(8, 3);

-- =====================================================
-- FORMAS DE PAGAMENTO
-- =====================================================

INSERT INTO ecommerce.forma_pagamento
(descricao)
VALUES
('PIX'),
('Cartão de Crédito'),
('Cartão de Débito'),
('Boleto'),
('Carteira Digital');

-- =====================================================
-- CLIENTE_FORMA_PAGAMENTO
-- =====================================================

INSERT INTO ecommerce.cliente_forma_pagamento
(id_cliente, id_forma_pagamento)
VALUES
(1, 1),
(1, 2),

(2, 1),
(2, 2),
(2, 4),

(3, 1),
(3, 3),

(4, 2),
(4, 5),

(5, 1),
(5, 2),
(5, 4),

(6, 1),
(6, 2),
(6, 5);

-- =====================================================
-- PEDIDOS
-- =====================================================

INSERT INTO ecommerce.pedido
(id_cliente, data_pedido, status)
VALUES
(1, '2026-09-01 09:15:00', 'ENTREGUE'),
(1, '2026-09-10 14:30:00', 'ENVIADO'),

(2, '2026-09-03 10:20:00', 'ENTREGUE'),
(2, '2026-09-12 16:45:00', 'PROCESSANDO'),
(2, '2026-09-18 11:10:00', 'ABERTO'),

(3, '2026-09-05 08:40:00', 'ENTREGUE'),

(4, '2026-09-07 13:25:00', 'CANCELADO'),

(5, '2026-09-08 09:50:00', 'ENTREGUE'),
(5, '2026-09-15 15:20:00', 'ENVIADO'),

(6, '2026-09-20 10:05:00', 'PROCESSANDO');

-- =====================================================
-- ITENS DOS PEDIDOS
-- =====================================================

INSERT INTO ecommerce.item_pedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES

-- Pedido 1
(1, 1, 1, 4599.90),
(1, 5, 2, 199.90),

-- Pedido 2
(2, 3, 1, 899.90),
(2, 4, 1, 349.90),

-- Pedido 3
(3, 2, 1, 2899.90),
(3, 8, 2, 389.90),

-- Pedido 4
(4, 1, 1, 4599.90),
(4, 7, 1, 649.90),

-- Pedido 5
(5, 5, 3, 199.90),
(5, 6, 1, 299.90),

-- Pedido 6
(6, 3, 2, 899.90),
(6, 7, 2, 649.90),

-- Pedido 7
(7, 4, 1, 349.90),
(7, 6, 1, 299.90),

-- Pedido 8
(8, 1, 2, 4599.90),
(8, 3, 2, 899.90),

-- Pedido 9
(9, 2, 1, 2899.90),
(9, 5, 2, 199.90),

-- Pedido 10
(10, 7, 3, 649.90),
(10, 8, 2, 389.90);

-- =====================================================
-- PAGAMENTOS
-- =====================================================

INSERT INTO ecommerce.pagamento
(id_pedido, id_forma_pagamento, valor, status, data_pagamento)
VALUES
-- Pedido 1
(1, 2, 4999.70, 'APROVADO', '2026-09-01 09:20:00'),

-- Pedido 2
(2, 1, 1249.80, 'APROVADO', '2026-09-10 14:35:00'),

-- Pedido 3
(3, 2, 3679.70, 'APROVADO', '2026-09-03 10:25:00'),

-- Pedido 4 - dois pagamentos
(4, 1, 2000.00, 'APROVADO', '2026-09-12 16:50:00'),
(4, 2, 3249.80, 'APROVADO', '2026-09-12 16:51:00'),

-- Pedido 5
(5, 4, 899.60, 'PENDENTE', NULL),

-- Pedido 6
(6, 2, 3099.60, 'APROVADO', '2026-09-05 08:45:00'),

-- Pedido 7
(7, 3, 649.80, 'RECUSADO', '2026-09-07 13:30:00'),

-- Pedido 8 - dois pagamentos
(8, 2, 5000.00, 'APROVADO', '2026-09-08 09:55:00'),
(8, 1, 5999.60, 'APROVADO', '2026-09-08 09:56:00'),

-- Pedido 9
(9, 1, 3299.70, 'APROVADO', '2026-09-15 15:25:00'),

-- Pedido 10
(10, 5, 2729.50, 'PENDENTE', NULL);

-- =====================================================
-- ENTREGAS
-- =====================================================

INSERT INTO ecommerce.entrega
(id_pedido, status, codigo_rastreio, data_envio, data_entrega)
VALUES
(1, 'ENTREGUE', 'BR100000001', '2026-09-02 08:00:00', '2026-09-05 14:30:00'),

(2, 'ENVIADA', 'BR100000002', '2026-09-11 09:15:00', NULL),

(3, 'ENTREGUE', 'BR100000003', '2026-09-04 10:00:00', '2026-09-07 16:20:00'),

(4, 'EM_TRANSITO', 'BR100000004', '2026-09-14 07:30:00', NULL),

(6, 'ENTREGUE', 'BR100000005', '2026-09-06 08:45:00', '2026-09-09 13:10:00'),

(8, 'ENTREGUE', 'BR100000006', '2026-09-09 09:00:00', '2026-09-13 11:40:00'),

(9, 'ENVIADA', 'BR100000007', '2026-09-16 08:20:00', NULL);
