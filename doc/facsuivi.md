# /* ex: set ft=sql: */

select * from facsuivi;
select * from facsuivi where txfactfichier like '%H-NET_4182_37345511%';

select strftime('%Y.%m.%d %H:%M:%S', datetime(ohdatcre / 1000, 'unixepoch')), * from facsuivi order by idsuivi desc;

select * from facsuivi where length(txfactfichier) >= 100;
select length(txfactfichier), * from facsuivi where length(txfactfichier) >= 80 order by 1 desc;

create index facsuivi01 on facsuivi(txfactfichier);
