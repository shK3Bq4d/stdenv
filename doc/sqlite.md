# /* ex: set ft=sql: */

# https://www.sqlite.org/lang_corefunc.html

select strftime('%Y.%m.%d %H:%M:%S', datetime(ohdatcre / 1000, 'unixepoch')), * from facsuivi order by idsuivi desc;
select strftime('%Y.%m.%d %H:%M:%S', last_modified), * from qc order by last_modified desc;

select * from facsuivi where length(txfactfichier) >= 100;
select length(txfactfichier), * from facsuivi where length(txfactfichier) >= 80 order by 1 desc;

create index facsuivi01 on facsuivi(txfactfichier);


SELECT replace(TXFACTUREORIGINALFILENAME, '_GM_MCD.', '.') AS TXNOMFICHIER, 
strftime('%Y-%m-%d', datetime(ohdatcre / 1000, 'unixepoch')) as txcreation,
strftime('%Y-%m-%d %H:%M:%S', datetime(ohdatcre / 1000, 'unixepoch')) as txcreationfull,
OHDATCRE AS DTCREATION, 
'TALEND' AS TXSOURCE, 
TXSTATUS
FROM FACSUIVI  
WHERE datetime(ohdatcre / 1000, 'unixepoch') BETWEEN  date(CURRENT_DATE, '-1 day')  AND CURRENT_DATE AND TXSTATUS <> 'replaymanuel'
and idsuivi in (5068783, 5008783);

select CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP;
select date(CURRENT_DATE, '-10 day'

SELECT date('now'); -- Compute the current date.

SELECT date('now','start of month','+1 month','-1 day'); -- Compute the last day of the current month.

SELECT datetime(1092941466, 'unixepoch'); -- Compute the date and time given a unix timestamp 1092941466.

SELECT datetime(1092941466, 'unixepoch', 'localtime'); -- Compute the date and time given a unix timestamp 1092941466, and compensate for your local timezone.

SELECT strftime('%s','now'); -- Compute the current unix timestamp.

SELECT julianday('now') - julianday('1776-07-04'); -- Compute the number of days since the signing of the US Declaration of Independence.

SELECT strftime('%s','now') - strftime('%s','2004-01-01 02:34:56'); -- Compute the number of seconds since a particular moment in 2004:

SELECT date('now','start of year','+9 months','weekday 2'); -- Compute the date of the first Tuesday in October for the current year.

SELECT (julianday('now') - 2440587.5)*86400.0; -- Compute the time since the unix epoch in seconds (like strftime('%s','now') except includes fractional part):


rowid

select owner, detected_by as detected, id, status, case when Livraison_cible is null then '' when Livraison_cible like '% SR %' then Livraison_cible else 'a' || Livraison_cible end as 'L.Cible', last_modified, name from qc
where
(      owner in('rutom','butryj','datessid','prettm','cavatera','trossart','spantonm') or
detected_by  in('rutom','butryj','datessid','prettm','cavatera','trossart','spantonm'))
and status not in ('Closed', 'Refused')
and detected_by not in ('penvent')
order by 
case when Livraison_cible is null then 'b' when Livraison_cible like '% SR %' then Livraison_cible else 'a' || Livraison_cible end,
id
;


select cdmapping, count(1) from facsuivi where nbannexe is not null group by cdmapping
GEN430	9806
GEN440	582




select jour, cdmapping, nbannexe, count(1) from (
select strftime('%Y.%m.%d', datetime(ohdatcre / 1000, 'unixepoch')) as jour, cdmapping, nbannexe  from facsuivi where idsuivi > 5200000
) group by jour, cdmapping, nbannexe
order by jour, cdmapping
2014.11.12 	 GEN410 	 <null> 	 901
2014.11.12 	 GEN430 	 <null> 	 382
2014.11.12 	 GEN430 	 2      	 35
2014.11.12 	 GEN440 	 <null> 	 171
2014.11.12 	 HOP400 	 <null> 	 1409
2014.11.12 	 LAB300 	 <null> 	 235
2014.11.12 	 MED400 	 <null> 	 1780
2014.11.12 	 PHA400 	 <null> 	 27805
2014.11.13 	 GEN410 	 <null> 	 687
2014.11.13 	 GEN430 	 <null> 	 2248
2014.11.13 	 GEN430 	 2      	 74
2014.11.13 	 GEN440 	 <null> 	 942
2014.11.13 	 HOP400 	 <null> 	 6059
2014.11.13 	 LAB300 	 <null> 	 207
2014.11.13 	 MED300 	 <null> 	 26
2014.11.13 	 MED400 	 <null> 	 4899
2014.11.13 	 PHA400 	 <null> 	 4135
2014.11.14 	 GEN410 	 <null> 	 1573
2014.11.14 	 GEN430 	 <null> 	 2274
2014.11.14 	 GEN430 	 2      	 107
2014.11.14 	 GEN440 	 <null> 	 1607
2014.11.14 	 HOP400 	 <null> 	 3839
2014.11.14 	 LAB300 	 <null> 	 335
2014.11.14 	 MED300 	 <null> 	 24
2014.11.14 	 MED400 	 <null> 	 4580
2014.11.14 	 PHA400 	 <null> 	 25243
2014.11.15 	 PHA400 	 <null> 	 2
2014.11.16 	 GEN410 	 <null> 	 830
2014.11.16 	 GEN430 	 <null> 	 2531
2014.11.16 	 GEN430 	 2      	 72
2014.11.16 	 GEN440 	 <null> 	 2419
2014.11.16 	 HOP400 	 <null> 	 4872
2014.11.16 	 LAB300 	 <null> 	 223
2014.11.16 	 MED300 	 <null> 	 2
2014.11.16 	 MED400 	 <null> 	 3509
2014.11.16 	 PHA400 	 <null> 	 9580
2014.11.17 	 GEN430 	 2      	 6
