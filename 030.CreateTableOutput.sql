use [CdiForFunOrProfit];
GO

create table [Over].[Output]
(
	BatchId char(4) not null,
	Id bigint not null,
	[Factor] decimal(27, 8) not null,
	CONSTRAINT [PK_Over_Output] PRIMARY KEY CLUSTERED 
		(
			BatchId ASC,
			Id ASC
		) with (data_compression = page)
);
GO

