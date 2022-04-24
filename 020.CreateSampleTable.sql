use [CdiForFunOrProfit];
GO

-- Cria a tabela para conter a massa de testes
 create table [Over].Input
 (
	BatchId char(4) not null,	-- para separar execuções diferentes
	Id bigint not null identity(1, 1), -- um id único para o registro a ser calculado
	[Start] date not null,
	[End] date not null,
	[Alpha] decimal(6, 2) not null,
	CONSTRAINT [PK_Over_Input] PRIMARY KEY CLUSTERED 
	(
		BatchId ASC,
		Id ASC
	) with (data_compression = page)
 );
 GO
