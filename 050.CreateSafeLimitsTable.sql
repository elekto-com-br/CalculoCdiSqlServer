use [CdiForFunOrProfit];
GO

-- Cria a tabela que conterá os limites de execução para o algoritmo rápido
create table [Over].[CdiSafeLimits]
(
	[Start] date not null,
	[End] date not null,
	[Alpha] decimal(6, 2) not null,
	IsSafe bit not null,
	CONSTRAINT [PK_Over_CdiSafeLimits] PRIMARY KEY CLUSTERED 
		(
			[Start] ASC,
			[End] ASC,
			[Alpha] ASC
		) with (data_compression = page)
);
GO


