USE [CdiForFunOrProfit];
GO

CREATE TABLE [Over].[Cdi]
(
	[Date] [date] NOT NULL,
	[Rate] [decimal](8, 2) NOT NULL,
	[DailyFactor] as (cast((power([Rate]/100 + cast(1 as float), 0.003968253968253968) - 1) as decimal(9, 8))) persisted,
	CONSTRAINT [PK_Over_Cdi] PRIMARY KEY CLUSTERED 
	(
		[Date] ASC
	) WITH (DATA_COMPRESSION = PAGE)
);
GO

-- Só para testar com um número em particular...
insert into [Over].Cdi ([Date], Rate) values ('2021-07-30', 4.15);
select DailyFactor from [Over].Cdi where [Date] = '2021-07-30'; -- 0.00016137 é o esperado.
GO
