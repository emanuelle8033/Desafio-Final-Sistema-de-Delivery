-- ============================================================
-- 1. CRIA BANCO E TABELAS
-- ============================================================
DROP DATABASE IF EXISTS db_delivery_system;
CREATE DATABASE db_delivery_system;
USE db_delivery_system;

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome_completo VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    senha_hash VARCHAR(255) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE entregadores (
    id_entregador INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cnh VARCHAR(11) NOT NULL UNIQUE,
    veiculo_tipo VARCHAR(20),
    veiculo_placa VARCHAR(8),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE restaurantes (
    id_restaurante INT PRIMARY KEY AUTO_INCREMENT,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    nome_fantasia VARCHAR(100) NOT NULL,
    regiao VARCHAR(50) NOT NULL,
    taxa_entrega DECIMAL(10,2) DEFAULT 5.00,
    status_aberto BOOLEAN DEFAULT TRUE
);

CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    id_restaurante INT NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(20) NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    estoque_qtd INT DEFAULT 0,
    disponivel BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_restaurante) REFERENCES restaurantes(id_restaurante)
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_restaurante INT NOT NULL,
    id_entregador INT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(20) DEFAULT 'Recebido',
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_restaurante) REFERENCES restaurantes(id_restaurante),
    FOREIGN KEY (id_entregador) REFERENCES entregadores(id_entregador)
);

CREATE TABLE itens_pedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario_venda DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

CREATE TABLE historico_pedidos (
    id_audit INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    dados_completos TEXT,
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. CRIA FUNCTIONS
-- ============================================================
DELIMITER $$

CREATE FUNCTION fn_validarSenha(p_senha VARCHAR(255)) RETURNS BOOLEAN DETERMINISTIC
BEGIN IF LENGTH(p_senha) >= 6 AND p_senha REGEXP '[0-9]' THEN RETURN TRUE; ELSE RETURN FALSE; END IF; END$$

CREATE FUNCTION fn_encriptarSenha(p_senha VARCHAR(255)) RETURNS VARCHAR(255) DETERMINISTIC BEGIN RETURN SHA2(p_senha, 256); END$$

CREATE FUNCTION fn_formatarCPF(p_cpf VARCHAR(11)) RETURNS VARCHAR(14) DETERMINISTIC
BEGIN RETURN CONCAT(SUBSTRING(p_cpf, 1, 3), '.', SUBSTRING(p_cpf, 4, 3), '.', SUBSTRING(p_cpf, 7, 3), '-', SUBSTRING(p_cpf, 10, 2)); END$$

CREATE FUNCTION fn_formatarCNPJ(p_cnpj VARCHAR(14)) RETURNS VARCHAR(18) DETERMINISTIC
BEGIN RETURN CONCAT(SUBSTRING(p_cnpj, 1, 2), '.', SUBSTRING(p_cnpj, 3, 3), '.', SUBSTRING(p_cnpj, 6, 3), '/', SUBSTRING(p_cnpj, 9, 4), '-', SUBSTRING(p_cnpj, 13, 2)); END$$

DELIMITER ;

-- ============================================================
-- 3. CRIA PROCEDURES
-- ============================================================
DELIMITER $$

CREATE PROCEDURE sp_cadastrarCliente(IN p_nome VARCHAR(100), IN p_cpf VARCHAR(11), IN p_email VARCHAR(100), IN p_senha VARCHAR(255))
BEGIN
    INSERT INTO usuarios (nome_completo, cpf, email, telefone, senha_hash) VALUES (p_nome, p_cpf, p_email, '11900000000', fn_encriptarSenha(p_senha));
    SELECT CONCAT('Cliente ', p_nome, ' cadastrado!') AS Resultado;
END$$

CREATE PROCEDURE sp_cadastrarEntregador(IN p_nome VARCHAR(100), IN p_cpf VARCHAR(11), IN p_cnh VARCHAR(11), IN p_tipo VARCHAR(20), IN p_placa VARCHAR(8))
BEGIN
    INSERT INTO entregadores (nome, cpf, cnh, veiculo_tipo, veiculo_placa) VALUES (p_nome, p_cpf, p_cnh, p_tipo, p_placa);
    SELECT CONCAT('Entregador ', p_nome, ' OK!') AS Resultado;
END$$

CREATE PROCEDURE sp_cadastrarProduto(IN p_id_restaurante INT, IN p_nome VARCHAR(100), IN p_categoria VARCHAR(20), IN p_preco DECIMAL(10,2), IN p_estoque INT)
BEGIN
    INSERT INTO produtos (id_restaurante, nome_produto, categoria, preco_unitario, estoque_qtd) VALUES (p_id_restaurante, p_nome, p_categoria, p_preco, p_estoque);
    SELECT 'Produto cadastrado!' AS Resultado;
END$$

CREATE PROCEDURE sp_cadastrarPedido(IN p_id_usuario INT, IN p_id_restaurante INT, IN p_id_produto INT, IN p_qtd INT)
BEGIN
    DECLARE v_preco DECIMAL(10,2); DECLARE v_taxa DECIMAL(10,2); DECLARE v_total DECIMAL(10,2);
    SELECT preco_unitario INTO v_preco FROM produtos WHERE id_produto = p_id_produto;
    SELECT taxa_entrega INTO v_taxa FROM restaurantes WHERE id_restaurante = p_id_restaurante;
    SET v_total = (v_preco * p_qtd) + v_taxa;
    INSERT INTO pedidos (id_usuario, id_restaurante, valor_total) VALUES (p_id_usuario, p_id_restaurante, v_total);
    INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario_venda) VALUES (LAST_INSERT_ID(), p_id_produto, p_qtd, v_preco);
    UPDATE produtos SET estoque_qtd = estoque_qtd - p_qtd WHERE id_produto = p_id_produto;
    SELECT CONCAT('Pedido #', LAST_INSERT_ID(), ' - Total: R$ ', v_total) AS Resultado;
