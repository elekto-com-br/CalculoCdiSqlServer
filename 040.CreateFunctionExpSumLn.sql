use [CdiForFunOrProfit];
GO

-- Função não-canônica para o acúmulo de CDI, sem a truncagem a cada passo no produtório
-- Mas usando os fatores CDI diários pré-calculados
create or alter function [Over].GetCdiFactorExpSumLn
(
	@start date,
	@end date,
	@alpha decimal(6, 2)
)
returns decimal(27, 8)
with SCHEMABINDING 
as
begin
	declare @ret decimal(27, 8);

	declare @sum float;
	select @sum =
			SUM
			(
				LOG
				(						
					1.0 + (cast(DailyFactor as float) * cast(@alpha as float)/100.0)
				)
			) 
		from [Over].[Cdi] (nolock)
		where 
			[Date] >= @start	-- data inicial inclusive
			and [Date] < @end;	-- data final exclusive

	-- se nenhum dia de CDI se acumulou ainda
	if @sum is null
	begin
		set @ret = 1;
		return @ret;
	end;
			
	declare @product float;
	set @product = EXP(@sum);
	
	set @ret = ROUND(@product, 8); -- arredondado
	return @ret;
end;
GO

