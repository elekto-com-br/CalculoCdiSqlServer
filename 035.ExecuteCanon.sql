use [CdiForFunOrProfit];
GO

delete [Over].[Output] where BatchId = 'In01';
GO

-- limpar buffers, teste do zero
CHECKPOINT;
GO
DBCC DROPCLEANBUFFERS;
GO

set nocount on;

declare @start datetime;
declare @end datetime;
declare @count bigint;

set @start = GETUTCDATE();

insert into [Over].[Output] (BatchId, Id, Factor)
	select 
			i.BatchId, i.Id, [Over].GetCdiFactorCanon(i.[Start], i.[End], i.Alpha)
		from [Over].Input i
		where i.BatchId = 'In01';

set @count = @@ROWCOUNT;

set @end = GETUTCDATE();

declare @delta int;
set @delta = DATEDIFF(ms, @start, @end); --ms

declare @speed float;
set @speed = @count * 1000.0E0 / @delta; -- calculos/s

print 'Feitos ' + FORMAT(@count, 'N0') + ' cálculos em ' + FORMAT(@delta, 'N0') + 'ms. Velocidade: ' + format(@speed, 'N1') + ' cálculos/s';
GO