END$$

DELIMITER ;

-- ============================================================
-- 4. CRIA TRIGGER
-- ============================================================
DELIMITER $$

CREATE TRIGGER tg_auditoria_pedido AFTER INSERT ON pedidos FOR EACH ROW
BEGIN
    INSERT INTO historico_pedidos (id_pedido, dados_completos) VALUES (NEW.id_pedido, CONCAT('User:', NEW.id_usuario, ' | Valor:', NEW.valor_total));
END$$

DELIMITER ;

-- ============================================================
-- 5. CRIA VIEW
-- ============================================================
CREATE OR REPLACE VIEW vw_relatorio_regional AS
SELECT r.nome_fantasia AS Restaurante, r.regiao AS Regiao, p.status_pedido AS Status, SUM(ip.quantidade) AS Qtd, SUM(ip.preco_unitario_venda * ip.quantidade) AS Total
FROM pedidos p
JOIN restaurantes r ON p.id_restaurante = r.id_restaurante
JOIN itens_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY r.nome_fantasia, r.regiao, p.status_pedido;

-- ============================================================
-- 6. INSERE DADOS DE TESTE
-- ============================================================
INSERT INTO restaurantes VALUES (1, '12.345.678/0001-00', 'Burger King', 'Zona Norte', 5.00, TRUE);
INSERT INTO usuarios VALUES (1, 'Joao Silva', '12345678901', 'joao@email.com', '11911111111', SHA2('senha123',256), NOW(), TRUE);
INSERT INTO entregadores VALUES (1, 'Mateus Entreg', '99988877766', '12345678911', 'Moto', 'ABC-1234', TRUE);
INSERT INTO produtos VALUES (1, 1, 'Hamburguer', 'Lanche', 25.00, 50, TRUE);

-- ============================================================
-- 7. TESTA TUDO (Resultados automagicos)
-- ============================================================
SELECT '=== TESTE: Functions ===' AS Info;
SELECT fn_validarSenha('senha123') AS Senha_Valida;
SELECT fn_formatarCPF('12345678901') AS CPF_Formatado;
SELECT fn_encriptarSenha('minhaSenha') AS Senha_Criptografada;

SELECT '=== TESTE: sp_cadastrarCliente ===' AS Info;
CALL sp_cadastrarCliente('Maria Santos', '11122233344', 'maria@email.com', 'senha456');

SELECT '=== TESTE: sp_cadastrarEntregador ===' AS Info;
CALL sp_cadastrarEntregador('Pedro Silva', '22233344455', '12345678888', 'Moto', 'XYZ-9999');

SELECT '=== TESTE: sp_cadastrarProduto ===' AS Info;
CALL sp_cadastrarProduto(1, 'Pizza Mussarela', 'Pizza', 45.00, 30);

SELECT '=== TESTE: sp_cadastrarPedido ===' AS Info;
CALL sp_cadastrarPedido(1, 1, 1, 2);

SELECT '=== RESULTADO: Usuarios ===' AS Info;
SELECT * FROM usuarios;

SELECT '=== RESULTADO: Pedidos ===' AS Info;
SELECT * FROM pedidos;

SELECT '=== RESULTADO: Auditoria ===' AS Info;
SELECT * FROM historico_pedidos;

SELECT '=== RESULTADO: Relatorio ===' AS Info;
SELECT * FROM vw_relatorio_regional;