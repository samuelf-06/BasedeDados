-- Conjunto de vistas de utilização (VIEW)

USE MundoSobrio;

-- 1. Lista dos detetives ativos pela data de contratação
CREATE VIEW vw_DetetivesAtivosPorDataContratacao AS
SELECT Id, Nome, DataContratacao
FROM Detetive
WHERE Status = 'A'
ORDER BY DataContratacao;

-- 2. Lista de detetives que supervisionam outros detetives
CREATE VIEW vw_DetetivesQueSupervisionam AS
SELECT s.Detetive_ID_Supervisiona AS Supervisor_Id, d.Nome AS Supervisor_Nome, s.Detetive_ID AS Subordinado_Id, d2.Nome AS Subordinado_Nome
FROM Supervisao s
JOIN Detetive d ON s.Detetive_ID_Supervisiona = d.Id
JOIN Detetive d2 ON s.Detetive_ID = d2.Id;

-- 3. Lista de suspeitos por caso
CREATE VIEW vw_SuspeitosPorCaso AS
SELECT c.Caso_Id, c.Descricao, s.Id AS Suspeito_Id, s.Nome, s.NivelEnvolvimento
FROM Caso c
JOIN Envolve_Suspeito es ON c.Caso_Id = es.Caso_Id
JOIN Suspeito s ON es.Suspeito_Id = s.Id;

-- 4. Lista de drogas por suspeito
CREATE VIEW vw_DrogasPorSuspeito AS
SELECT s.Id AS Suspeito_Id, s.Nome, d.Id AS Droga_Id, d.Nome AS Droga_Nome, d.Quantidade, d.DataApreensao, d.Valor, d.Origem
FROM Suspeito s
JOIN De_Droga dd ON s.Id = dd.Suspeito_Id
JOIN Droga d ON dd.Droga_Id = d.Id;

-- 5. Lista de testemunhas por caso
CREATE VIEW vw_TestemunhasPorCaso AS
SELECT c.Caso_Id, c.Descricao, t.Id AS Testemunha_Id, t.Nome, t.Relato
FROM Caso c
JOIN Testemunhado_Por tp ON c.Caso_Id = tp.Caso_Id
JOIN Testemunha t ON tp.Testemunha_Id = t.Id;

-- 6. Lista dos casos ordenadas por data de abertura e cujo estado seja ativo
CREATE VIEW vw_OperacoesAtivasPorDataAbertura AS
SELECT Caso_Id, Descricao, DataAbertura, Status
FROM Caso
WHERE Status = 'A'
ORDER BY DataAbertura;

-- 7. Visualizar todas as operações por localização
CREATE VIEW vw_OperacoesPorLocalizacao AS
SELECT c.Caso_Id, c.Descricao, c.DataAbertura, c.Status, s.Localidade
FROM Caso c
JOIN Envolve_Suspeito es ON c.Caso_Id = es.Caso_Id
JOIN Suspeito s ON es.Suspeito_Id = s.Id
ORDER BY s.Localidade;

-- 8. Relatório do número de detenções e apreensões diárias
CREATE VIEW vw_DetencoesEApreensoesDiarias AS
SELECT d.DataApreensao AS Data, COUNT(DISTINCT s.Id) AS NumeroDeDetencoes, COUNT(DISTINCT d.Id) AS NumeroDeApreensoes
FROM Droga d
JOIN De_Droga dd ON d.Id = dd.Droga_Id
JOIN Suspeito s ON dd.Suspeito_Id = s.Id
GROUP BY d.DataApreensao
ORDER BY d.DataApreensao;

-- Usar as VIEWS
SELECT * FROM vw_DetetivesAtivosPorDataContratacao;
SELECT * FROM vw_DetetivesQueSupervisionam;
SELECT * FROM vw_SuspeitosPorCaso;
SELECT * FROM vw_DrogasPorSuspeito;
SELECT * FROM vw_TestemunhasPorCaso;
SELECT * FROM vw_OperacoesAtivasPorDataAbertura;
SELECT * FROM vw_OperacoesPorLocalizacao;
SELECT * FROM vw_DetencoesEApreensoesDiarias;