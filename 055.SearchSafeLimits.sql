use [CdiForFunOrProfit];
GO

set nocount on;

-- Script para procurar os limites de segurança do algoritmo rápido e os salvar em tabela
declare @maxDate date;
set @maxDate = '2022-03-11'; -- pode ser um dia útil a mais que o maior CDI

declare @minDate date;
set @minDate = (select min([Date]) from [Over].Cdi);

declare @minAlpha decimal(6,2);
set @minAlpha = 50;

declare @maxAlpha decimal(6, 2)
set @maxAlpha = 1000;

declare @deltaAlpha decimal(6, 2)
set @deltaAlpha = 50;

declare @alpha decimal(6, 2);

declare @factorCanon decimal(27, 8);
declare @factorQuick decimal(27, 8);

declare @isSafe bit;

-- Loop voltando para o passado de ano em ano em relação ao máximo
declare @years int;
set @years = 1;
declare @start date;
set @start = DATEADD(year, -@years, @maxDate);
while (@start >= @minDate)
begin
	print 'Procurando limites entre ' + convert(char(10), @start, 23) + ' e ' + convert(char(10), @maxDate, 23) + '(' + cast(@years as varchar(2)) + ' anos) ...';

	-- Loop dos Alphas
	set @alpha = @minAlpha;
	while (@alpha <= @maxAlpha)
	begin
		set @factorCanon = [Over].GetCdiFactorCanon(@start, @maxDate, @alpha);
		set @factorQuick = [Over].GetCdiFactorExpSumLn(@start, @maxDate, @alpha);

		set @isSafe = 0;
		if (@factorCanon = @factorQuick)
		begin
			set @isSafe = 1;	
		end;

		print ' Alpha ' + format(@alpha, 'G17') + ': ' + format(@factorCanon, 'G17') + ' == ' + format(@factorQuick, 'G17') + ' ? ' + cast(@isSafe as char(1));

		-- Atualiza a tabela de limites (idempotente)
		update [Over].[CdiSafeLimits]
			set IsSafe = @isSafe
			where
				[Start] = @start and
				[End] = @maxDate and
				[Alpha] = @alpha;

		if (@@ROWCOUNT <= 0)
		begin
			insert into [Over].[CdiSafeLimits] ([Start], [End], Alpha, IsSafe) values (@start, @maxDate, @alpha, @isSafe);
		end;


		set @alpha = @alpha + @deltaAlpha;
	end;

	set @years = @years + 1;
	set @start = DATEADD(year, -@years, @maxDate);
end;
GO
