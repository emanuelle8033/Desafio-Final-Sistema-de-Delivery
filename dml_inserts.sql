USE db_delivery_system;

-- INSERTS: USUARIOS (RF01)
INSERT INTO usuarios (nome_completo, cpf, email, telefone, senha_hash) VALUES 
('João Silva', '12345678901', 'joao@email.com', '11911111111', SHA2('senha123', 256)),
('Maria Santos', '23456789012', 'maria@email.com', '11922222222', SHA2('senha456', 256)),
('Pedro Costa', '34567890123', 'pedro@email.com', '11933333333', SHA2('senha789', 256)),
('Ana Oliveira', '45678901234', 'ana@email.com', '11944444444', SHA2('senha101', 256)),
('Lucas Souza', '56789012345', 'lucas@email.com', '11955555555', SHA2('senha202', 256)),
('Juliana Pereira', '67890123456', 'juliana@email.com', '11966666666', SHA2('senha303', 256)),
('Carlos Almeida', '78901234567', 'carlos@email.com', '11977777777', SHA2('senha404', 256)),
('Fernanda Lima', '89012345678', 'fernanda@email.com', '11988888888', SHA2('senha505', 256)),
('Roberto Ferreira', '90123456789', 'roberto@email.com', '11999999999', SHA2('senha606', 256)),
('Patricia Rodrigues', '01234567890', 'patricia@email.com', '11910101010', SHA2('senha707', 256)),
('Marcio Dias', '11223344556', 'marcio@email.com', '11920202020', SHA2('senha808', 256)),
('Tatiana Melo', '22334455667', 'tatiana@email.com', '11930303030', SHA2('senha909', 256)),
('Ricardo Barbosa', '33445566778', 'ricardo@email.com', '11940404040', SHA2('senha010', 256)),
('Larissa Castro', '44556677889', 'larissa@email.com', '11950505050', SHA2('senha111', 256)),
('Fernando Gomes', '55667788990', 'fernando@email.com', '11960606060', SHA2('senha222', 256)),
('Gabriela Rocha', '66778899001', 'gabriela@email.com', '11970707070', SHA2('senha333', 256)),
('Diego Martins', '77889900112', 'diego@email.com', '11980808080', SHA2('senha444', 256)),
('Camila Cardoso', '88990011223', 'camila@email.com', '11990909090', SHA2('senha555', 256)),
('Rafael Torres', '99001122334', 'rafael@email.com', '11910101011', SHA2('senha666', 256)),
('Beatriz Lima', '00112233445', 'beatriz@email.com', '11920202022', SHA2('senha777', 256));

-- INSERTS: ENTREGADORES (RF02)
INSERT INTO entregadores (nome, cpf, cnh, veiculo_tipo, veiculo_placa) VALUES 
('Mateus Oliveira', '12398765400', '12345678911', 'Moto', 'ABC-1234'),
('José Santos', '23487654321', '23456789122', 'Carro', 'XYZ-9876'),
('Antonio Lima', '34576543210', '34567891233', 'Moto', 'DEF-5678'),
('Paulo Ferreira', '45665432109', '45678912344', 'Bicicleta', 'N/A'),
('Bruno Almeida', '56754321098', '56789123455', 'Moto', 'GHI-3456'),
('Fernando Dias', '67843210987', '67891234566', 'Carro', 'JKL-7890'),
('Leonardo Costa', '78932109876', '78912345677', 'Moto', 'MNO-1234'),
('Gustavo Rodrigues', '89021098765', '89023456788', 'Moto', 'PQR-5678'),
('Daniel Martins', '90110987654', '90134567899', 'Carro', 'STU-9012'),
('Thiago Pereira', '01209876543', '01245678900', 'Moto', 'VWX-3456'),
('Vinicius Sousa', '11208765432', '11256789011', 'Bicicleta', 'N/A'),
('Hugo Castro', '22307654321', '22367890122', 'Moto', 'YZA-7890'),
('Igor Santos', '33406543210', '33478901233', 'Carro', 'BCD-1234'),
('Lucas Lima', '44505432109', '44589012344', 'Moto', 'EFG-5678'),
('Mateus Henrique', '55604321098', '55690123455', 'Moto', 'HIJ-9012'),
('Nicolas Ferreira', '66703210987', '66701234566', 'Carro', 'KLM-3456'),
('Gabriel Dias', '77802109876', '77812345677', 'Moto', 'NOP-7890'),
('Eduardo Costa', '88901098765', '88923456788', 'Moto', 'QRS-1234'),
('Victor Rodrigues', '99000987654', '99034567899', 'Carro', 'TUV-5678'),
('Bruno Martins', '00109876543', '00145678900', 'Moto', 'WXY-9012');

