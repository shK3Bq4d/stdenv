
select 
messagetechid,
messagetype,
businessprocessid,
action,
ripdecreeinventoryelements.decreeinventorytechid,
ripdecreeinventoryelements.decreeinventoryelementtechid,
ripmessage.ohdatcre
from redp.ripmessage
left join redp.ripheader on ripmessage.headertechid = ripheader.headertechid
left join redp.ripcontent on ripmessage.contenttechid = ripcontent.contenttechid
left join redp.ripdecreeinventory on redp.ripcontent.decreeinventorytechid = ripdecreeinventory.decreeinventorytechid
left join redp.ripdecreeinventoryelements on ripdecreeinventory.decreeinventorytechid = ripdecreeinventoryelements.decreeinventorytechid
left join redp.ripdecreeinventoryelement  on ripdecreeinventoryelements.decreeinventoryelementtechid = ripdecreeinventoryelement.decreeinventoryelementtechid
where
messagetechid=221006 and
messagetype=5203 and
ripmessage.ohviscre = user

order by ripmessage.ohdatcre desc
;
