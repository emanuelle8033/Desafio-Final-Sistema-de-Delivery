-- 1. CRIAÇÃO DO BANCO
CREATE DATABASE IF NOT EXISTS db_delivery_system;
USE db_delivery_system;

-- 2. TABELAS

-- Tabela de Usuários (Clientes)
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome_completo VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    senha_hash VARCHAR(255) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Tabela de Entregadores
CREATE TABLE IF NOT EXISTS entregadores (
    id_entregador INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cnh VARCHAR(11) NOT NULL UNIQUE,
    veiculo_tipo ENUM('Moto', 'Carro', 'Bicicleta') DEFAULT 'Moto',
    veiculo_placa VARCHAR(8),
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Tabela de Restaurantes
CREATE TABLE IF NOT EXISTS restaurantes (
    id_restaurante INT PRIMARY KEY AUTO_INCREMENT,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    nome_fantasia VARCHAR(100) NOT NULL,
    regiao VARCHAR(50) NOT NULL, -- Ex: Norte, Sul, Leste
    taxa_entrega DECIMAL(10,2) DEFAULT 5.00,
    status_aberto BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Tabela de Produtos (Cardápio)
CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    id_restaurante INT NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    categoria ENUM('Lanche', 'Pizza', 'Bebida', 'Sobremesa') NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    estoque_qtd INT DEFAULT 0,
    disponivel BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_restaurante) REFERENCES restaurantes(id_restaurante) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Tabela de Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_restaurante INT NOT NULL,
    id_entregador INT NULL, -- Pode ser nulo até ser aceito
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('Recebido', 'Preparando', 'Saiu_Entrega', 'Entregue', 'Cancelado') DEFAULT 'Recebido',
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_restaurante) REFERENCES restaurantes(id_restaurante),
    FOREIGN KEY (id_entregador) REFERENCES entregadores(id_entregador)
) ENGINE=InnoDB;

-- Tabela de Itens do Pedido
CREATE TABLE IF NOT EXISTS itens_pedido (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario_venda DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
) ENGINE=InnoDB;

-- Tabela de Auditoria (Espelho do Pedido)
CREATE TABLE IF NOT EXISTS historico_pedidos (
    id_audit INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    dados_completos TEXT, -- Aquí we'll store a JSON representation
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. ÍNDICES (RNF04: Otimização por região e data)
CREATE INDEX idx_restaurante_regiao ON restaurantes(regiao);
CREATE INDEX idx_pedido_data ON pedidos(data_pedido);
CREATE INDEX idx_usuario_cpf ON usuarios(cpf);