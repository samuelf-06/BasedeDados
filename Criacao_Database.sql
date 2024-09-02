-- Create the Database/ Schema
DROP SCHEMA IF EXISTS MundoSobrio;
CREATE SCHEMA MundoSobrio;
USE MundoSobrio;

-- Create Tables

-- Table Detetive
CREATE TABLE IF NOT EXISTS Detetive (
  Id INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(75) NOT NULL,
  DataNascimento DATE NOT NULL,
  Genero CHAR(1) NOT NULL,
  Status CHAR(1) NOT NULL,
  DataContratacao DATE NOT NULL,
  Salario DECIMAL(8,2) NOT NULL,
  PRIMARY KEY  (Id)
);

-- TABLE Supervisão
CREATE TABLE IF NOT EXISTS Supervisao (
    Detetive_ID_Supervisiona INT NOT NULL,
	Detetive_ID INT NOT NULL,
    PRIMARY KEY (Detetive_ID, Detetive_ID_Supervisiona),
    FOREIGN KEY (Detetive_ID_Supervisiona) REFERENCES Detetive (Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Detetive_ID) REFERENCES Detetive (Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table Caso
CREATE TABLE IF NOT EXISTS Caso (
	Caso_Id INT NOT NULL AUTO_INCREMENT,
    Descricao TEXT NOT NULL,
    Status CHAR(1) NOT NULL,
    DataAbertura DATE NOT NULL,
    PRIMARY KEY (Caso_Id)
);

-- Table Investiga
CREATE TABLE IF NOT EXISTS Investiga (
    Detetive_ID INT NOT NULL,
	Caso_Id INT NOT NULL,
    PRIMARY KEY (Detetive_ID, Caso_Id),
    FOREIGN KEY (Detetive_ID) REFERENCES Detetive (Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Caso_Id) REFERENCES Caso (Caso_Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table Suspeito
CREATE TABLE IF NOT EXISTS Suspeito (
  Id INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(75) NOT NULL,
  DataNascimento DATE NOT NULL,
  Genero CHAR(1) NOT NULL,
  NivelEnvolvimento ENUM('Suspeito', 'Acusado', 'Condenado') NOT NULL,
  Status CHAR(1) NOT NULL,
  HistoricoCriminal TEXT,
  Rua VARCHAR(75) NOT NULL,
  CodPostal VARCHAR(75) NOT NULL,
  Localidade VARCHAR(75) NOT NULL,
  PRIMARY KEY (Id)
);

-- Table Contactos_Suspeito
CREATE TABLE IF NOT EXISTS Contactos_Suspeito (
    Suspeito_ID INT NOT NULL,
	Contactos VARCHAR(75) NOT NULL,
    PRIMARY KEY (Suspeito_ID, Contactos),
    FOREIGN KEY (Suspeito_ID) REFERENCES Suspeito (Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table Testemunha
CREATE TABLE IF NOT EXISTS Testemunha (
  Id INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(75) NOT NULL,
  DataNascimento DATE NOT NULL,
  Genero CHAR(1) NOT NULL,
  Relato TEXT NOT NULL,
  PRIMARY KEY (Id)
);

-- Table Contactos_Testemunha
CREATE TABLE IF NOT EXISTS Contactos_Testemunha (
    Testemunha_ID INT NOT NULL,
	Contactos VARCHAR(75) NOT NULL,
    PRIMARY KEY (Testemunha_ID, Contactos),
    FOREIGN KEY (Testemunha_ID) REFERENCES Testemunha (Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table Testemunhado_Por
CREATE TABLE IF NOT EXISTS Testemunhado_Por (
    Caso_Id INT NOT NULL,
	Testemunha_Id INT NOT NULL,
    PRIMARY KEY (Caso_Id, Testemunha_Id),
    FOREIGN KEY (Caso_Id) REFERENCES Caso (Caso_Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Testemunha_Id) REFERENCES Testemunha (Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table Identifica
CREATE TABLE IF NOT EXISTS Identifica (
    Testemunha_Id INT NOT NULL,
	Suspeito_Id INT NOT NULL,
    PRIMARY KEY (Testemunha_Id, Suspeito_Id),
    FOREIGN KEY (Testemunha_Id) REFERENCES Testemunha (Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Suspeito_Id) REFERENCES Suspeito (Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table Envolve_Suspeito
CREATE TABLE IF NOT EXISTS Envolve_Suspeito (
    Caso_Id INT NOT NULL,
	Suspeito_Id INT NOT NULL,
    PRIMARY KEY (Caso_Id, Suspeito_Id),
    FOREIGN KEY (Caso_Id) REFERENCES Caso (Caso_Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Suspeito_Id) REFERENCES Suspeito (Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table Droga
CREATE TABLE IF NOT EXISTS Droga (
  Id INT NOT NULL AUTO_INCREMENT,
  Nome VARCHAR(75) NOT NULL,
  Quantidade INT NOT NULL,
  DataApreensao DATE NOT NULL,
  Valor DECIMAL(8,2) NOT NULL,
  Origem VARCHAR(75) NOT NULL,
  PRIMARY KEY (Id)
);

-- Table De_Droga
CREATE TABLE IF NOT EXISTS De_Droga (
	Suspeito_Id INT NOT NULL,
    Droga_Id INT NOT NULL,
    PRIMARY KEY (Suspeito_Id, Droga_Id),
    FOREIGN KEY (Suspeito_Id) REFERENCES Suspeito (Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Droga_Id) REFERENCES Droga (Id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table Envolve_Droga
CREATE TABLE IF NOT EXISTS Envolve_Droga (
    Caso_Id INT NOT NULL,
	Droga_Id INT NOT NULL,
    PRIMARY KEY (Caso_Id, Droga_Id),
    FOREIGN KEY (Caso_Id) REFERENCES Caso (Caso_Id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Droga_Id) REFERENCES Droga (Id) ON DELETE RESTRICT ON UPDATE CASCADE
);