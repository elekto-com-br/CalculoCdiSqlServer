use [CdiForFunOrProfit];
GO
 
set nocount on;
 
-- Popula com Registros Aleatórios de prazos variados cobrindo todo o range de modo uniforme
-- Para testes realistas, mimetize a distribuição de idade dos papéis em lote a computar

declare @batchId char(4);
set @batchId = 'In01';

declare @maxDate date;
set @maxDate = '2022-03-11'; -- pode ser um dia útil a mais que o CDI mais atual

declare @minDate date;
set @minDate = '2012-03-11'; -- 10 anos, para CDI, já é um bocado

declare @maxDays int;
set @maxDays = DATEDIFF(day, @minDate, @maxDate);

declare @minAlpha float;
set @minAlpha = 70.0;	-- menor alpha

declare @maxAlpha float;
set @maxAlpha = 300.0; -- maior alpha

declare @chanceAlpha100 float;
set @chanceAlpha100 = 0.30;	-- chance do Alpha ser exatamente 100%

declare @sampleSize int;
set @sampleSize = 10000;  -- vamos começar com calma...

print 'Data Mínima: ' + convert(char(10), @minDate, 23);
print 'Data Máxima: ' + convert(char(10), @minDate, 23);
print 'Prazo Máximo: ' + cast(@maxDays as varchar(5));
print 'Amostras: ' + cast(@sampleSize as varchar(20));

declare @alpha decimal(6, 2);
declare @start date;
declare @age int;
 
print 'Rand Inicial: ' + cast(rand(22) as varchar(15)); -- para ficar repetitiva a criação

declare @done int;
set @done = 0;
while (@done < @sampleSize)
begin
set @age = rand() * @maxDays;
set @start = DATEADD(day, -@age, @maxDate);

set @alpha = 100.0;
if (rand() > @chanceAlpha100)
begin
	set @alpha = @minAlpha + ((@maxAlpha - @minAlpha) * rand());
end;

insert into [Over].Input (BatchId, [Start], [End], [Alpha]) values (@batchId, @start, @maxDate, @alpha);

set @done = @done + 1;
end;
 
print 'Done!'
GO

 select count(1) as Num, AVG(Alpha) as AvgAlpha, AVG(DateDiff(day, [Start], [End])) as AvgAge from [Over].Input where BatchId = 'In01';
 -- deve dar 10000	159.730883	1809
