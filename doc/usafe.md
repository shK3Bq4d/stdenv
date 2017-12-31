# /* ex: set ft=sql: */

# changement integration vs production 
Select 'INTEGRATION', tmp.* From cont.wrkUsafeAcquisiteur@gma1i tmp
Where noacqumetier in (16627, 396, 12280, 9303)
union
Select 'PRODUCTION', tmp2.* From cont.wrkUsafeAcquisiteur@gma1p tmp2
Where noacqumetier in (16627, 396, 12280, 9303)
order by 2;


select * from part.rolacquisiteur@gma1p where noacqumetier = 501360;

select * from part.rolrole@gma1p where idrole = 63097313;

select * from commi.comconvention@gma1p where noacquconcerne = 63097312;

select * from commi.comconventionmodel@gma1p where idcomo in(29870062, 29870064);

select * from commi.cometatconvention@gma1p where idcomo in(29870062, 29870064);

/* Formatted on 03.09.2014 15:04:54 (QP5 v5.185.11230.41888) */
SELECT	*
	 FROM 	cont.wrkusafeacquisiteuractions@gma1p act
			INNER JOIN
				cont.wrkusafeacquisiteur@gma1p dat
			ON 	 act.noacqumetier = dat.noacqumetier
				AND act.txdomaine = dat.txdomaine
	WHERE act.noacqumetier = 501360
ORDER BY idusaa;
