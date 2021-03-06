/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [PharmacyID]
      ,[fac_id], fac_id+substring(dsps_dtm,7,4) as id
	  , substring(dsps_dtm, 7,4) as runthis
	  ,substring(dsps_dtm,9,2) as hour
	  ,count(*) as pack
	  , count(*) * 1.4 as estimated
into #temp1111	  
  FROM ETL..[Dsps_medicine_history] (nolock)
  where dsps_dtm between '20200126000000' and '20200129000000'
  
  group by [PharmacyID]
      ,[fac_id],fac_id+substring(dsps_dtm,7,4), substring(dsps_dtm,9,2), substring(dsps_dtm, 7,4)

order by pharmacyID, fac_id, fac_id+substring(dsps_dtm,7,4)

select *,sum(estimated) over (partition by fac_id order by id) as cum, 4000 - sum(estimated) over (partition by fac_id order by id) as leftover
from #temp1111
order by pharmacyID, fac_id, id

