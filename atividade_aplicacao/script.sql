CREATE SCHEMA public;
SET SCHEMA 'public';

CREATE TABLE morador (
    pk_cpf VARCHAR(11) PRIMARY KEY, -- Definido tamanho de 11 para o CPF
    tipo_sang VARCHAR(3),
    telefone1 VARCHAR(15),
    telefone2 VARCHAR(15),
    cep VARCHAR(8),
    bairro VARCHAR(50),
    numero VARCHAR(10),
    rua VARCHAR(100),
    rg VARCHAR(20),
    data_nasc DATE,
    sexo CHAR(1),
    nome VARCHAR(100),
    peso FLOAT,
    altura FLOAT
);

CREATE TABLE agente (
    pk_licenca INT,
    fk_cpf VARCHAR(11),
    PRIMARY KEY (pk_licenca),  
    FOREIGN KEY (fk_cpf) REFERENCES morador(pk_cpf) ON DELETE CASCADE,
    UNIQUE (pk_licenca, fk_cpf)
);

CREATE TABLE alocacao (
    bairro VARCHAR(50),
    data DATE,
    pk_id INT PRIMARY KEY
);

CREATE TABLE visita (
    pk_id SERIAL PRIMARY KEY, -- Adicionado identificador único
    data DATE,
	hora TIME
);

CREATE TABLE suprimento (
    pk_id INT PRIMARY KEY,
    data_solicitada DATE,
    data_enviada DATE,
    data_efetuada DATE,
    nome VARCHAR(100),
    quantidade INT,
    fk_visita INT,
    FOREIGN KEY (fk_visita) REFERENCES visita(pk_id) ON DELETE CASCADE
);

CREATE TABLE consulta (
    posto VARCHAR(100),
    data DATE,
	hora TIME,
    fk_visita INT,
	fk_cpf VARCHAR(11), 
	FOREIGN KEY (fk_cpf) REFERENCES morador(pk_cpf) ON DELETE CASCADE,
    PRIMARY KEY (fk_cpf, posto, data, hora), -- Definido chave composta
    FOREIGN KEY (fk_visita) REFERENCES visita(pk_id) ON DELETE CASCADE
);

CREATE TABLE vacina (
    pk_id INT NOT NULL PRIMARY KEY,
    nome VARCHAR(100),
    data DATE,
    num_dose INT,
    fk_cpf VARCHAR(11),
    FOREIGN KEY (fk_cpf) REFERENCES morador(pk_cpf) ON DELETE CASCADE
);

CREATE TABLE relacao_possui (
    fk_alocacao_id INT,
    fk_licenca_agente INT,
    FOREIGN KEY (fk_alocacao_id) REFERENCES alocacao(pk_id) ON DELETE RESTRICT,
    FOREIGN KEY (fk_licenca_agente) REFERENCES agente(pk_licenca) ON DELETE RESTRICT
);

CREATE TABLE relacao_visita (
    fk_licenca_agente INT,
    fk_visita INT,
	fk_cpf VARCHAR(11),
    FOREIGN KEY (fk_cpf) REFERENCES morador(pk_cpf) ON DELETE CASCADE,
    FOREIGN KEY (fk_licenca_agente) REFERENCES agente(pk_licenca) ON DELETE CASCADE,
    FOREIGN KEY (fk_visita) REFERENCES visita(pk_id) ON DELETE CASCADE,
	UNIQUE (fk_licenca_agente, fk_visita, fk_cpf)
);


-- Inserção de dados na tabela morador
INSERT INTO morador (pk_cpf, tipo_sang, telefone1, telefone2, cep, bairro, numero, rua, rg, data_nasc, sexo, nome, peso, altura)
VALUES 
('12345678901', 'O+', '11987654321', '11987654322', '01001000', 'Centro', '123', 'Rua A', '12345678-9', '1990-01-01', 'M', 'José Batista', 70.5, 1.75),
('23456789012', 'A-', '11987654323', '11987654324', '02002000', 'Jardim', '456', 'Rua B', '23456789-0', '1992-02-02', 'F', 'Larissa Matos', 65.2, 1.68),
('34567890123', 'B+', '11987654325', '11987654326', '03003000', 'Vila Nova', '789', 'Rua C', '34567890-1', '1988-03-03', 'M', 'Gabriel Ileis', 80.1, 1.80),
('45678901234', 'AB-', '11987654327', '11987654328', '04004000', 'Campo Alegre', '321', 'Rua D', '45678901-2', '1995-04-04', 'F', 'Lívia Almada', 55.3, 1.65),
('56789012345', 'O-', '11987654329', '11987654330', '05005000', 'Praia', '654', 'Rua E', '56789012-3', '1990-05-05', 'M', 'Paulo Armando', 85.0, 1.85),
('67890123456', 'A+', '11987654331', '11987654332', '06006000', 'Serra', '987', 'Rua F', '67890123-4', '1985-06-06', 'M', 'Francisco Helder', 75.4, 1.78),
('78901234567', 'B-', '11987654333', '11987654334', '07007000', 'Lagoa', '234', 'Rua G', '78901234-5', '1998-07-07', 'M', 'Marcos Dantas', 78.6, 1.77),
('89012345678', 'AB+', '11987654335', '11987654336', '08008000', 'Floresta', '345', 'Rua H', '89012345-6', '1980-08-08', 'M', 'Marcelo Martins', 82.3, 1.82),
('90123456789', 'O-', '11987654337', '11987654338', '09009000', 'Centro', '456', 'Rua I', '90123456-7', '1983-09-09', 'M', 'Samuel Henrique', 70.9, 1.75),
('01234567890', 'A-', '11987654339', '11987654340', '10010000', 'Jardim Paulista', '789', 'Rua J', '01234567-8', '1979-10-10', 'M', 'Joel Ramiro', 90.2, 1.90);

