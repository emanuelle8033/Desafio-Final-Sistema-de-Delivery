USE db_delivery_system;

-- ============================================================
-- 1. FUNCTIONS
-- ============================================================
DELIMITER $$

-- Function: Formatar CPF
CREATE FUNCTION fn_formatarCPF(p_cpf VARCHAR(11))
RETURNS VARCHAR(14)
DETERMINISTIC
BEGIN
    RETURN CONCAT(
        SUBSTRING(p_cpf, 1, 3), '.',
        SUBSTRING(p_cpf, 4, 3), '.',
        SUBSTRING(p_cpf, 7, 3), '-',
        SUBSTRING(p_cpf, 10, 2)
    );
END$$

-- Function: Formatar CNPJ
CREATE FUNCTION fn_formatarCNPJ(p_cnpj VARCHAR(14))
RETURNS VARCHAR(18)
DETERMINISTIC
BEGIN
    RETURN CONCAT(
        SUBSTRING(p_cnpj, 1, 2), '.',
        SUBSTRING(p_cnpj, 3, 3), '.',
        SUBSTRING(p_cnpj, 6, 3), '/',
        SUBSTRING(p_cnpj, 9, 4), '-',
        SUBSTRING(p_cnpj, 13, 2)
    );
END$$

-- Function: Validar Senha
CREATE FUNCTION fn_validarSenha(p_senha VARCHAR(255))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    IF LENGTH(p_senha) >= 6 AND p_senha REGEXP '[0-9]' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END$$

-- Function: Encriptar Senha
CREATE FUNCTION fn_encriptarSenha(p_senha VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    RETURN SHA2(p_senha, 256);
END$$

DELIMITER ;

-- ============================================================
-- 2. PROCEDURES
-- ============================================================
DELIMITER $$

-- Procedure: Cadastrar Cliente
CREATE PROCEDURE sp_cadastrarCliente(
    IN p_nome VARCHAR(100),
    IN p_cpf VARCHAR(11),
    IN p_email VARCHAR(100),
    IN p_senha VARCHAR(255)
)
BEGIN
    IF fn_validarSenha(p_senha) = FALSE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Senha fraca! Minimo 6 digitos e 1 numero.';
    ELSE
        INSERT INTO usuarios (nome_completo, cpf, email, telefone, senha_hash)
        VALUES (p_nome, p_cpf, p_email, '11900000000', fn_encriptarSenha(p_senha));
        SELECT 'Cliente cadastrado com sucesso!' AS Mensagem;
    END IF;
END$$

-- Procedure: Cadastrar Entregador
CREATE PROCEDURE sp_cadastrarEntregador(
    IN p_nome VARCHAR(100),
    IN p_cpf VARCHAR(11),
    IN p_cnh VARCHAR(11),
    IN p_veiculo VARCHAR(20),
    IN p_placa VARCHAR(8)
)
BEGIN
    INSERT INTO entregadores (nome, cpf, cnh, veiculo_tipo, veiculo_placa)
    VALUES (p_nome, p_cpf, p_cnh, p_veiculo, p_placa);
    SELECT 'Entregador cadastrado com sucesso!' AS Mensagem;
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
    IF p_preco <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Preco invalido!';
    ELSE
        INSERT INTO produtos (id_restaurante, nome_produto, categoria, preco_unitario, estoque_qtd)
        VALUES (p_id_restaurante, p_nome, p_categoria, p_preco, p_estoque);
        SELECT 'Produto cadastrado com sucesso!' AS Mensagem;
    END IF;
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

    SELECT CONCAT('Pedido #', LAST_INSERT_ID(), ' criado! Total: R$ ', v_total) AS Mensagem;
END$$

DELIMITER ;

-- ============================================================
-- 3. TRIGGER
-- ============================================================
DELIMITER $$

CREATE TRIGGER tg_auditoria_pedido
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO historico_pedidos (id_pedido, dados_completos)
    VALUES (
        NEW.id_pedido,
        CONCAT('Usuario: ', NEW.id_usuario, ' | Restaurante: ', NEW.id_restaurante, ' | Valor: ', NEW.valor_total, ' | Status: ', NEW.status_pedido)
    );
END$$

DELIMITER ;

-- ============================================================
-- 4. VIEW
-- ============================================================
CREATE OR REPLACE VIEW vw_relatorio_regional AS
SELECT 
    r.nome_fantasia AS Restaurante,
    r.regiao AS Regiao,
    DATE_FORMAT(p.data_pedido, '%Y-%m') AS Mes_Ano,
    prod.nome_produto AS Produto,
    SUM(ip.quantidade) AS Qtd_Vendida,
    SUM(ip.preco_unitario_venda * ip.quantidade) AS Faturamento
FROM pedidos p
JOIN restaurantes r ON p.id_restaurante = r.id_restaurante
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produtos prod ON ip.id_produto = prod.id_produto
GROUP BY r.nome_fantasia, r.regiao, DATE_FORMAT(p.data_pedido, '%Y-%m'), prod.nome_produto;

-- ============================================================
-- 5. ÍNDICES
-- ============================================================
CREATE INDEX idx_restaurante_regiao ON restaurantes(regiao);
CREATE INDEX idx_pedido_data ON pedidos(data_pedido);

-- ============================================================
-- 6. TESTES
-- ============================================================

-- Testar Functions
SELECT fn_formatarCPF('12345678901') AS CPF;
SELECT fn_formatarCNPJ('12345678000100') AS CNPJ;
SELECT fn_validarSenha('senha123') AS Senha_Valida;
SELECT fn_encriptarSenha('minhaSenha123') AS Senha_Criptografada;

-- Inserir dados para teste (sem procedures)
INSERT INTO restaurantes VALUES (1, '12.345.678/0001-00', 'Burger King', 'Zona Norte', 5.00, TRUE);
INSERT INTO usuarios VALUES (1, 'Joao Silva', '123.456.789-01', 'joao@email.com', '11911111111', SHA2('senha123',256), NOW(), TRUE);
INSERT INTO entregadores VALUES (1, 'Mateus Entreg', '999.888.777-66', '12345678911', 'Moto', 'ABC-1234', TRUE);
INSERT INTO produtos VALUES (1, 1, 'Hamburguer', 'Lanche', 25.00, 50, TRUE);

-- Testar Procedures
CALL sp_cadastrarCliente('Maria Teste', '11122233344', 'maria@teste.com', 'senha123');

-- Testar Pedido via Procedure
CALL sp_cadastrarPedido(1, 1, 1, 2);

-- Ver View
SELECT * FROM vw_relatorio_regional;

-- Ver Auditoria
SELECT * FROM historico_pedidos;