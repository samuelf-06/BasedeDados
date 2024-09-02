-- Tradução das interrogações do utilizador

-- Queries que devem cobrir as principais funcionalidades e necessidades descritas 
-- para o sistema de bases de dados da agência de detetives "Mundo Sóbrio".

USE MundoSobrio;
-- 1. Listar os detetives pela sua data de contratação
SELECT * FROM vw_DetetivesAtivosPorDataContratacao;

-- 2. Informar qual a cidade com maior número de suspeitos
SELECT Localidade, COUNT(Id) AS NumeroDeSuspeitos
FROM Suspeito
GROUP BY Localidade
LIMIT 1;

-- 3. Visualizar operações de uma determinada localização (por exemplo, "Braga") 
SELECT *
FROM vw_OperacoesPorLocalizacao
WHERE Localidade = 'Braga'; -- Substituir 'Braga' pela localização desejada

-- 4. Lista de drogas envolvidas em um determinado caso
SELECT c.Caso_Id, c.Descricao, d.Id AS Droga_Id, d.Nome AS Droga_Nome, d.Quantidade, d.DataApreensao, d.Valor, d.Origem
FROM Caso c
JOIN Envolve_Droga ed ON c.Caso_Id = ed.Caso_Id
JOIN Droga d ON ed.Droga_Id = d.Id;

-- 5. Lista de casos investigados por um determinado detetive
SELECT i.Detetive_ID, d.Nome AS Detetive_Nome, i.Caso_Id, c.Descricao
FROM Investiga i
JOIN Detetive d ON i.Detetive_ID = d.Id
JOIN Caso c ON i.Caso_Id = c.Caso_Id;

-- 6. Adicionar uma nova droga ao sistema
INSERT INTO Droga (Nome, Quantidade, DataApreensao, Valor, Origem)
VALUES ('Cocaína', 100, '2024-05-25', 50000.00, 'Colômbia');

-- 7. Atribuir um detetive a um caso específico
INSERT INTO Investiga (Detetive_ID, Caso_Id)
VALUES (5, 5); -- Substituir os valores pelos IDs reais do detetive e do caso

-- 8. Associar um suspeito a um caso
INSERT INTO Envolve_Suspeito (Caso_Id, Suspeito_Id)
VALUES (5, 5); -- Substituir os valores pelos IDs reais do caso e do suspeito

-- 9. Registrar uma nova testemunha e associá-la a um caso
INSERT INTO Testemunha (Nome, DataNascimento, Genero, Relato)
VALUES ('Maria Silva', '1985-03-20', 'F', 'Viu o suspeito próximo ao local do crime');

INSERT INTO Testemunhado_Por (Caso_Id, Testemunha_Id)
VALUES (1, LAST_INSERT_ID()); -- Usando LAST_INSERT_ID() para obter o ID da testemunha recém-inserida

-- 10. Lista de todos os casos em que um detetive está envolvido
SELECT d.Nome AS Detetive_Nome, c.Caso_Id, c.Descricao, i.Detetive_ID AS Investigador_ID
FROM Detetive d
LEFT JOIN Investiga i ON d.Id = i.Detetive_ID
LEFT JOIN Caso c ON i.Caso_Id = c.Caso_Id;

-- 11. Total de casos investigados por cada detetive
SELECT d.Nome AS Detetive_Nome, COUNT(i.Caso_Id) AS Total_Casos_Investigados
FROM Detetive d
LEFT JOIN Investiga i ON d.Id = i.Detetive_ID
GROUP BY d.Nome;

-- 12. Lista de detetives que ainda não supervisionam outros detetives
SELECT d.Nome AS Detetive_Nome
FROM Detetive d
LEFT JOIN Supervisao s ON d.Id = s.Detetive_ID_Supervisiona
WHERE s.Detetive_ID_Supervisiona IS NULL;

-- 13. Total de casos em que uma determinada droga está envolvida
SELECT d.Nome AS Droga, COUNT(ed.Caso_Id) AS Total_Casos_Envolvendo_Droga
FROM Droga d
LEFT JOIN Envolve_Droga ed ON d.Id = ed.Droga_Id
GROUP BY d.Nome;

-- 14. Média de idade dos suspeitos por cidade
SELECT Localidade, AVG(YEAR(CURRENT_DATE()) - YEAR(DataNascimento)) AS Media_Idade
FROM Suspeito
GROUP BY Localidade;

-- 15. Quantidade total de drogas apreendidas por cada origem
SELECT Origem, SUM(Quantidade) AS Quantidade_Total_Apreendida
FROM Droga
GROUP BY Origem;