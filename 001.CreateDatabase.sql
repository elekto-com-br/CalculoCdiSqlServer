USE [master]
GO

CREATE DATABASE [CdiForFunOrProfit]
 ON  PRIMARY 
( NAME = N'CdiForFunOrProfit', FILENAME = N'C:\DB\CdiForFunOrProfit.mdf' , SIZE = 5MB , MAXSIZE = 100MB , FILEGROWTH = 10MB)
 LOG ON 
( NAME = N'CdiForFunOrProfit_log', FILENAME = N'C:\DB\CdiForFunOrProfit.ldf' , SIZE = 512KB , MAXSIZE = 100MB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT;
GO

-- Só testes, não precisamos de recovery completo...
ALTER DATABASE [CdiForFunOrProfit] SET RECOVERY SIMPLE;
GO

use [CdiForFunOrProfit];
GO

-- Um esquema, para ficar mais organizado
create schema [Over];
GO
