use [CdiForFunOrProfit];
GO

-- Função canônica para o acúmulo de CDI Preciso (Regras B3, CETIP, CRT4 etc)
create or alter function [Over].GetCdiFactorCanon
(
	@start date,
	@end date,
	@alpha decimal(6, 2)
)
returns decimal(27, 8)
with SCHEMABINDING
as
begin
	-- resultado final, com 8 casas, arredondado
	declare @ret decimal(27, 8);
	
	-- o resultado acumulado é arredondado a partir de um acumulado com 16 casas truncadas
	declare @acc decimal(35, 16); 
	set @acc = 1;

	declare @dailyFactor	decimal(9, 8); -- já pré-computado na série do CDI
	declare @dailyFactorApha decimal(13, 12); -- não precisa de mais alcance e precisão que isso

	declare overCursor cursor FAST_FORWARD LOCAL for
		select [DailyFactor] from [Over].[Cdi] (nolock)
			where 
				[Date] >= @start	-- data inicial inclusive
				and [Date] < @end	-- data final exclusive
			order by [Date] asc;	-- não esqueça a ordenação explícita!

	open overCursor;

	fetch next from overCursor into @dailyFactor;
	while @@FETCH_STATUS = 0
	begin
		
		set @dailyFactorApha = (@dailyFactor * (@alpha / 100))+1; -- sem necessidade alguma de truncar
		
		set @acc = round(@acc * @dailyFactorApha, 16, 1);
		
		fetch next from overCursor into @dailyFactor;
	end;
	close overCursor;
	deallocate overCursor;

	set @ret = ROUND(@acc, 8); -- arredondado
	return @ret;
end;
GO

