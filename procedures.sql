USE db_delivery_system;

-- Procedure: Cadastrar Cliente
DELIMITER $$

CREATE PROCEDURE sp_cadastrarCliente(
    IN p_nome VARCHAR(100),
    IN p_cpf VARCHAR(11),
    IN p_email VARCHAR(100),
    IN p_senha VARCHAR(255)
)
BEGIN
    INSERT INTO usuarios (nome_completo, cpf, email, telefone, senha_hash)
    VALUES (p_nome, p_cpf, p_email, '11900000000', SHA2(p_senha, 256));
    
    SELECT CONCAT('Cliente ', p_nome, ' cadastrado!') AS Resultado;
END$$

-- Procedure: Cadastrar Entregador
CREATE PROCEDURE sp_cadastrarEntregador(
    IN p_nome VARCHAR(100),
    IN p_cpf VARCHAR(11),
    IN p_cnh VARCHAR(11),
    IN p_tipo VARCHAR(20),
    IN p_placa VARCHAR(8)
)
BEGIN
    INSERT INTO entregadores (nome, cpf, cnh, veiculo_tipo, veiculo_placa)
    VALUES (p_nome, p_cpf, p_cnh, p_tipo, p_placa);
    
    SELECT CONCAT('Entregador ', p_nome, ' OK!') AS Resultado;
END$$

-- Procedure: Cadastrar Produto
CREATE PROCEDURE sp_cadastrarProduto(
    IN p_id_restaurante INT,
    IN p_nome VARCHAR(100),
    IN p_categoria VARCHAR(20),
    IN p_preco DECIMAL(10,2),
    IN p_estoque INT
)
BEGIN
    INSERT INTO produtos (id_restaurante, nome_produto, categoria, preco_unitario, estoque_qtd)
    VALUES (p_id_restaurante, p_nome, p_categoria, p_preco, p_estoque);
    
    SELECT 'Produto cadastrado!' AS Resultado;
END$$

-- Procedure: Cadastrar Pedido
CREATE PROCEDURE sp_cadastrarPedido(
    IN p_id_usuario INT,
    IN p_id_restaurante INT,
    IN p_id_produto INT,
    IN p_qtd INT
)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_taxa DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    
    SELECT preco_unitario INTO v_preco FROM produtos WHERE id_produto = p_id_produto;
    SELECT taxa_entrega INTO v_taxa FROM restaurantes WHERE id_restaurante = p_id_restaurante;
    
    SET v_total = (v_preco * p_qtd) + v_taxa;
    
    INSERT INTO pedidos (id_usuario, id_restaurante, valor_total)
    VALUES (p_id_usuario, p_id_restaurante, v_total);
    
    INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario_venda)
    VALUES (LAST_INSERT_ID(), p_id_produto, p_qtd, v_preco);
    
    UPDATE produtos SET estoque_qtd = estoque_qtd - p_qtd WHERE id_produto = p_id_produto;
    
    SELECT CONCAT('Pedido #', LAST_INSERT_ID(), ' - Total: R$ ', v_total) AS Resultado;
END$$

DELIMITER ;