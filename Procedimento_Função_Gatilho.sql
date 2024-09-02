-- Insere um novo caso e associa detetives, suspeitos e testemunhas ao caso. Utiliza transações para 
-- garantir que todas as operações sejam realizadas com sucesso ou revertidas em caso de erro.

DELIMITER //

CREATE PROCEDURE RegistrarCaso (
    IN pDescricao TEXT,
    IN pStatus CHAR(1),
    IN pDataAbertura DATE
)
BEGIN
    DECLARE vCaso_Id INT;
    -- Iniciar uma transação
    START TRANSACTION;
    BEGIN
        -- Inserir um novo caso
        INSERT INTO Caso (Descricao, Status, DataAbertura)
        VALUES (pDescricao, pStatus, pDataAbertura);
        SET vCaso_Id = LAST_INSERT_ID();
        -- Associar detetives ao caso
        INSERT INTO Investiga (Detetive_ID, Caso_Id)
        SELECT Detetive_ID, vCaso_Id
        FROM TempDetetives;
        -- Associar suspeitos ao caso
        INSERT INTO Envolve_Suspeito (Caso_Id, Suspeito_Id)
        SELECT vCaso_Id, Suspeito_Id
        FROM TempSuspeitos;
        -- Associar testemunhas ao caso
        INSERT INTO Testemunhado_Por (Caso_Id, Testemunha_Id)
        SELECT vCaso_Id, Testemunha_Id
        FROM TempTestemunhas;
        -- Commit da transação
        COMMIT;
    END;

    -- Limpar tabelas temporárias
    DROP TEMPORARY TABLE IF EXISTS TempDetetives;
    DROP TEMPORARY TABLE IF EXISTS TempSuspeitos;
    DROP TEMPORARY TABLE IF EXISTS TempTestemunhas;
END //

DELIMITER ;

-- Criar tabelas temporárias
CREATE TEMPORARY TABLE TempDetetives (Detetive_ID INT);
CREATE TEMPORARY TABLE TempSuspeitos (Suspeito_ID INT);
CREATE TEMPORARY TABLE TempTestemunhas (Testemunha_ID INT);

-- Inserir dados nas tabelas temporárias
INSERT INTO TempDetetives (Detetive_ID) VALUES (1), (2), (3);
INSERT INTO TempSuspeitos (Suspeito_ID) VALUES (4), (5);
INSERT INTO TempTestemunhas (Testemunha_ID) VALUES (6), (7);

-- Chamar o procedimento
CALL RegistrarCaso('Descrição do caso', 'A', '2024-05-27');

-- Verificar os dados na tabela Caso
SELECT * FROM Caso;

-- Verificar os dados na tabela Investiga
SELECT * FROM Investiga;

-- Verificar os dados na tabela Envolve_Suspeito
SELECT * FROM Envolve_Suspeito;

-- Verificar os dados na tabela Testemunhado_Por
SELECT * FROM Testemunhado_Por;

-- Conta o número de registros na tabela Caso onde o status é 'A' (aberto) e retorna esse valor.
 
DELIMITER //

CREATE FUNCTION NumeroCasosAbertos()
RETURNS INT
BEGIN
    DECLARE vNumCasos INT;

    SELECT COUNT(*)
    INTO vNumCasos
    FROM Caso
    WHERE Status = 'A';

    RETURN vNumCasos;
END;

DELIMITER ;

SELECT NumeroCasosAbertos() AS CasosAbertos;


-- Após a atualização de um registro na tabela Detetive, verifica se a data de contratação
-- é superior a 10 anos. Se for, atualiza o status do detetive para 'I' (inativo).

DELIMITER //

CREATE TRIGGER AtualizaStatusDetetive
AFTER UPDATE ON Detetive
FOR EACH ROW
BEGIN
    IF NEW.DataContratacao < DATE_SUB(CURDATE(), INTERVAL 10 YEAR) THEN
        UPDATE Detetive
        SET Status = 'I'
        WHERE Id = NEW.Id;
    END IF;
END //

DELIMITER ;

-- Atualizamos o seu salário.
UPDATE Detetive
SET Salario = 3300.00
WHERE Id = 3;

SELECT * FROM Detetive WHERE Id = 3;

-- Índice para otimizar consultas baseadas no nome do detetive
CREATE INDEX idx_detetive_nome ON Detetive(Nome);

SELECT * FROM Detetive
ORDER BY Nome;

EXPLAIN SELECT * FROM Detetive WHERE Nome = 'Carlos Santos';

-- Índice para otimizar consultas baseadas no status e data de abertura dos casos
CREATE INDEX idx_caso_status_data ON Caso(Status, DataAbertura);

SELECT * FROM Caso
WHERE Status = 'A';

EXPLAIN SELECT * FROM Caso WHERE Status = 'A' AND DataAbertura >= '2023-01-01';



