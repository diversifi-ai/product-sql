select 
	sum("Total Packages") "Total Packages"
	, sum("Packages Diversified") "Packages Diversified"
	, sum("Packages Diversified")/sum("Total Packages") "Diversification %"
	, sum("Original $") "Original $"
	, sum("DiFi Savings $") "DiFi Savings $"
	, sum("DiFi Savings $")/sum("Original $") "DiFi Savings %"
from (
select 
	count(distinct(tracking_id)) "Total Packages"
	, sum("DiFi Flag") "Packages Diversified"
	, to_char(sum("DiFi Flag")/cast(count(distinct(tracking_id)) as double precision)*100, '999D9%') "DiversiFication %"
	, sum(orig_net_charge_amount) "Original $"
	, case when "DiFi Flag" = 1 then sum(rate) else null end "DiFi Savings $"
from (
select 
	*
	, case when a.rate >= a.orig_net_charge_amount then 0 else 1 end "DiFi Flag"
--	sum(rate) "new rate"
--	, sum(orig_net_charge_amount) "old rate"
from(
select 
	tracking_id 
	, carrier 
	, service 
	, rate 
	, est_delivery_days 
	, orig_carrier 
	, orig_ship_service_type 
	, orig_net_charge_amount 
	, orig_delivery_days 
	, rank() over(partition by tracking_id order by rate asc) "price_rank"
from poc.gt_rates_v2 grv 
) "a"
where 
	price_rank = 1
	and orig_net_charge_amount <> 0
) "b"
group by 	
	"DiFi Flag"
) "c"