-- INSERTS: RESTAURANTES (RF03)
INSERT INTO restaurantes (cnpj, nome_fantasia, regiao, taxa_entrega) VALUES 
('12345678000100', 'Hamburguer King', 'Zona Norte', 5.00),
('23456789000111', 'Pizza Express', 'Zona Sul', 6.00),
('34567890000122', 'Sushi House', 'Zona Oeste', 8.00),
('45678901000133', 'Burger Premium', 'Zona Leste', 5.50),
('56789012000144', 'Pastelaria Central', 'Centro', 4.00),
('67890123000155', 'Churrascaria Grill', 'Zona Norte', 10.00),
('78901234000166', 'Doces & Bolos', 'Zona Sul', 5.00),
('89012345000177', 'Lanches Fast', 'Zona Leste', 4.50),
('90123456000188', 'Pitzaria Italy', 'Centro', 7.00),
('01234567000199', 'Salgados Tudo', 'Zona Oeste', 4.00);

-- INSERTS: PRODUTOS (Cardápio - RF04)
INSERT INTO produtos (id_restaurante, nome_produto, categoria, preco_unitario, estoque_qtd) VALUES 
(1, 'Hambúrguer Classic', 'Lanche', 25.00, 50),
(1, 'Batata Frita Média', 'Lanche', 15.00, 40),
(1, 'Refrigerante Lata', 'Bebida', 5.00, 100),
(2, 'Pizza Mussarela', 'Pizza', 45.00, 30),
(2, 'Pizza Calabresa', 'Pizza', 50.00, 30),
(2, 'Refrigerante 2L', 'Bebida', 12.00, 50),
(3, 'Sushi Salmão', 'Lanche', 35.00, 20),
(3, 'Sashimi Mix', 'Lanche', 40.00, 15),
(3, 'Bebida Soja', 'Bebida', 8.00, 30),
(4, 'Burger Duplo', 'Lanche', 30.00, 40),
(4, 'Milkshake Chocolate', 'Sobremesa', 18.00, 25),
(5, 'Pastel de Carne', 'Lanche', 8.00, 50),
(5, 'Pastel de Queijo', 'Lanche', 8.00, 50),
(6, 'Picanha na Brasa', 'Lanche', 85.00, 15),
(6, 'Fraldinha', 'Lanche', 65.00, 15),
(7, 'Bolo de Chocolate', 'Sobremesa', 12.00, 20),
(7, 'Pudim de Leite', 'Sobremesa', 10.00, 25),
(8, 'Hot Dog Especial', 'Lanche', 18.00, 45),
(9, 'Pizza Portuguesa', 'Pizza', 55.00, 25),
(10, 'Coxinha', 'Lanche', 6.00, 60);

-- INSERTS: PEDIDOS (RF05)
INSERT INTO pedidos (id_usuario, id_restaurante, id_entregador, status_pedido, valor_total) VALUES 
(1, 1, 1, 'Entregue', 55.00),
(2, 2, 2, 'Saiu_Entrega', 65.00),
(3, 3, 3, 'Preparando', 43.00),
(4, 4, NULL, 'Recebido', 48.00),
(5, 5, 1, 'Entregue', 20.00),
(6, 6, 2, 'Entregue', 150.00),
(7, 7, 3, 'Cancelado', 0.00),
(8, 8, 4, 'Saiu_Entrega', 30.00),
(9, 9, 5, 'Preparando', 70.00),
(10, 10, NULL, 'Recebido', 15.00);

-- INSERTS: ITENS DO PEDIDO (RF05)
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario_venda) VALUES 
(1, 1, 2, 25.00), -- 2 Hamburguer
(1, 3, 1, 5.00),  -- 1 Refrigerante
(2, 4, 1, 45.00), -- 1 Pizza Mussarela
(2, 6, 1, 12.00), -- 1 Refrigerante 2L
(3, 7, 1, 35.00), -- 1 Sushi Salmão
(4, 10, 1, 30.00), -- 1 Burger Duplo
(5, 13, 2, 8.00), -- 2 Pastel Queijo
(6, 14, 1, 85.00), -- 1 Picanha
(8, 18, 2, 18.00), -- 2 Hot Dog
(9, 19, 1, 55.00); -- 1 Pizza Portuguesas