-- Inserção de dados na tabela agente
INSERT INTO agente (pk_licenca, fk_cpf)
VALUES 
(1001, '12345678901'),
(1002, '23456789012'),
(1003, '34567890123'),
(1004, '45678901234'),
(1005, '56789012345'),
(1006, '67890123456'),
(1007, '78901234567'),
(1008, '89012345678'),
(1009, '90123456789'),
(1010, '01234567890');

-- Inserção de dados na tabela alocacao
INSERT INTO alocacao (bairro, data, pk_id)
VALUES 
('Centro', '2024-08-01', 1),
('Jardim', '2024-08-02', 2),
('Vila Nova', '2024-08-03', 3),
('Campo Alegre', '2024-08-04', 4),
('Praia', '2024-08-05', 5),
('Serra', '2024-08-06', 6),
('Lagoa', '2024-08-07', 7),
('Floresta', '2024-08-08', 8),
('Centro', '2024-08-09', 9),
('Jardim Paulista', '2024-08-10', 10);

-- Inserção de dados na tabela visita
INSERT INTO visita (data, hora)
VALUES 
('2024-08-11', '09:00'),
('2024-08-12', '10:00'),
('2024-08-13', '11:00'),
('2024-08-14', '12:00'),
('2024-08-15', '13:00'),
('2024-08-16', '14:00'),
('2024-08-17', '15:00'),
('2024-08-18', '16:00'),
('2024-08-19', '17:00'),
('2024-08-20', '18:00');

-- Inserção de dados na tabela suprimento
INSERT INTO suprimento (pk_id, data_solicitada, data_enviada, data_efetuada, nome, quantidade, fk_visita)
VALUES 
(1, '2024-08-01', '2024-08-05', '2024-08-10', 'Máscaras', 100, 1),
(2, '2024-08-02', '2024-08-06', '2024-08-11', 'Álcool Gel', 200, 2),
(3, '2024-08-03', '2024-08-07', '2024-08-12', 'Luvas', 300, 3),
(4, '2024-08-04', '2024-08-08', '2024-08-13', 'Respiradores', 400, 4),
(5, '2024-08-05', '2024-08-09', '2024-08-14', 'Vacinas', 500, 5),
(6, '2024-08-06', '2024-08-10', '2024-08-15', 'Soros', 600, 6),
(7, '2024-08-07', '2024-08-11', '2024-08-16', 'Testes Covid', 700, 7),
(8, '2024-08-08', '2024-08-12', '2024-08-17', 'EPI', 800, 8),
(9, '2024-08-09', '2024-08-13', '2024-08-18', 'Medicamentos', 900, 9),
(10, '2024-08-10', '2024-08-14', '2024-08-19', 'Oxímetros', 1000, 10);

-- Inserção de dados na tabela consulta
INSERT INTO consulta (posto, data, hora, fk_visita, fk_cpf)
VALUES 
('Posto 1', '2024-08-11', '09:00', 1, '12345678901'),
('Posto 2', '2024-08-12', '10:00', 2, '23456789012'),
('Posto 3', '2024-08-13', '11:00', 3, '34567890123'),
('Posto 4', '2024-08-14', '12:00', 4, '45678901234'),
('Posto 5', '2024-08-15', '13:00', 5, '56789012345'),
('Posto 6', '2024-08-16', '14:00', 6, '67890123456'),
('Posto 7', '2024-08-17', '15:00', 7, '78901234567'),
('Posto 8', '2024-08-18', '16:00', 8, '89012345678'),
('Posto 9', '2024-08-19', '17:00', 9, '90123456789'),
('Posto 10', '2024-08-20', '18:00', 10, '01234567890');

-- Inserção de dados na tabela vacina
INSERT INTO vacina (pk_id, nome, data, num_dose, fk_cpf)
VALUES 
(1, 'BCG', '2024-01-01', 1, '12345678901'),
(2, 'Hepatite B', '2024-02-01', 1, '23456789012'),
(3, 'Penta', '2024-03-01', 1, '34567890123'),
(4, 'VIP', '2024-04-01', 1, '45678901234'),
(5, 'Rotavírus', '2024-05-01', 1, '56789012345'),
(6, 'Pneumocócica', '2024-06-01', 1, '67890123456'),
(7, 'Meningocócica', '2024-07-01', 1, '78901234567'),
(8, 'Febre Amarela', '2024-08-01', 1, '89012345678'),
(9, 'Tetra Viral', '2024-09-01', 1, '90123456789'),
(10, 'HPV', '2024-10-01', 1, '01234567890');

-- Inserção de dados na tabela relacao_possui
INSERT INTO relacao_possui (fk_alocacao_id, fk_licenca_agente)
VALUES 
(1, 1001),
(2, 1002),
(3, 1003),
(4, 1004),
(5, 1005),
(6, 1006),
(7, 1007),
(8, 1008),
(9, 1009),
(10, 1010);

-- Inserção de dados na tabela relacao_visita
INSERT INTO relacao_visita (fk_licenca_agente, fk_visita, fk_cpf)
VALUES 
(1001, 1, '12345678901'),
(1002, 2, '23456789012'),
(1003, 3, '34567890123'),
(1004, 4, '45678901234'),
(1005, 5, '56789012345'),
(1006, 6, '67890123456'),
(1007, 7, '78901234567'),
(1008, 8, '89012345678'),
(1009, 9, '90123456789'),
(1010, 10, '01234567890');
