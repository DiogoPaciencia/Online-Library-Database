-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 15-Dez-2021 às 14:36
-- Versão do servidor: 10.4.21-MariaDB
-- versão do PHP: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `bibliotecafinal`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_info` (IN `pub_id` INT)  BEGIN

SELECT *
FROM exemplar e
WHERE e.Publicacao_Id=pub_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `temas_na_lista` (IN `nome` VARCHAR(255) CHARSET utf32, IN `num` INT(11))  BEGIN

SELECT a.Nome, COUNT(*)
FROM livro_em_lista_leitura ll, area_tematica a, edicao_de_livro el,  publicacao p
WHERE p.Area_tematica_Id=a.Id
AND el.Publicacao_Id=p.Id
AND ll.Edicao_de_Livro_Livro_Id_=el.Livro_Id
AND ll.Lista_de_leitura_Nome_=nome
AND ll.Lista_de_leitura_Utente_Numero_=num
GROUP BY a.Id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_multas` ()  BEGIN

DECLARE numMultas INTEGER;
DECLARE i INTEGER;
DECLARE newDate DATE;

SELECT COUNT(*) INTO numMultas
    FROM emprestimo_com_multa;

SET i = 0;

WHILE ( i < numMultas ) DO

    IF (SELECT em.Multa_paga
    FROM emprestimo e, emprestimo_com_multa em
    WHERE e.Numero=em.Numero AND em.Numero=i) = 0 THEN

    SELECT e.Data_de_devolucao_limite INTO newDate
    FROM emprestimo e, emprestimo_com_multa em
    WHERE e.Numero=em.Numero AND em.Numero=i;
        UPDATE emprestimo_com_multa
        SET Valor_actual_por_atraso = DATEDIFF(CURRENT_DATE(), newDate);

        UPDATE emprestimo_com_multa
        SET Valor_total = Valor_por_extravio + DATEDIFF(CURRENT_DATE(), newDate);

    END IF;

        SET i = i + 1;

    END WHILE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `andar`
--

