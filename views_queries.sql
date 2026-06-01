USE db_delivery;

-- View Relatório Regional
CREATE OR REPLACE VIEW vw_relatorio_regional AS
SELECT 
    r.regiao AS Regiao_Restaurante,
    DATE(p.data_pedido) AS Data_Pedido,
    p.id AS Numero_Pedido,
    u.nome AS Cliente,
    pr.nome AS Produto,
    ip.quantidade,
    ip.preco_venda,
    (ip.preco_venda * ip.quantidade) AS Total_Item,
    p.valor_total AS Total_Pedido,
    p.status_pedido
FROM tb_pedidos p
INNER JOIN tb_restaurantes r ON p.restaurante_id = r.id
INNER JOIN tb_usuarios u ON p.cliente_id = u.id
INNER JOIN tb_itens_pedido ip ON p.id = ip.pedido_id
INNER JOIN tb_produtos pr ON ip.produto_id = pr.id
WHERE r.regiao IS NOT NULL;

-- Exemplos de UPDATE e DELETE
-- 1. Alterar Status do Pedido
UPDATE tb_pedidos SET status_pedido = 'Entregue' WHERE id = 1;

-- 2. Inativar Produto
UPDATE tb_produtos SET is_ativo = FALSE WHERE id = 3;

-- 3. Deletar Cliente Específico
DELETE FROM tb_usuarios WHERE id = 5;

-- 4. Deletar Item de Pedido
DELETE FROM tb_itens_pedido WHERE pedido_id = 1 AND produto_id = 1;

-- 5. Atualizar Estoque (após venda)
UPDATE tb_produtos SET estoque = estoque - 1 WHERE id = 1;