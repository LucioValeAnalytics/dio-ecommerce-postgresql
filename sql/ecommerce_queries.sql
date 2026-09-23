-- =====================================================
-- DQL - CONSULTAS DO E-COMMERCE
-- SCHEMA: ecommerce
-- =====================================================


-- =====================================================
-- 1. RECUPERAÇÃO SIMPLES
-- Pergunta:
-- Quais produtos estão cadastrados?
-- =====================================================

SELECT
    id_produto,
    nome,
    descricao,
    preco
FROM ecommerce.produto;

-- =====================================================
-- 2. FILTRO COM WHERE
-- Pergunta:
-- Quais produtos custam mais de R$ 1.000?
-- =====================================================

SELECT
    id_produto,
    nome,
    preco
FROM ecommerce.produto
WHERE preco > 1000
ORDER BY preco DESC;


-- =====================================================
-- 3. ATRIBUTO DERIVADO
-- Pergunta:
-- Qual é o subtotal de cada item dos pedidos?
-- =====================================================

SELECT
    id_pedido,
    id_produto,
    quantidade,
    preco_unitario,
    quantidade * preco_unitario AS subtotal
FROM ecommerce.item_pedido
ORDER BY subtotal DESC;



-- =====================================================
-- 4. AGRUPAMENTO COM GROUP BY
-- Pergunta:
-- Quantos pedidos foram feitos por cada cliente?
-- =====================================================

SELECT
    id_cliente,
    COUNT(id_pedido) AS quantidade_pedidos
FROM ecommerce.pedido
GROUP BY id_cliente
ORDER BY quantidade_pedidos DESC;

-- =====================================================
-- 5. GROUP BY + JOIN
-- Pergunta:
-- Quantos pedidos cada cliente fez?
-- =====================================================

SELECT
    c.id_cliente,
    c.nome,
    COUNT(p.id_pedido) AS quantidade_pedidos
FROM ecommerce.cliente c
JOIN ecommerce.pedido p
    ON c.id_cliente = p.id_cliente
GROUP BY
    c.id_cliente,
    c.nome
ORDER BY quantidade_pedidos DESC;

-- =====================================================
-- 6. FILTRO DE GRUPOS COM HAVING
-- Pergunta:
-- Quais clientes fizeram mais de um pedido?
-- =====================================================

SELECT
    c.id_cliente,
    c.nome,
    COUNT(p.id_pedido) AS quantidade_pedidos
FROM ecommerce.cliente c
JOIN ecommerce.pedido p
    ON c.id_cliente = p.id_cliente
GROUP BY
    c.id_cliente,
    c.nome
HAVING COUNT(p.id_pedido) > 1
ORDER BY quantidade_pedidos DESC;

-- =====================================================
-- 7. FATURAMENTO POR PEDIDO
-- Pergunta:
-- Qual foi o valor total de cada pedido?
-- =====================================================

SELECT
    p.id_pedido,
    p.id_cliente,
    SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM ecommerce.pedido p
JOIN ecommerce.item_pedido ip
    ON p.id_pedido = ip.id_pedido
GROUP BY
    p.id_pedido,
    p.id_cliente
ORDER BY total_pedido DESC;

-- =====================================================
-- 8. FATURAMENTO POR CLIENTE
-- Pergunta:
-- Qual o valor total dos pedidos de cada cliente?
-- =====================================================

SELECT
    c.id_cliente,
    c.nome,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento_total
FROM ecommerce.cliente c
JOIN ecommerce.pedido p
    ON c.id_cliente = p.id_cliente
JOIN ecommerce.item_pedido ip
    ON p.id_pedido = ip.id_pedido
GROUP BY
    c.id_cliente,
    c.nome
ORDER BY faturamento_total DESC;

-- =====================================================
-- 9. PRODUTOS MAIS VENDIDOS
-- Pergunta:
-- Quais produtos tiveram maior quantidade vendida?
-- =====================================================

SELECT
    p.id_produto,
    p.nome,
    SUM(ip.quantidade) AS quantidade_vendida
FROM ecommerce.produto p
JOIN ecommerce.item_pedido ip
    ON p.id_produto = ip.id_produto
GROUP BY
    p.id_produto,
    p.nome
ORDER BY quantidade_vendida DESC;

-- =====================================================
-- 10. DESEMPENHO DOS PRODUTOS
-- Pergunta:
-- Qual a quantidade vendida e o faturamento de cada produto?
-- =====================================================

SELECT
    p.id_produto,
    p.nome,
    SUM(ip.quantidade) AS quantidade_vendida,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM ecommerce.produto p
JOIN ecommerce.item_pedido ip
    ON p.id_produto = ip.id_produto
GROUP BY
    p.id_produto,
    p.nome
ORDER BY faturamento DESC;

-- =====================================================
-- 11. ESTOQUE TOTAL POR PRODUTO
-- Pergunta:
-- Qual a quantidade total disponível de cada produto?
-- =====================================================

SELECT
    p.id_produto,
    p.nome,
    SUM(pe.quantidade) AS estoque_total
FROM ecommerce.produto p
JOIN ecommerce.produto_estoque pe
    ON p.id_produto = pe.id_produto
GROUP BY
    p.id_produto,
    p.nome
ORDER BY estoque_total DESC;

-- =====================================================
-- 12. PRODUTOS POR LOCALIZAÇÃO
-- Pergunta:
-- Em quais estoques cada produto está disponível?
-- =====================================================

SELECT
    p.nome AS produto,
    e.localizacao,
    pe.quantidade
FROM ecommerce.produto p
JOIN ecommerce.produto_estoque pe
    ON p.id_produto = pe.id_produto
