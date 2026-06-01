# 🚀 Sistema de Delivery iFood-style (MySQL)

## Objetivo
Gerenciar restaurantes, clientes, entregadores e pedidos com alta integridade de dados.

## Estrutura do Projeto
/pasta-raiz
├── /docs               # Relatório Técnico
├── /scripts
│   ├── 01_ddl_schema.sql
│   ├── 02_dml_inserts.sql
│   ├── 03_functions.sql
│   ├── 04_procedures.sql
│   ├── 05_triggers.sql
│   └── 06_views_queries.sql
└── README.md

## Como Executar
1. Abra o MySQL Workbench/navicat.
2. Execute os scripts em ordem numérica (01 -> 06).
3. Para testar:
   - CALL sp_cadastrarCliente('Nome', 'cpfsemnada', 'email@teste', 'senha123');
   - SELECT * FROM vw_relatorio_regional;

## Vídeo Demonstrativo
https://youtu.be/hhamuK0CcVg

## Tecnologias
- MySQL 8.0+
- Functions (Hash, Formatação)
- Triggers (Auditoria)
- Stored Procedures (Lógica de Negócio)
- Views (Relatórios)

---
✅ Desafio Completo
