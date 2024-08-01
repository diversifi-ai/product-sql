 select 
 	--*
 	'UPS' "Carrier"
 	--, account_number "account number"
	, count(distinct(tracking_number)) "packages"
 	, SUM(net_amount) "net amount"
 	, SUM(net_amount)+sum(incentive_amount) "gross amount"
 from public.ups_historical uh 
 --group by 
 --	account_number 
 union all
 select 
 	'FedEx' "Carrier"
 --	, bill_to_account_number "account number"
 	, count(distinct(express_or_ground_tracking_id)) "packages"
 	, SUM(net_charge_amount) "net amount"
 	, null "gross amount"
 from public.fdx_historical fh 
 --group by
 --	bill_to_account_number
 