CREATE TABLE `andar` (
  `Numero` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `andar`
--

INSERT INTO `andar` (`Numero`) VALUES
(1),
(2),
(3);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `areas_lista`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `areas_lista` (
`uNome` varchar(255)
,`lNome` varchar(255)
,`num_areas` bigint(21)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `area_tematica`
--

CREATE TABLE `area_tematica` (
  `Id` int(11) NOT NULL,
  `Nome` varchar(50) NOT NULL,
  `Area_Tematica_superior_Id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `area_tematica`
--

INSERT INTO `area_tematica` (`Id`, `Nome`, `Area_Tematica_superior_Id`) VALUES
(7, 'Filosofia', NULL),
(1, 'Romance', NULL),
(4, 'Romance Psicológico', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `armario`
--

CREATE TABLE `armario` (
  `Andar_Numero` tinyint(4) NOT NULL,
  `Espaco_de_arrumacao_Id` int(11) NOT NULL,
  `Letra` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `armario`
--

INSERT INTO `armario` (`Andar_Numero`, `Espaco_de_arrumacao_Id`, `Letra`) VALUES
(3, 3, 'B'),
(1, 4, 'A');

-- --------------------------------------------------------

--
-- Estrutura da tabela `autor`
--

CREATE TABLE `autor` (
  `id` int(11) NOT NULL,
  `Nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `autor`
--

INSERT INTO `autor` (`id`, `Nome`) VALUES
(777, 'Diogo Paciência'),
(111, 'Friedrich Nietzsche');

-- --------------------------------------------------------

--
-- Estrutura da tabela `autoria_de_livro`
--

CREATE TABLE `autoria_de_livro` (
  `Autor_id_` int(11) NOT NULL,
  `Livro_Id_` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `autoria_de_livro`
--

INSERT INTO `autoria_de_livro` (`Autor_id_`, `Livro_Id_`) VALUES
(111, 7366),
(777, 6352);

-- --------------------------------------------------------

--
-- Estrutura da tabela `autoria_de_monografia`
--

CREATE TABLE `autoria_de_monografia` (
  `Autor_id_` int(11) NOT NULL,
  `Monografia_Id_` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

-- --------------------------------------------------------

--
-- Estrutura da tabela `capitulo_ou_artigo`
--

CREATE TABLE `capitulo_ou_artigo` (
  `Publicacao_Id` int(11) NOT NULL,
  `Numero` tinyint(4) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

-- --------------------------------------------------------

--
-- Estrutura da tabela `documento_de_identificao`
--

CREATE TABLE `documento_de_identificao` (
  `Utente_numero` int(11) NOT NULL,
  `Tipo` char(4) NOT NULL CHECK (`Tipo` in ('CC','Pssp')),
  `Numero` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `documento_de_identificao`
--

INSERT INTO `documento_de_identificao` (`Utente_numero`, `Tipo`, `Numero`) VALUES
(60, 'CC', 624642624);

-- --------------------------------------------------------

--
-- Estrutura da tabela `edicao_de_livro`
--

CREATE TABLE `edicao_de_livro` (
  `Livro_Id` int(11) NOT NULL,
  `Publicacao_Id` int(11) NOT NULL,
  `Numero` tinyint(4) NOT NULL,
  `ISBN` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `edicao_de_livro`
--

INSERT INTO `edicao_de_livro` (`Livro_Id`, `Publicacao_Id`, `Numero`, `ISBN`) VALUES
(4367, 6436, 3, 426464254),
(6352, 8563, 1, 23675425),
(6457, 4747, 2, 32643745),
(8653, 2725, 5, 446310786);

--
-- Acionadores `edicao_de_livro`
--
DELIMITER $$
CREATE TRIGGER `duplicados_el` BEFORE INSERT ON `edicao_de_livro` FOR EACH ROW BEGIN

IF (SELECT COUNT(*) FROM edicao_de_periodico ep, monografia m WHERE new.Publicacao_Id=ep.Publicacao_Id OR new.Publicacao_Id=m.Publicacao_Id)<>0 THEN

SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A publicacao ja esta registada";

END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `edicao_de_periodico`
--

CREATE TABLE `edicao_de_periodico` (
  `Periodico_Editora_ou_Periodico_Id` int(11) NOT NULL,
  `Publicacao_Id` int(11) NOT NULL,
  `Numero` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `edicao_de_periodico`
--

INSERT INTO `edicao_de_periodico` (`Periodico_Editora_ou_Periodico_Id`, `Publicacao_Id`, `Numero`) VALUES
(50, 2725, 6),
(50, 4353, 1),
(50, 4353, 2),
(50, 4353, 3);

--
-- Acionadores `edicao_de_periodico`
--
DELIMITER $$
CREATE TRIGGER `duplicados_ep` BEFORE INSERT ON `edicao_de_periodico` FOR EACH ROW BEGIN

IF (SELECT COUNT(*) FROM monografia m, edicao_de_livro el WHERE new.Publicacao_Id=m.Publicacao_Id OR new.Publicacao_Id=el.Publicacao_Id)<>0 THEN

SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A publicacao ja esta registada";

END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_emprestavel` AFTER INSERT ON `edicao_de_periodico` FOR EACH ROW BEGIN

DECLARE emprestado tinyint(1);

SELECT e.Pode_ser_emprestado INTO emprestado FROM exemplar e WHERE new.Publicacao_Id=e.Publicacao_Id AND new.Numero=e.Nr;

IF emprestado THEN
UPDATE exemplar
SET Pode_ser_emprestado = 1
WHERE Publicacao_Id=new.Publicacao_Id AND Nr=new.Numero-1;
END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `editora`
--

CREATE TABLE `editora` (
  `Editora_ou_Periodico_Id` int(11) NOT NULL,
  `Nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `editora`
--

INSERT INTO `editora` (`Editora_ou_Periodico_Id`, `Nome`) VALUES
(20, 'Penguin Classics'),
(47, 'OUP Oxford'),
(50, 'Perfil'),
(77, 'Paci');

-- --------------------------------------------------------

--
-- Estrutura da tabela `editora_ou_periodico`
--

CREATE TABLE `editora_ou_periodico` (
  `Id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `editora_ou_periodico`
--

INSERT INTO `editora_ou_periodico` (`Id`) VALUES
(20),
(47),
(50),
(77);

-- --------------------------------------------------------

--
-- Estrutura da tabela `emprestimo`
--

CREATE TABLE `emprestimo` (
  `Numero` int(11) NOT NULL,
  `Data_hora` datetime NOT NULL,
  `Publicacao_Id` int(11) NOT NULL,
  `Exemplar_Nr` tinyint(4) NOT NULL,
  `Utente_Numero` int(11) NOT NULL,
  `Data_de_devolucao_limite` date NOT NULL,
  `Qtd_de_prolongamentos` tinyint(4) DEFAULT NULL,
  `Data_de_devolucao` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `emprestimo`
--

INSERT INTO `emprestimo` (`Numero`, `Data_hora`, `Publicacao_Id`, `Exemplar_Nr`, `Utente_Numero`, `Data_de_devolucao_limite`, `Qtd_de_prolongamentos`, `Data_de_devolucao`) VALUES
(0, '2021-01-09 23:12:17', 2725, 2, 60, '2021-02-10', 1, '2021-04-01 23:12:17'),
(1, '2021-02-10 23:57:40', 4747, 3, 60, '2021-03-10', 0, '2021-04-01 23:57:40'),
(10, '2021-02-24 23:13:08', 6436, 6, 60, '2021-03-17', 0, '2021-04-01 23:13:08'),
(65, '2021-02-09 23:23:12', 4747, 56, 60, '2021-03-11', 0, '2021-04-01 23:23:12'),
(73, '2021-12-15 03:09:40', 2725, 63, 60, '2022-01-20', 0, '2022-01-10 02:09:41');

--
-- Acionadores `emprestimo`
--
DELIMITER $$
CREATE TRIGGER `adicionar_emprestimo` AFTER INSERT ON `emprestimo` FOR EACH ROW BEGIN

UPDATE publicacao p
    SET p.Qtd_Emprestimos=p.Qtd_Emprestimos + 1 WHERE p.ID=new.Publicacao_Id;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_emprestavel` BEFORE INSERT ON `emprestimo` FOR EACH ROW BEGIN

DECLARE emprestavel tinyint(1);
SELECT ex.Pode_ser_emprestado INTO emprestavel FROM exemplar ex
WHERE new.Publicacao_Id=ex.Publicacao_Id AND new.Exemplar_Nr=ex.Nr;

IF NOT emprestavel OR EXISTS(SELECT * FROM reserva r WHERE r.Exemplar_escolhido_Publicacao_Id = new.Publicacao_Id AND MONTH(r.Data_e_Hora)-MONTH(CURRENT_DATE())<=1) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nao e possivel emprestar esta publicacao';

END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `suspender_por_tempo` AFTER UPDATE ON `emprestimo` FOR EACH ROW BEGIN

DECLARE num integer;
DECLARE endTime date;

IF DATEDIFF(CURRENT_DATE(), new.Data_de_devolucao_limite)>30 THEN

SET num = new.Utente_Numero;
SET endTime = (SELECT DATEADD(month, 1, CURRENT_DATE()));
INSERT INTO utente_suspenso (Numero, Data_inicio, Data_fim) VALUES (num, CURRENT_DATE(), endTime);

END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `emprestimos_prim_semestre`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `emprestimos_prim_semestre` (
`Pub_Nome` varchar(255)
,`Area_Nome` varchar(50)
,`Emprestimos` bigint(21)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `emprestimo_com_multa`
--

CREATE TABLE `emprestimo_com_multa` (
  `Numero` int(11) NOT NULL,
  `Valor_actual_por_atraso` decimal(5,2) DEFAULT NULL,
  `Valor_por_extravio` decimal(5,2) DEFAULT NULL,
  `Valor_total` decimal(5,2) DEFAULT NULL,
  `Multa_paga` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `emprestimo_com_multa`
--

INSERT INTO `emprestimo_com_multa` (`Numero`, `Valor_actual_por_atraso`, `Valor_por_extravio`, `Valor_total`, `Multa_paga`) VALUES
(0, '308.00', '12.00', '320.00', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `espaco_de_arrumacao`
--

CREATE TABLE `espaco_de_arrumacao` (
  `Id` int(11) NOT NULL,
  `Nivel_de_ocupacao` tinyint(4) DEFAULT NULL,
  `Area_Tematica_Id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `espaco_de_arrumacao`
--

INSERT INTO `espaco_de_arrumacao` (`Id`, `Nivel_de_ocupacao`, `Area_Tematica_Id`) VALUES
(1, 10, NULL),
(2, 20, 1),
(3, 30, 7),
(4, 40, 1),
(7, 70, 7),
(8, 80, 1),
(9, 90, NULL);

-- --------------------------------------------------------

--
-- Estrutura da tabela `estado_de_conservacao`
--

CREATE TABLE `estado_de_conservacao` (
  `Nome` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `estado_de_conservacao`
--

INSERT INTO `estado_de_conservacao` (`Nome`) VALUES
('extraviado'),
('Novo');

-- --------------------------------------------------------

--
-- Estrutura da tabela `exemplar`
--

CREATE TABLE `exemplar` (
  `Publicacao_Id` int(11) NOT NULL,
  `Nr` tinyint(4) NOT NULL,
  `Codigo_de_barras` int(11) DEFAULT NULL,
  `Data_de_aquisicao` date DEFAULT NULL,
  `RFID` int(11) DEFAULT NULL,
  `Pode_ser_emprestado` tinyint(1) DEFAULT NULL,
  `Estado_de_conservacao_Nome` varchar(20) DEFAULT NULL,
  `Localizacao_Andar_Numero` tinyint(4) DEFAULT NULL,
  `Localizacao_Armario_Letra` char(1) DEFAULT NULL,
  `Localizacao_Prateleira_Numero` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `exemplar`
--

INSERT INTO `exemplar` (`Publicacao_Id`, `Nr`, `Codigo_de_barras`, `Data_de_aquisicao`, `RFID`, `Pode_ser_emprestado`, `Estado_de_conservacao_Nome`, `Localizacao_Andar_Numero`, `Localizacao_Armario_Letra`, `Localizacao_Prateleira_Numero`) VALUES
(2725, 2, 36753, '2021-01-01', 2352, 0, 'Novo', 3, 'B', 6),
(2725, 63, 236734, '2021-10-01', 525325, 1, 'Novo', 1, 'A', 53),
(4353, 1, 212251, '2021-12-01', 1245, 1, 'Novo', 1, 'A', 1),
(4353, 2, 2122513, '2021-12-07', 12453, 1, 'Novo', 3, 'B', 1),
(4747, 3, 478370, '2021-08-11', 4783, 0, 'Novo', 1, 'A', 2),
(4747, 56, 3753538, '2021-01-08', 3735, 0, 'Novo', 3, 'B', 8),
(6436, 6, 6446734, '2021-01-02', 5327, 0, 'Novo', 3, 'B', 7);

--
-- Acionadores `exemplar`
--
DELIMITER $$
CREATE TRIGGER `suspender_por_extravio` AFTER UPDATE ON `exemplar` FOR EACH ROW BEGIN

DECLARE num integer;
DECLARE endTime date;

IF new.Estado_de_conservacao_Nome='extraviado' THEN
    IF new.Estado_de_conservacao_Nome <> old.Estado_de_conservacao_Nome THEN

SELECT e.Utente_Numero INTO num FROM emprestimo e
    WHERE e.Exemplar_Nr=new.Nr
    AND e.Publicacao_Id=new.Publicacao_Id;
SET endTime = (SELECT DATEADD(month, 1, CURRENT_DATE()));
INSERT INTO utente_suspenso (Numero, Data_inicio, Data_fim) VALUES (num, CURRENT_DATE(), endTime);

    END IF;
END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `feed`
--

CREATE TABLE `feed` (
  `Endereco` varchar(255) NOT NULL,
  `Editora_ou_Periodico_Id` int(11) NOT NULL,
  `Periodicidade_Nome` varchar(50) DEFAULT NULL,
  `Area_Tematica_Id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `listagem_pub`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `listagem_pub` (
`nome` varchar(255)
,`Data_de_publicacao` date
,`Tipo_de_Publicação` varchar(10)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `lista_de_leitura`
--

CREATE TABLE `lista_de_leitura` (
  `Utente_Numero` int(11) NOT NULL,
  `Nome` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `lista_de_leitura`
--

INSERT INTO `lista_de_leitura` (`Utente_Numero`, `Nome`) VALUES
(60, 'Lista da Joana');

-- --------------------------------------------------------

--
-- Estrutura da tabela `livro`
--

CREATE TABLE `livro` (
  `Id` int(11) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Editora_Nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `livro`
--

INSERT INTO `livro` (`Id`, `Nome`, `Editora_Nome`) VALUES
(4367, 'Being and Nothingness', 'OUP Oxford'),
(6352, 'Orangotango', 'Paci'),
(6457, 'Crime and Punishment', 'Penguin Classics'),
(7366, 'Beyond Good & Evil', 'Penguin Classics'),
(8653, 'To Kill a Mockingbird', 'Penguin Classics');

-- --------------------------------------------------------

--
-- Estrutura da tabela `livro_em_lista_leitura`
--

CREATE TABLE `livro_em_lista_leitura` (
  `Edicao_de_Livro_Livro_Id_` int(11) NOT NULL,
  `Edicao_de_Livro_Numero_` tinyint(4) NOT NULL,
  `Lista_de_leitura_Utente_Numero_` int(11) NOT NULL,
  `Lista_de_leitura_Nome_` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `livro_em_lista_leitura`
--

INSERT INTO `livro_em_lista_leitura` (`Edicao_de_Livro_Livro_Id_`, `Edicao_de_Livro_Numero_`, `Lista_de_leitura_Utente_Numero_`, `Lista_de_leitura_Nome_`) VALUES
(4367, 3, 60, 'Lista da Joana'),
(6457, 2, 60, 'Lista da Joana'),
(8653, 5, 60, 'Lista da Joana');

-- --------------------------------------------------------

--
-- Estrutura da tabela `monografia`
--

CREATE TABLE `monografia` (
  `Publicacao_Id` int(11) NOT NULL,
  `Tipo_de_monografia_Nome` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `monografia`
--

INSERT INTO `monografia` (`Publicacao_Id`, `Tipo_de_monografia_Nome`) VALUES
(6436, 'Relatório'),
(23, 'Texto pedagógico');

--
-- Acionadores `monografia`
--
DELIMITER $$
CREATE TRIGGER `duplicados_monografia` BEFORE INSERT ON `monografia` FOR EACH ROW BEGIN

IF (SELECT COUNT(*) FROM edicao_de_periodico ep, edicao_de_livro el WHERE new.Publicacao_Id=ep.Publicacao_Id OR new.Publicacao_Id=el.Publicacao_Id)<>0 THEN

SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A publicacao ja esta registada";

END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `palavra_chave_descreve_publicacao`
--

CREATE TABLE `palavra_chave_descreve_publicacao` (
  `Palavra_chave_` varchar(50) NOT NULL,
  `Publicacao_Id_` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `palavra_chave_descreve_publicacao`
--

INSERT INTO `palavra_chave_descreve_publicacao` (`Palavra_chave_`, `Publicacao_Id_`) VALUES
('Português', 8563);

-- --------------------------------------------------------

--
-- Estrutura da tabela `palavra_chave_tag`
--

CREATE TABLE `palavra_chave_tag` (
  `Palavra` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `palavra_chave_tag`
--

INSERT INTO `palavra_chave_tag` (`Palavra`) VALUES
('Alemão'),
('Português');

-- --------------------------------------------------------

--
-- Estrutura da tabela `periodicidade`
--

CREATE TABLE `periodicidade` (
  `Nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `periodicidade`
--

INSERT INTO `periodicidade` (`Nome`) VALUES
('Anual'),
('Diária'),
('Mensal'),
('Semanal'),
('Semestral'),
('Trimestral');

-- --------------------------------------------------------

--
-- Estrutura da tabela `periodico`
--

CREATE TABLE `periodico` (
  `Editora_Nome` varchar(50) NOT NULL,
  `Editora_ou_Periodico_Id` int(11) NOT NULL,
  `Periodicidade_Nome` varchar(50) NOT NULL,
  `ISSN` int(11) DEFAULT NULL,
  `Sigla` char(8) DEFAULT NULL,
  `Nome` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `periodico`
--

INSERT INTO `periodico` (`Editora_Nome`, `Editora_ou_Periodico_Id`, `Periodicidade_Nome`, `ISSN`, `Sigla`, `Nome`) VALUES
('Perfil', 50, 'Mensal', 7434545, NULL, 'Caras');

-- --------------------------------------------------------

--
-- Estrutura da tabela `prateleira`
--

CREATE TABLE `prateleira` (
  `Andar_Numero` tinyint(4) NOT NULL,
  `Armario_Letra` char(1) NOT NULL,
  `Espaco_de_arrumacao_Id` int(11) NOT NULL,
  `Numero` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `prateleira`
--

INSERT INTO `prateleira` (`Andar_Numero`, `Armario_Letra`, `Espaco_de_arrumacao_Id`, `Numero`) VALUES
(1, 'A', 1, 1),
(1, 'A', 2, 53),
(3, 'B', 3, 6),
(1, 'A', 4, 2),
(3, 'B', 7, 7),
(3, 'B', 8, 8),
(3, 'B', 9, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `publicacao`
--

CREATE TABLE `publicacao` (
  `Id` int(11) NOT NULL,
  `Nome` varchar(255) NOT NULL,
  `Nome_abreviado` varchar(100) DEFAULT NULL,
  `Codigo` int(11) NOT NULL,
  `Data_de_publicacao` date DEFAULT NULL,
  `Ano_de_publicacao` smallint(6) DEFAULT NULL,
  `Nr_Pags` smallint(6) DEFAULT NULL,
  `Capa` varchar(255) DEFAULT NULL,
  `Capa_em_miniatura` varchar(255) DEFAULT NULL,
  `Qtd_Emprestimos` smallint(6) DEFAULT 0,
  `Qtd_Acessos` smallint(6) DEFAULT 0,
  `Data_de_aquisicao` date DEFAULT NULL,
  `Area_Tematica_Id` int(11) DEFAULT NULL,
  `relevancia` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `publicacao`
--

INSERT INTO `publicacao` (`Id`, `Nome`, `Nome_abreviado`, `Codigo`, `Data_de_publicacao`, `Ano_de_publicacao`, `Nr_Pags`, `Capa`, `Capa_em_miniatura`, `Qtd_Emprestimos`, `Qtd_Acessos`, `Data_de_aquisicao`, `Area_Tematica_Id`, `relevancia`) VALUES
(23, 'A Comunidade Escolar', NULL, 7, '2021-12-01', 2021, 4, NULL, NULL, 0, 0, NULL, NULL, 2),
(2725, 'To Kill a Mockingbird', 'TKaM', 446310786, '1988-10-11', 1988, 384, 'https://images-na.ssl-images-amazon.com/images/I/71FxgtFKcQL.jpg', 'https://images-na.ssl-images-amazon.com/images/I/51N5qVjuKAL._AC_SX60_CR,0,0,60,60_.jpg', 38, 23, '2021-06-10', 1, 5),
(4353, 'Caras', NULL, 7434545, '2021-12-01', 2021, 50, NULL, NULL, 0, 0, '2021-12-01', NULL, 3),
(4747, 'Crime and Punishment', NULL, 140449132, '2003-01-30', 2003, 720, 'https://images-na.ssl-images-amazon.com/images/I/816ZRCiirkL.jpg', NULL, 7, 2, '2021-08-11', 4, 5),
(5742, 'esparguete', 'TMOF', 525564454, '0000-00-00', 2018, 160, 'https://m.media-amazon.com/images/P/0525564454.01._SCLZZZZZZZ_SX500_.jpg', 'https://images-na.ssl-images-amazon.com/images/I/31fLG6cR90L._AC_SX60_CR,0,0,60,60_.jpg', 5, 2, '2021-04-13', 1, 3),
(6433, 'Chimpazé', 'C', 24675865, '2021-12-02', 2021, 100, 'nuviweui4g3', '5s7u5rrs', 10, 5, '2021-12-13', 1, 4),
(6436, 'Being and Nothingness', 'BaN', 426464254, '2015-12-28', 2015, 467, 'https://m.media-amazon.com/images/P/0525564454.01._SCLZZZZZZZ_SX500_.jpg', 'https://images-na.ssl-images-amazon.com/images/I/51H6Y3N-LbL._SX331_BO1,204,203,200_.jpg', 24, 13, '2021-12-01', 7, 5),
(8563, 'Orangotango', 'O', 23675425, '2002-10-07', 2021, 3, 'wgrwegt43g', 'h3aeh4a4e', 43, 23, '2021-12-09', 1, 5);

-- --------------------------------------------------------

--
-- Estrutura da tabela `publicacao_digital`
--

CREATE TABLE `publicacao_digital` (
  `Publicacao_Id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

-- --------------------------------------------------------

--
-- Estrutura da tabela `publicacao_fisica`
--

CREATE TABLE `publicacao_fisica` (
  `Publicacao_Id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `publicacao_fisica`
--

INSERT INTO `publicacao_fisica` (`Publicacao_Id`) VALUES
(2725),
(4353),
(4747),
(6436);

-- --------------------------------------------------------

--
-- Estrutura da tabela `reserva`
--

CREATE TABLE `reserva` (
  `Publicacao_Id_` int(11) NOT NULL,
  `Utente_Numero_` int(11) NOT NULL,
  `Data_e_Hora` datetime DEFAULT NULL,
  `Exemplar_escolhido_Publicacao_Id` int(11) DEFAULT NULL,
  `Exemplar_Nr` tinyint(4) DEFAULT NULL
) ;

--
-- Extraindo dados da tabela `reserva`
--

INSERT INTO `reserva` (`Publicacao_Id_`, `Utente_Numero_`, `Data_e_Hora`, `Exemplar_escolhido_Publicacao_Id`, `Exemplar_Nr`) VALUES
(4747, 60, '2021-12-14 22:01:33', 4747, 3);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `reservas_max`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `reservas_max` (
`PubNome` varchar(255)
,`Valor` bigint(21)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `revista`
--

CREATE TABLE `revista` (
  `Periodico_Editora_ou_Periodico_Id` int(11) NOT NULL,
  `Qtd_edicoes_nao_emprestaveis` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `revista`
--

INSERT INTO `revista` (`Periodico_Editora_ou_Periodico_Id`, `Qtd_edicoes_nao_emprestaveis`) VALUES
(50, 20);

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipo_de_monografia`
--

CREATE TABLE `tipo_de_monografia` (
  `Nome` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

--
-- Extraindo dados da tabela `tipo_de_monografia`
--

INSERT INTO `tipo_de_monografia` (`Nome`) VALUES
('Dissertação de Doutoramento'),
('Dissertação de Mestrado'),
('Relatório'),
('Texto pedagógico');

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `top_reservas`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `top_reservas` (
`PubNome` varchar(255)
,`Valor` bigint(21)
);

-- --------------------------------------------------------

--
-- Estrutura da tabela `utente`
--

CREATE TABLE `utente` (
  `Numero` int(11) NOT NULL,
  `Nome` varchar(255) NOT NULL,
  `Telefone` int(11) NOT NULL,
  `Morada` varchar(255) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `Tipo_Doc_Identificacao` char(4) NOT NULL,
  `Nr_Doc_Identificacao` int(11) NOT NULL
) ;

--
-- Extraindo dados da tabela `utente`
--

INSERT INTO `utente` (`Numero`, `Nome`, `Telefone`, `Morada`, `Email`, `Tipo_Doc_Identificacao`, `Nr_Doc_Identificacao`) VALUES
(60, 'Joana Lopes', 964416135, 'Moinhos, Amadora', 'Joana.kampos@gmail.com', 'CC', 624642624);

-- --------------------------------------------------------

--
-- Estrutura da tabela `utente_suspenso`
--

CREATE TABLE `utente_suspenso` (
  `Numero` int(11) NOT NULL,
  `Data_inicio` date NOT NULL,
  `Data_fim` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32;

-- --------------------------------------------------------

--
-- Estrutura para vista `areas_lista`
--
DROP TABLE IF EXISTS `areas_lista`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `areas_lista`  AS SELECT `ut`.`Nome` AS `uNome`, `lista`.`Nome` AS `lNome`, count(distinct `area`.`Nome`) AS `num_areas` FROM ((((((`utente` `ut` join `lista_de_leitura` `lista`) join `livro_em_lista_leitura` `liv_lista`) join `area_tematica` `area`) join `edicao_de_livro` `ed`) join `publicacao` `pub`) join `livro` `liv`) WHERE `ut`.`Numero` = `lista`.`Utente_Numero` AND `liv_lista`.`Lista_de_leitura_Utente_Numero_` = `ut`.`Numero` AND `ut`.`Numero` = `lista`.`Utente_Numero` AND `ed`.`Publicacao_Id` = `pub`.`Id` AND `area`.`Id` = `pub`.`Area_Tematica_Id` AND `liv`.`Id` = `ed`.`Livro_Id` AND `liv_lista`.`Edicao_de_Livro_Livro_Id_` = `liv`.`Id` GROUP BY `lista`.`Nome` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `emprestimos_prim_semestre`
--
DROP TABLE IF EXISTS `emprestimos_prim_semestre`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `emprestimos_prim_semestre`  AS SELECT `pub`.`Nome` AS `Pub_Nome`, `area`.`Nome` AS `Area_Nome`, count(0) AS `Emprestimos` FROM ((`publicacao` `pub` join `emprestimo` `emp`) join `area_tematica` `area`) WHERE `pub`.`Id` = `emp`.`Publicacao_Id` AND `pub`.`Area_Tematica_Id` = `area`.`Id` AND `emp`.`Data_hora` between '2021-01-01' and '2021-06-31' GROUP BY `pub`.`Nome` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `listagem_pub`
--
DROP TABLE IF EXISTS `listagem_pub`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `listagem_pub`  AS SELECT `pub`.`Nome` AS `nome`, `pub`.`Data_de_publicacao` AS `Data_de_publicacao`, 'Livro' AS `Tipo_de_Publicação` FROM (`publicacao` `pub` join `edicao_de_livro` `liv`) WHERE `pub`.`Id` = `liv`.`Publicacao_Id` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `reservas_max`
--
DROP TABLE IF EXISTS `reservas_max`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reservas_max`  AS SELECT `pub`.`Nome` AS `PubNome`, count(0) AS `Valor` FROM (`publicacao` `pub` join `reserva` `res`) WHERE `pub`.`Id` = `res`.`Publicacao_Id_` AND `res`.`Data_e_Hora` <> current_timestamp() - interval -6 month GROUP BY `pub`.`Nome` ;

-- --------------------------------------------------------

--
-- Estrutura para vista `top_reservas`
--
DROP TABLE IF EXISTS `top_reservas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `top_reservas`  AS SELECT `pub`.`Nome` AS `PubNome`, count(0) AS `Valor` FROM (`publicacao` `pub` join `reserva` `res`) WHERE `pub`.`Id` = `res`.`Publicacao_Id_` AND `res`.`Data_e_Hora` <> current_timestamp() - interval -6 month ;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `andar`
--
ALTER TABLE `andar`
  ADD PRIMARY KEY (`Numero`),
  ADD UNIQUE KEY `Numero` (`Numero`);

--
-- Índices para tabela `area_tematica`
--
ALTER TABLE `area_tematica`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Id` (`Id`),
  ADD UNIQUE KEY `AK_Nome_em_Area_superior` (`Nome`,`Area_Tematica_superior_Id`),
  ADD KEY `FK_Area_Tematica_noname_Area_Tematica` (`Area_Tematica_superior_Id`);

--
-- Índices para tabela `armario`
--
ALTER TABLE `armario`
  ADD PRIMARY KEY (`Andar_Numero`,`Letra`),
  ADD UNIQUE KEY `AK_Armario_Espaco_de_arrumacao` (`Espaco_de_arrumacao_Id`);

--
-- Índices para tabela `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `Nome` (`Nome`);

--
-- Índices para tabela `autoria_de_livro`
--
ALTER TABLE `autoria_de_livro`
  ADD PRIMARY KEY (`Autor_id_`,`Livro_Id_`),
  ADD KEY `FK_Livro_Autoria_de_Livro_Autor_` (`Livro_Id_`);

--
-- Índices para tabela `autoria_de_monografia`
--
ALTER TABLE `autoria_de_monografia`
  ADD PRIMARY KEY (`Autor_id_`,`Monografia_Id_`),
  ADD KEY `FK_Monografia_Autoria_de_Monografia_Autor_` (`Monografia_Id_`);

--
-- Índices para tabela `capitulo_ou_artigo`
--
ALTER TABLE `capitulo_ou_artigo`
  ADD PRIMARY KEY (`Publicacao_Id`,`Numero`),
  ADD UNIQUE KEY `Capitulo_ou_Artigo___Unique_Numero_em_Publicacao` (`Publicacao_Id`,`Numero`),
  ADD UNIQUE KEY `Capitulo_ou_Artigo___Unique_Nome_em_Publicacao` (`Publicacao_Id`,`Nome`);

--
-- Índices para tabela `documento_de_identificao`
--
ALTER TABLE `documento_de_identificao`
  ADD PRIMARY KEY (`Utente_numero`),
  ADD UNIQUE KEY `AK_Doc_Id___Nr_and_Tipo` (`Tipo`,`Numero`);

--
-- Índices para tabela `edicao_de_livro`
--
ALTER TABLE `edicao_de_livro`
  ADD PRIMARY KEY (`Livro_Id`,`Numero`),
  ADD UNIQUE KEY `Numero` (`Numero`),
  ADD UNIQUE KEY `ISBN` (`ISBN`),
  ADD KEY `FK_Edicao_de_Livro_Publicacao` (`Publicacao_Id`);

--
-- Índices para tabela `edicao_de_periodico`
--
ALTER TABLE `edicao_de_periodico`
  ADD PRIMARY KEY (`Periodico_Editora_ou_Periodico_Id`,`Numero`),
  ADD UNIQUE KEY `Numero` (`Numero`),
  ADD KEY `FK_Edicao_de_Periodico_Publicacao` (`Publicacao_Id`);

--
-- Índices para tabela `editora`
--
ALTER TABLE `editora`
  ADD PRIMARY KEY (`Nome`),
  ADD UNIQUE KEY `Editora_ou_Periodico_Id` (`Editora_ou_Periodico_Id`),
  ADD UNIQUE KEY `Nome` (`Nome`);

--
-- Índices para tabela `editora_ou_periodico`
--
ALTER TABLE `editora_ou_periodico`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Id` (`Id`);

--
-- Índices para tabela `emprestimo`
--
ALTER TABLE `emprestimo`
  ADD PRIMARY KEY (`Numero`),
  ADD UNIQUE KEY `Numero` (`Numero`),
  ADD KEY `FK_Emprestimo_noname_Exemplar` (`Publicacao_Id`,`Exemplar_Nr`),
  ADD KEY `FK_Emprestimo_noname_Utente` (`Utente_Numero`);

--
-- Índices para tabela `emprestimo_com_multa`
--
ALTER TABLE `emprestimo_com_multa`
  ADD PRIMARY KEY (`Numero`);

--
-- Índices para tabela `espaco_de_arrumacao`
--
ALTER TABLE `espaco_de_arrumacao`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_Espaco_de_arrumacao_noname_Area_Tematica` (`Area_Tematica_Id`);

--
-- Índices para tabela `estado_de_conservacao`
--
ALTER TABLE `estado_de_conservacao`
  ADD PRIMARY KEY (`Nome`),
  ADD UNIQUE KEY `Nome` (`Nome`);

--
-- Índices para tabela `exemplar`
--
ALTER TABLE `exemplar`
  ADD PRIMARY KEY (`Publicacao_Id`,`Nr`),
  ADD UNIQUE KEY `Codigo_de_barras` (`Codigo_de_barras`),
  ADD UNIQUE KEY `RFID` (`RFID`),
  ADD KEY `FK_Exemplar_noname_Estado_de_conservacao` (`Estado_de_conservacao_Nome`),
  ADD KEY `FK_Exemplar_noname_Prateleira` (`Localizacao_Andar_Numero`,`Localizacao_Armario_Letra`,`Localizacao_Prateleira_Numero`);

--
-- Índices para tabela `feed`
--
ALTER TABLE `feed`
  ADD PRIMARY KEY (`Endereco`),
  ADD UNIQUE KEY `Endereco` (`Endereco`),
  ADD KEY `FK_Feed_noname_Area_Tematica` (`Area_Tematica_Id`),
  ADD KEY `FK_Feed_noname_Editora_ou_Periodico` (`Editora_ou_Periodico_Id`),
  ADD KEY `FK_Feed_noname_Periodicidade` (`Periodicidade_Nome`);

--
-- Índices para tabela `lista_de_leitura`
--
ALTER TABLE `lista_de_leitura`
  ADD PRIMARY KEY (`Utente_Numero`,`Nome`);

--
-- Índices para tabela `livro`
--
ALTER TABLE `livro`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_Livro_noname_Editora` (`Editora_Nome`);

--
-- Índices para tabela `livro_em_lista_leitura`
--
ALTER TABLE `livro_em_lista_leitura`
  ADD PRIMARY KEY (`Edicao_de_Livro_Livro_Id_`,`Edicao_de_Livro_Numero_`,`Lista_de_leitura_Utente_Numero_`,`Lista_de_leitura_Nome_`),
  ADD KEY `FK_Lista_de_leitura_Livro_em_Lista_leitura_Edicao_de_Livro_` (`Lista_de_leitura_Utente_Numero_`,`Lista_de_leitura_Nome_`);

--
-- Índices para tabela `monografia`
--
ALTER TABLE `monografia`
  ADD PRIMARY KEY (`Publicacao_Id`),
  ADD KEY `FK_Monografia_noname_Tipo_de_monografia` (`Tipo_de_monografia_Nome`);

--
-- Índices para tabela `palavra_chave_descreve_publicacao`
--
ALTER TABLE `palavra_chave_descreve_publicacao`
  ADD PRIMARY KEY (`Palavra_chave_`,`Publicacao_Id_`),
  ADD KEY `FK_Publicacao_Palavra_chave_descreve_Publicacao_` (`Publicacao_Id_`);

--
-- Índices para tabela `palavra_chave_tag`
--
ALTER TABLE `palavra_chave_tag`
  ADD PRIMARY KEY (`Palavra`);

--
-- Índices para tabela `periodicidade`
--
ALTER TABLE `periodicidade`
  ADD PRIMARY KEY (`Nome`),
  ADD UNIQUE KEY `Nome` (`Nome`);

--
-- Índices para tabela `periodico`
--
ALTER TABLE `periodico`
  ADD PRIMARY KEY (`Editora_ou_Periodico_Id`),
  ADD UNIQUE KEY `Nome` (`Nome`),
  ADD KEY `FK_Periodico_noname_Editora` (`Editora_Nome`),
  ADD KEY `FK_Periodico_noname_Periodicidade` (`Periodicidade_Nome`);

--
-- Índices para tabela `prateleira`
--
ALTER TABLE `prateleira`
  ADD PRIMARY KEY (`Andar_Numero`,`Armario_Letra`,`Numero`),
  ADD UNIQUE KEY `AK_Prateleira_Espaco_de_arrumacao` (`Espaco_de_arrumacao_Id`);

--
-- Índices para tabela `publicacao`
--
ALTER TABLE `publicacao`
  ADD PRIMARY KEY (`Id`),
  ADD UNIQUE KEY `Nome` (`Nome`),
  ADD UNIQUE KEY `Codigo` (`Codigo`),
  ADD KEY `FK_Publicacao_Publicacao_em_Area_Area_Tematica` (`Area_Tematica_Id`);

--
-- Índices para tabela `publicacao_digital`
--
ALTER TABLE `publicacao_digital`
  ADD PRIMARY KEY (`Publicacao_Id`),
  ADD UNIQUE KEY `Publicacao_Id` (`Publicacao_Id`);

--
-- Índices para tabela `publicacao_fisica`
--
ALTER TABLE `publicacao_fisica`
  ADD PRIMARY KEY (`Publicacao_Id`),
  ADD UNIQUE KEY `Publicacao_Id` (`Publicacao_Id`);

--
-- Índices para tabela `reserva`
--
ALTER TABLE `reserva`
  ADD PRIMARY KEY (`Publicacao_Id_`,`Utente_Numero_`),
  ADD UNIQUE KEY `Data_e_Hora` (`Data_e_Hora`),
  ADD KEY `FK_Reserva_noname_Exemplar` (`Exemplar_escolhido_Publicacao_Id`,`Exemplar_Nr`),
  ADD KEY `FK_Utente_Reserva_Publicacao_fisica_` (`Utente_Numero_`);

--
-- Índices para tabela `revista`
--
ALTER TABLE `revista`
  ADD PRIMARY KEY (`Periodico_Editora_ou_Periodico_Id`);

--
-- Índices para tabela `tipo_de_monografia`
--
ALTER TABLE `tipo_de_monografia`
  ADD PRIMARY KEY (`Nome`),
  ADD UNIQUE KEY `Nome` (`Nome`);

--
-- Índices para tabela `utente`
--
ALTER TABLE `utente`
  ADD PRIMARY KEY (`Numero`),
  ADD UNIQUE KEY `Numero` (`Numero`),
  ADD UNIQUE KEY `Email` (`Email`),
  ADD UNIQUE KEY `AK_Nr_doc_id_and_Tipo_doc_id` (`Tipo_Doc_Identificacao`,`Nr_Doc_Identificacao`);

--
-- Índices para tabela `utente_suspenso`
--
ALTER TABLE `utente_suspenso`
  ADD PRIMARY KEY (`Numero`);

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `area_tematica`
--
ALTER TABLE `area_tematica`
  ADD CONSTRAINT `FK_Area_Tematica_noname_Area_Tematica` FOREIGN KEY (`Area_Tematica_superior_Id`) REFERENCES `area_tematica` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `armario`
--
ALTER TABLE `armario`
  ADD CONSTRAINT `FK_Armario_Espaco_de_arrumacao` FOREIGN KEY (`Espaco_de_arrumacao_Id`) REFERENCES `espaco_de_arrumacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Armario_noname_Andar` FOREIGN KEY (`Andar_Numero`) REFERENCES `andar` (`Numero`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `autoria_de_livro`
--
ALTER TABLE `autoria_de_livro`
  ADD CONSTRAINT `FK_Autor_Autoria_de_Livro_Livro_` FOREIGN KEY (`Autor_id_`) REFERENCES `autor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Livro_Autoria_de_Livro_Autor_` FOREIGN KEY (`Livro_Id_`) REFERENCES `livro` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `autoria_de_monografia`
--
ALTER TABLE `autoria_de_monografia`
  ADD CONSTRAINT `FK_Autor_Autoria_de_Monografia_Monografia_` FOREIGN KEY (`Autor_id_`) REFERENCES `autor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Monografia_Autoria_de_Monografia_Autor_` FOREIGN KEY (`Monografia_Id_`) REFERENCES `monografia` (`Publicacao_Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `capitulo_ou_artigo`
--
ALTER TABLE `capitulo_ou_artigo`
  ADD CONSTRAINT `FK_Capitulo_ou_Artigo_noname_Publicacao` FOREIGN KEY (`Publicacao_Id`) REFERENCES `publicacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `edicao_de_livro`
--
ALTER TABLE `edicao_de_livro`
  ADD CONSTRAINT `FK_Edicao_de_Livro_Publicacao` FOREIGN KEY (`Publicacao_Id`) REFERENCES `publicacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Edicao_de_Livro_noname_Livro` FOREIGN KEY (`Livro_Id`) REFERENCES `livro` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `edicao_de_periodico`
--
ALTER TABLE `edicao_de_periodico`
  ADD CONSTRAINT `FK_Edicao_de_Periodico_Publicacao` FOREIGN KEY (`Publicacao_Id`) REFERENCES `publicacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Edicao_de_Periodico_noname_Periodico` FOREIGN KEY (`Periodico_Editora_ou_Periodico_Id`) REFERENCES `periodico` (`Editora_ou_Periodico_Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `editora`
--
ALTER TABLE `editora`
  ADD CONSTRAINT `FK_Editora_Editora_ou_Periodico` FOREIGN KEY (`Editora_ou_Periodico_Id`) REFERENCES `editora_ou_periodico` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `emprestimo`
--
ALTER TABLE `emprestimo`
  ADD CONSTRAINT `FK_Emprestimo_noname_Exemplar` FOREIGN KEY (`Publicacao_Id`,`Exemplar_Nr`) REFERENCES `exemplar` (`Publicacao_Id`, `Nr`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Emprestimo_noname_Utente` FOREIGN KEY (`Utente_Numero`) REFERENCES `utente` (`Numero`) ON UPDATE CASCADE;

--
-- Limitadores para a tabela `emprestimo_com_multa`
--
ALTER TABLE `emprestimo_com_multa`
  ADD CONSTRAINT `FK_Emprestimo_com_multa_Emprestimo` FOREIGN KEY (`Numero`) REFERENCES `emprestimo` (`Numero`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `espaco_de_arrumacao`
--
ALTER TABLE `espaco_de_arrumacao`
  ADD CONSTRAINT `FK_Espaco_de_arrumacao_noname_Area_Tematica` FOREIGN KEY (`Area_Tematica_Id`) REFERENCES `area_tematica` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `exemplar`
--
ALTER TABLE `exemplar`
  ADD CONSTRAINT `FK_Exemplar_noname_Estado_de_conservacao` FOREIGN KEY (`Estado_de_conservacao_Nome`) REFERENCES `estado_de_conservacao` (`Nome`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Exemplar_noname_Prateleira` FOREIGN KEY (`Localizacao_Andar_Numero`,`Localizacao_Armario_Letra`,`Localizacao_Prateleira_Numero`) REFERENCES `prateleira` (`Andar_Numero`, `Armario_Letra`, `Numero`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Exemplar_noname_Publicacao_fisica` FOREIGN KEY (`Publicacao_Id`) REFERENCES `publicacao_fisica` (`Publicacao_Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `feed`
--
ALTER TABLE `feed`
  ADD CONSTRAINT `FK_Feed_noname_Area_Tematica` FOREIGN KEY (`Area_Tematica_Id`) REFERENCES `area_tematica` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Feed_noname_Editora_ou_Periodico` FOREIGN KEY (`Editora_ou_Periodico_Id`) REFERENCES `editora_ou_periodico` (`Id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Feed_noname_Periodicidade` FOREIGN KEY (`Periodicidade_Nome`) REFERENCES `periodicidade` (`Nome`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `lista_de_leitura`
--
ALTER TABLE `lista_de_leitura`
  ADD CONSTRAINT `FK_Lista_de_leitura_noname_Utente` FOREIGN KEY (`Utente_Numero`) REFERENCES `utente` (`Numero`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `livro`
--
ALTER TABLE `livro`
  ADD CONSTRAINT `FK_Livro_noname_Editora` FOREIGN KEY (`Editora_Nome`) REFERENCES `editora` (`Nome`) ON UPDATE CASCADE;

--
-- Limitadores para a tabela `livro_em_lista_leitura`
--
ALTER TABLE `livro_em_lista_leitura`
  ADD CONSTRAINT `FK_Edicao_de_Livro_Livro_em_Lista_leitura_Lista_de_leitura_` FOREIGN KEY (`Edicao_de_Livro_Livro_Id_`,`Edicao_de_Livro_Numero_`) REFERENCES `edicao_de_livro` (`Livro_Id`, `Numero`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Lista_de_leitura_Livro_em_Lista_leitura_Edicao_de_Livro_` FOREIGN KEY (`Lista_de_leitura_Utente_Numero_`,`Lista_de_leitura_Nome_`) REFERENCES `lista_de_leitura` (`Utente_Numero`, `Nome`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `monografia`
--
ALTER TABLE `monografia`
  ADD CONSTRAINT `FK_Monografia_Publicacao` FOREIGN KEY (`Publicacao_Id`) REFERENCES `publicacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Monografia_noname_Tipo_de_monografia` FOREIGN KEY (`Tipo_de_monografia_Nome`) REFERENCES `tipo_de_monografia` (`Nome`) ON UPDATE CASCADE;

--
-- Limitadores para a tabela `palavra_chave_descreve_publicacao`
--
ALTER TABLE `palavra_chave_descreve_publicacao`
  ADD CONSTRAINT `FK_Palavra_chave_tag_Palavra_chave_descreve_Publicacao_` FOREIGN KEY (`Palavra_chave_`) REFERENCES `palavra_chave_tag` (`Palavra`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Publicacao_Palavra_chave_descreve_Publicacao_` FOREIGN KEY (`Publicacao_Id_`) REFERENCES `publicacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `periodico`
--
ALTER TABLE `periodico`
  ADD CONSTRAINT `FK_Periodico_Editora_ou_Periodico` FOREIGN KEY (`Editora_ou_Periodico_Id`) REFERENCES `editora_ou_periodico` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Periodico_noname_Editora` FOREIGN KEY (`Editora_Nome`) REFERENCES `editora` (`Nome`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Periodico_noname_Periodicidade` FOREIGN KEY (`Periodicidade_Nome`) REFERENCES `periodicidade` (`Nome`) ON UPDATE CASCADE;

--
-- Limitadores para a tabela `prateleira`
--
ALTER TABLE `prateleira`
  ADD CONSTRAINT `FK_Prateleira_Espaco_de_arrumacao` FOREIGN KEY (`Espaco_de_arrumacao_Id`) REFERENCES `espaco_de_arrumacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Prateleira_noname_Armario` FOREIGN KEY (`Andar_Numero`,`Armario_Letra`) REFERENCES `armario` (`Andar_Numero`, `Letra`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `publicacao`
--
ALTER TABLE `publicacao`
  ADD CONSTRAINT `FK_Publicacao_Publicacao_em_Area_Area_Tematica` FOREIGN KEY (`Area_Tematica_Id`) REFERENCES `area_tematica` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Limitadores para a tabela `publicacao_digital`
--
ALTER TABLE `publicacao_digital`
  ADD CONSTRAINT `FK_Publicacao_digital_Publicacao` FOREIGN KEY (`Publicacao_Id`) REFERENCES `publicacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `publicacao_fisica`
--
ALTER TABLE `publicacao_fisica`
  ADD CONSTRAINT `FK_Publicacao_fisica_Publicacao` FOREIGN KEY (`Publicacao_Id`) REFERENCES `publicacao` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `reserva`
--
ALTER TABLE `reserva`
  ADD CONSTRAINT `FK_Publicacao_fisica_Reserva_Utente_` FOREIGN KEY (`Publicacao_Id_`) REFERENCES `publicacao_fisica` (`Publicacao_Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Reserva_noname_Exemplar` FOREIGN KEY (`Exemplar_escolhido_Publicacao_Id`,`Exemplar_Nr`) REFERENCES `exemplar` (`Publicacao_Id`, `Nr`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_Utente_Reserva_Publicacao_fisica_` FOREIGN KEY (`Utente_Numero_`) REFERENCES `utente` (`Numero`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `revista`
--
ALTER TABLE `revista`
  ADD CONSTRAINT `FK_Revista_Periodico` FOREIGN KEY (`Periodico_Editora_ou_Periodico_Id`) REFERENCES `periodico` (`Editora_ou_Periodico_Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Limitadores para a tabela `utente_suspenso`
--
ALTER TABLE `utente_suspenso`
  ADD CONSTRAINT `FK_Utente_Suspenso_Utente` FOREIGN KEY (`Numero`) REFERENCES `utente` (`Numero`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
