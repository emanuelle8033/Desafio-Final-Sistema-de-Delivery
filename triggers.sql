USE db_delivery_system;
DELIMITER $$

CREATE TRIGGER tg_auditoria_pedido
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    -- Insert simples de espelho (em produção, use JSON ou tabela idêntica)
    INSERT INTO historico_pedidos (id_pedido, dados_completos)
    VALUES (
        NEW.id_pedido, 
        CONCAT('Pedido criado por Usuario:', NEW.id_usuario, ' | Valor:', NEW.valor_total, ' | Status:', NEW.status_pedido)
    );
END$$

DELIMITER ;