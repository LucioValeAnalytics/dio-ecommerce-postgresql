# E-commerce PostgreSQL — DIO

Projeto de banco de dados desenvolvido como parte do desafio de projeto da DIO, utilizando PostgreSQL para representar um cenário de e-commerce.

O projeto contempla modelagem lógica, implementação do esquema relacional, constraints, persistência de dados e consultas SQL para análise das informações.

## 🎯 Objetivo

Implementar o modelo lógico de um sistema de e-commerce, aplicando conceitos de:

- modelagem relacional;
- chaves primárias e estrangeiras;
- constraints;
- relacionamentos 1:N e N:N;
- especialização de entidades;
- persistência de dados;
- consultas SQL;
- análise de dados com PostgreSQL.

O projeto também aplica os refinamentos propostos no desafio:

- Cliente pode ser PF ou PJ, mas não ambos;
- Cliente pode possuir mais de uma forma de pagamento;
- Pedido pode possuir múltiplos pagamentos;
- Entrega possui status e código de rastreio.

---

## 🗂️ Estrutura do projeto

```text
dio-ecommerce-postgresql/
│
├── README.md
│
├── sql/
│   ├── ecommerce_tables.sql
│   ├── ecommerce_inserts.sql
│   └── ecommerce_queries.sql
│
└── docs/
    └── modelo_eer.png
```

### `ecommerce_tables.sql`

Script responsável pela criação do schema, tabelas, chaves, constraints e regras de integridade.

### `ecommerce_inserts.sql`

Script responsável pela persistência dos dados utilizados nos testes e consultas.

### `ecommerce_queries.sql`

Consultas SQL utilizadas para explorar e analisar os dados do e-commerce.

---

## 🧩 Modelo lógico

O banco foi estruturado a partir das principais entidades do cenário de e-commerce:

```text
Cliente
 ├── Cliente PF
 └── Cliente PJ

Cliente
 ├── Pedido
 └── Cliente_Forma_Pagamento
                  │
                  └── Forma_Pagamento

Pedido
 ├── Item_Pedido ─── Produto
 ├── Pagamento ───── Forma_Pagamento
 └── Entrega

Produto
 ├── Produto_Estoque ─── Estoque
 ├── Produto_Fornecedor ─── Fornecedor
 └── Produto_Vendedor ─── Vendedor
```

### Principais relacionamentos

- Cliente 1:N Pedido
- Pedido 1:N Item_Pedido
- Produto 1:N Item_Pedido
- Produto N:N Estoque
- Produto N:N Fornecedor
- Produto N:N Vendedor
- Cliente N:N Forma_Pagamento
- Pedido 1:N Pagamento
- Pedido 1:0..1 Entrega

---

## 👤 Cliente PF e PJ

O modelo utiliza uma tabela principal `cliente` e duas tabelas especializadas:

```text
cliente
   ├── cliente_pf
   └── cliente_pj
```

Um cliente pode possuir informações de pessoa física ou pessoa jurídica.

A regra de negócio impede que o mesmo cliente seja cadastrado simultaneamente como PF e PJ.

Essa regra foi implementada utilizando triggers no PostgreSQL.

---

## 💳 Pagamentos

O modelo diferencia formas de pagamento cadastradas e pagamentos efetivamente realizados.

### Formas de pagamento cadastradas

```text
cliente
    ↓
cliente_forma_pagamento
    ↓
forma_pagamento
```

Isso permite que um cliente possua mais de uma forma de pagamento cadastrada.

### Pagamentos realizados

```text
pedido
    ↓
pagamento
    ↓
forma_pagamento
```

Um pedido pode possuir múltiplos registros de pagamento, permitindo representar situações como pagamento dividido entre diferentes formas.

---

## 🚚 Entrega

A entidade `entrega` está relacionada ao pedido e possui:

- status;
- código de rastreio;
- data de envio;
- data de entrega.

Exemplos de status:

```text
AGUARDANDO
ENVIADA
EM_TRANSITO
ENTREGUE
CANCELADA
```

O relacionamento foi modelado como:

```text
Pedido 1 ─── 0..1 Entrega
```

---

## 🔐 Integridade e constraints

O projeto utiliza diferentes mecanismos de integridade do PostgreSQL:

- `PRIMARY KEY`
- `FOREIGN KEY`
- `UNIQUE`
- `NOT NULL`
- `CHECK`
- `IDENTITY`
- triggers para regras de negócio

Entre as validações implementadas estão:

- e-mail de cliente único;
- CPF único;
- CNPJ único;
- preços não negativos;
- quantidades de estoque não negativas;
- quantidade de itens do pedido maior que zero;
- status controlados por `CHECK`;
- exclusividade entre PF e PJ.

---

## 📊 Consultas SQL

As consultas foram elaboradas para responder perguntas de negócio relacionadas ao e-commerce.

Entre elas:

- Quantos pedidos foram feitos por cada cliente?
- Quais clientes possuem mais de um pedido?
- Qual o total de cada pedido?
- Qual o faturamento por cliente?
- Quais produtos possuem maior quantidade vendida?
- Quais produtos geraram maior faturamento?
- Qual o estoque total de cada produto?
- Em quais estoques cada produto está disponível?
- Quais fornecedores estão relacionados a cada produto?
- Quais produtos possuem mais de um fornecedor?
- Algum vendedor também é fornecedor?
- Quantos pedidos existem por status?
- Quais pedidos possuem entrega?
- Quais pedidos ainda não possuem entrega?
- Quais pedidos possuem múltiplos pagamentos?

As consultas utilizam, entre outras, as seguintes cláusulas e recursos:

```text
SELECT
WHERE
ORDER BY
GROUP BY
HAVING
JOIN
LEFT JOIN
COUNT()
SUM()
```

Também foram utilizadas expressões para geração de atributos derivados, como subtotal de itens e total de pedidos.

---

## 🔎 Validação dos dados

Além das consultas analíticas, foram realizadas validações de consistência entre os valores dos pedidos e os pagamentos registrados.

A validação utiliza uma CTE (`WITH`) para calcular separadamente:

```text
Total dos itens do pedido
        ↓
Total dos pagamentos
        ↓
Diferença
```

Isso permite identificar eventuais diferenças entre o valor calculado a partir dos itens do pedido e o valor registrado nos pagamentos.

---

## 🛠️ Tecnologias

- PostgreSQL
- SQL
- VS Code
- Git
- GitHub

---

## 📚 Contexto

Este projeto foi desenvolvido como exercício prático de banco de dados e SQL, com foco em modelagem relacional, consultas e análise de dados.

O projeto também serve como base para estudos posteriores de SQL e Data/BI, especialmente para utilização do PostgreSQL como fonte de dados para análises e dashboards.

---

## 👨‍💻 Autor

**Lucio M Vale**

Projeto desenvolvido para fins de estudo, prática profissional e portfólio em Dados / Business Intelligence.