JOIN ecommerce.estoque e
    ON pe.id_estoque = e.id_estoque
ORDER BY
    p.nome,
    e.localizacao;

-- =====================================================
-- 13. PRODUTOS E FORNECEDORES
-- Pergunta:
-- Quais fornecedores fornecem cada produto?
-- =====================================================

SELECT
    p.nome AS produto,
    f.nome AS fornecedor
FROM ecommerce.produto p
JOIN ecommerce.produto_fornecedor pf
    ON p.id_produto = pf.id_produto
JOIN ecommerce.fornecedor f
    ON pf.id_fornecedor = f.id_fornecedor
ORDER BY
    p.nome,
    f.nome;

-- =====================================================
-- 14. QUANTIDADE DE FORNECEDORES POR PRODUTO
-- Pergunta:
-- Quais produtos possuem mais de um fornecedor?
-- =====================================================

SELECT
    p.id_produto,
    p.nome,
    COUNT(pf.id_fornecedor) AS quantidade_fornecedores
FROM ecommerce.produto p
JOIN ecommerce.produto_fornecedor pf
    ON p.id_produto = pf.id_produto
GROUP BY
    p.id_produto,
    p.nome
HAVING COUNT(pf.id_fornecedor) > 1
ORDER BY quantidade_fornecedores DESC;

-- =====================================================
-- 15. VENDEDOR TAMBÉM É FORNECEDOR
-- Pergunta:
-- Algum vendedor também está cadastrado como fornecedor?
-- =====================================================

SELECT
    v.id_vendedor,
    v.nome AS vendedor,
    v.cnpj,
    f.id_fornecedor,
    f.nome AS fornecedor
FROM ecommerce.vendedor v
JOIN ecommerce.fornecedor f
    ON v.cnpj = f.cnpj
ORDER BY v.nome;

-- =====================================================
-- 16. PEDIDOS POR STATUS
-- Pergunta:
-- Quantos pedidos existem em cada status?
-- =====================================================

SELECT
    status,
    COUNT(*) AS quantidade_pedidos
FROM ecommerce.pedido
GROUP BY status
ORDER BY quantidade_pedidos DESC;

-- =====================================================
-- 17. PEDIDOS POR CLIENTE
-- Pergunta:
-- Quais pedidos foram feitos por cada cliente?
-- =====================================================

SELECT
    p.id_pedido,
    c.nome AS cliente,
    p.data_pedido,
    p.status
FROM ecommerce.pedido p
JOIN ecommerce.cliente c
    ON p.id_cliente = c.id_cliente
ORDER BY
    p.data_pedido;

-- =====================================================
-- 18. PEDIDOS COM ENTREGA
-- Pergunta:
-- Quais pedidos possuem entrega cadastrada?
-- =====================================================

SELECT
    p.id_pedido,
    c.nome AS cliente,
    p.status AS status_pedido,
    e.status AS status_entrega,
    e.codigo_rastreio,
    e.data_envio,
    e.data_entrega
FROM ecommerce.pedido p
JOIN ecommerce.cliente c
    ON p.id_cliente = c.id_cliente
JOIN ecommerce.entrega e
    ON p.id_pedido = e.id_pedido
ORDER BY
    p.id_pedido;

-- =====================================================
-- 19. PEDIDOS SEM ENTREGA
-- Pergunta:
-- Quais pedidos ainda não possuem entrega?
-- =====================================================

SELECT
    p.id_pedido,
    c.nome AS cliente,
    p.data_pedido,
    p.status
FROM ecommerce.pedido p
JOIN ecommerce.cliente c
    ON p.id_cliente = c.id_cliente
LEFT JOIN ecommerce.entrega e
    ON p.id_pedido = e.id_pedido
WHERE e.id_entrega IS NULL
ORDER BY p.id_pedido;

-- =====================================================
-- 20. PEDIDOS COM MÚLTIPLOS PAGAMENTOS
-- Pergunta:
-- Quais pedidos possuem mais de um pagamento?
-- =====================================================

SELECT
    p.id_pedido,
    c.nome AS cliente,
    COUNT(pg.id_pagamento) AS quantidade_pagamentos,
    SUM(pg.valor) AS valor_total_pago
FROM ecommerce.pedido p
JOIN ecommerce.cliente c
    ON p.id_cliente = c.id_cliente
JOIN ecommerce.pagamento pg
    ON p.id_pedido = pg.id_pedido
GROUP BY
    p.id_pedido,
    c.nome
HAVING COUNT(pg.id_pagamento) > 1
ORDER BY
    quantidade_pagamentos DESC;

-- =====================================================
-- VALIDAÇÃO DOS TOTAIS DOS PEDIDOS
-- Pergunta:
-- Os valores dos pagamentos correspondem aos totais dos pedidos?
-- Resultado esperado: diferença igual a 0 para todos os pedidos.
-- =====================================================

WITH total_pedido AS (
    SELECT
        id_pedido,
        SUM(quantidade * preco_unitario) AS total_pedido
    FROM ecommerce.item_pedido
    GROUP BY id_pedido
),

total_pagamento AS (
    SELECT
        id_pedido,
        SUM(valor) AS total_pago
    FROM ecommerce.pagamento
    GROUP BY id_pedido
)

SELECT
    p.id_pedido,
    tp.total_pedido,
    COALESCE(tpg.total_pago, 0) AS total_pago,
    tp.total_pedido - COALESCE(tpg.total_pago, 0) AS diferenca
FROM ecommerce.pedido p
JOIN total_pedido tp
    ON p.id_pedido = tp.id_pedido
LEFT JOIN total_pagamento tpg
    ON p.id_pedido = tpg.id_pedido
ORDER BY p.id_pedido;
