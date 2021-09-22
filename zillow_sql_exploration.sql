select *
from airconditioningtype
limit 1;

select *
from architecturalstyletype
limit 1;

select *
from buildingclasstype
limit 1;

select *
from heatingorsystemtype
limit 1;

select *
from predictions_2016
limit 1;

select *
from predictions_2017
limit 1;

select *
from properties_2016
limit 1;

select *
from properties_2017
limit 1;

select *
from propertylandusetype
limit 1;

select *
from storytype
limit 1;

select *
from typeconstructiontype
limit 1;

select *
from unique_properties
limit 1;

# uses inner joins, but at the end calls no rows even without limit (possibly because too many rows have nulls, meaning that inner join
# at the end returns nothing
select *
from properties_2016
join airconditioningtype using(airconditioningtypeid)
join architecturalstyletype using(architecturalstyletypeid)
join buildingclasstype using(buildingclasstypeid)
join heatingorsystemtype using(heatingorsystemtypeid)
join predictions_2016 using(id)
join predictions_2017 using(id)
join propertylandusetype using(propertylandusetypeid)
join storytype using(storytypeid)
join typeconstructiontype using(typeconstructiontypeid)
# different method used for unique_properties because parcelid caused 'ambiguous' error
join unique_properties on properties_2016.parcelid = unique_properties.parcelid
join properties_2017 using(id)
limit 1;


# uses left joins so that the properties_2017 is used as the base, and is always included in the join
select *
from properties_2017
left join airconditioningtype on properties_2017.airconditioningtypeid = airconditioningtype.airconditioningtypeid
left join architecturalstyletype on properties_2017.architecturalstyletypeid = architecturalstyletype.architecturalstyletypeid
left join buildingclasstype on properties_2017.buildingclasstypeid = buildingclasstype.buildingclasstypeid
left join heatingorsystemtype on properties_2017.heatingorsystemtypeid = heatingorsystemtype.heatingorsystemtypeid
left join predictions_2016 on properties_2017.id = predictions_2016.id
left join predictions_2017 on properties_2017.id = predictions_2017.id
left join propertylandusetype on properties_2017.propertylandusetypeid = propertylandusetype.propertylandusetypeid
left join storytype on properties_2017.storytypeid = storytype.storytypeid
left join typeconstructiontype on properties_2017.typeconstructiontypeid = typeconstructiontype.typeconstructiontypeid
left join unique_properties on properties_2017.parcelid = unique_properties.parcelid
# 2016 is unneeded becauese we are only interested in sales transactions that occurred in 2017 
# left join properties_2016 on properties_2017.id = properties_2016.id
where predictions_2017.transactiondate = max(predictions_2017.transactiondate)

limit 1;



SELECT prop.*, pred.logerror, pred.transactiondate, air.airconditioningdesc, arch.architecturalstyledesc, build.buildingclassdesc, heat.heatingorsystemdesc, 
landuse.propertylandusedesc, story.storydesc, construct.typeconstructiondesc
FROM properties_2017 prop
INNER JOIN (SELECT parcelid, Max(transactiondate) transactiondate FROM predictions_2017 GROUP BY parcelid) pred USING (parcelid)
JOIN predictions_2017 as pred USING (parcelid, transactiondate)
LEFT JOIN airconditioningtype air USING (airconditioningtypeid)
LEFT JOIN architecturalstyletype arch USING (architecturalstyletypeid)
LEFT JOIN buildingclasstype build USING (buildingclasstypeid)
LEFT JOIN heatingorsystemtype heat USING (heatingorsystemtypeid)
LEFT JOIN propertylandusetype landuse USING (propertylandusetypeid)
LEFT JOIN storytype story USING (storytypeid)
LEFT JOIN typeconstructiontype construct USING (typeconstructiontypeid)
WHERE prop.latitude IS NOT NULL AND prop.longitude IS NOT NULL



LIMIT 1;





SELECT prop.*
FROM properties_2017 prop

LIMIT 1;
