# /* ex: set ft=sql: */

le batch dmsinjecter qui traite les factures scannées papier libérées par les batch TGE tourne 2 fois par jour, les jours de la semaine non-férié et ne traite que 8000 documents à chaque occurence dans un ordre que je n'ai pas essayé de déterminer, mais visiblement en tout cas pas du plus vieux au plus récent.

les logs de ce batch dmsinjecter sont stockés dans \\gmaputl03\log_prd_gmapdms04\dms\dmsInjecter\log\dms-injector_run_scan_fact_sin_tge*
les docs de sortie du batch dans \\gmaputl03\dmsinjecter_prd_gmapora08_r\scanocr\sinistre\tge\processed\
sa chaine UC4 est /DMS/DMS.1000.UPLOAD_PDF/PDF_TGE/DMS.1000.UPLOAD_PDF_TGE.JOBP

la limite de 8000 a été relevée à 10'000 par Jean-Marc après discussion avec quelqu'un de service transverse afin de ratrapper le retard

# 23DEC2014 donne le nombre de fichiers techniques en attente surveillés par Alfonso Alonso Rivera et Sebastien Bisoglio
ssh gmapocr17 '/usr/bin/find /cygdrive/d/apps/Export/Sinistre/TGEs/Technique | wc -l'
98226


# 23DEC2014 investigue l'etat des 90'000 fichiers du répertoire technique:
# Réponse: la plupart correspondent au 45845 factures (1 factures = 2 technique et 2 binaires) en status 1
select
	count(1),
	status,
	min(date_export) as min_date_export,
	max(date_export) as max_date_export,
	min(date_cmd) as min_date_cmd,
	max(date_cmd) as max_date_cmd,
	min(date_retour) as min_date_retour,
	max(date_retour) as max_date_retour,
	min(date_dms) as min_date_dms,
	max(date_dms) as max_date_dms,
	min(last_change) as min_last_change,
	max(last_change) as max_last_change
from gmatges group by  status
order by status;
+--------+--------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+
|        | status |   min_date_export   |   max_date_export   |     min_date_cmd    |     max_date_cmd    |   min_date_retour   |   max_date_retour   |     min_date_dms    |     max_date_dms    |   min_last_change   |   max_last_change   |
+--------+--------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+
|   1    |   -9   | 2010-01-01 01:01:01 | 2010-01-01 01:01:01 |                     |                     |                     |                     |                     |                     |                     |                     |
|   2    |   -6   | 2014-12-03 21:50:10 | 2014-12-08 20:07:38 |                     |                     |                     |                     |                     |                     | 2014-12-04 19:24:13 | 2014-12-09 19:18:09 |
|   74   |   -2   | 2014-09-15 14:18:52 | 2014-12-22 14:47:32 |                     |                     |                     |                     |                     |                     | 2014-09-15 19:19:20 | 2014-12-23 06:07:59 |
|  2336  |   -1   | 2014-09-15 07:25:13 | 2014-12-22 17:31:30 | 2014-12-10 19:41:45 | 2014-12-10 19:41:45 |                     |                     | 2014-12-11 12:06:32 | 2014-12-11 12:06:32 | 2014-09-15 19:00:36 | 2014-12-23 03:14:31 |
|  2296  |   0    | 2014-12-23 08:02:21 | 2014-12-23 10:02:51 |                     |                     |                     |                     |                     |                     |                     |                     |
| 45845  |   1    | 2014-12-15 07:19:25 | 2014-12-22 18:00:49 | 2014-12-23 06:13:10 | 2014-12-23 06:14:19 |                     |                     |                     |                     | 2014-12-23 06:13:10 | 2014-12-23 06:14:19 |
|  279   |   3    | 2014-12-15 08:49:35 | 2014-12-22 17:31:37 |                     |                     |                     |                     |                     |                     | 2014-12-23 03:14:35 | 2014-12-23 06:09:22 |
| 356586 |   5    | 2014-06-11 14:29:02 | 2014-12-15 16:42:39 | 2014-09-15 19:24:10 | 2014-12-12 19:25:33 | 2014-09-23 17:02:19 | 2014-09-23 17:02:19 | 2014-06-12 12:16:16 | 2014-12-16 12:02:27 | 2014-09-16 12:01:44 | 2014-12-16 12:02:27 |
+--------+--------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+

# 29DEC2014
+--------+--------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+
|        | status |   min_date_export   |   max_date_export   |     min_date_cmd    |     max_date_cmd    |   min_date_retour   |   max_date_retour   |     min_date_dms    |     max_date_dms    |   min_last_change   |   max_last_change   |
+--------+--------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+
|   1    |   -9   | 2010-01-01 01:01:01 | 2010-01-01 01:01:01 |                     |                     |                     |                     |                     |                     |                     |                     |
|   2    |   -6   | 2014-12-03 21:50:10 | 2014-12-08 20:07:38 |                     |                     |                     |                     |                     |                     | 2014-12-04 19:24:13 | 2014-12-09 19:18:09 |
|   70   |   -2   | 2014-09-22 09:32:46 | 2014-12-23 16:52:43 |                     |                     |                     |                     |                     |                     | 2014-09-22 19:17:45 | 2014-12-23 22:34:54 |
|  2233  |   -1   | 2014-09-22 07:49:29 | 2014-12-24 11:44:47 | 2014-12-10 19:41:45 | 2014-12-10 19:41:45 |                     |                     | 2014-12-11 12:06:32 | 2014-12-11 12:06:32 | 2014-09-22 19:00:45 | 2014-12-24 19:47:42 |
|  3781  |   0    | 2014-12-29 07:45:54 | 2014-12-29 14:02:51 |                     |                     |                     |                     |                     |                     |                     |                     |
| 22447  |   3    | 2014-12-18 13:35:14 | 2014-12-24 11:59:54 | 2014-12-23 06:13:12 | 2014-12-24 20:06:25 |                     |                     |                     |                     | 2014-12-23 05:47:34 | 2014-12-29 12:00:13 |
| 377325 |   5    | 2014-06-11 14:29:02 | 2014-12-23 09:24:52 | 2014-09-19 19:27:24 | 2014-12-23 22:42:37 | 2014-09-23 17:02:19 | 2014-09-23 17:02:19 | 2014-06-12 12:16:16 | 2014-12-29 12:21:29 | 2014-09-22 12:01:29 | 2014-12-29 12:21:29 |
+--------+--------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+---------------------+




# 23DEC2014 echantillon pris au hasard où le choix du hasard a été sélectionné en fonction de
ssh gmapocr17 'ls -1 /cygdrive/d/apps/Export/Sinistre/TGEs/Technique | head'
SCAN_00361670-13_PVT_tech.xml
SCAN_00361670-13_tech.xml
SCAN_00361670-15_PVT_tech.xml
SCAN_00361670-15_tech.xml
SCAN_00361670-17_PVT_tech.xml
SCAN_00361670-17_tech.xml
SCAN_00361670-21_PVT_tech.xml
SCAN_00361670-21_tech.xml
SCAN_00361670-28_PVT_tech.xml
SCAN_00361670-28_tech.xml

# 23DEC2014 statut pour cet échantillon
select * from gmatges where doc_id like 'SCAN_00361670%';
+----------------------------------------------------+--------------+------------------+---------------------+---------------------+-------------+----------+---------------------+------+--------+
|                     token_num                      | trust_center |      doc_id      |     date_export     |       date_cmd      | date_retour | date_dms |     last_change     | type | status |
+----------------------------------------------------+--------------+------------------+---------------------+---------------------+-------------+----------+---------------------+------+--------+
| 5100000105903246599000003025301970006111+010040900 |      51      | SCAN_00361670-13 | 2014-12-15 10:23:25 | 2014-12-23 06:13:28 |             |          | 2014-12-23 06:13:28 |  1   |   1    |
| 5100000372808330167000000002014110170135+010033103 |      51      | SCAN_00361670-15 | 2014-12-15 10:23:26 | 2014-12-23 06:13:28 |             |          | 2014-12-23 06:13:28 |  1   |   1    |
| 5700000225102979554005398519800071280166+010275199 |      57      | SCAN_00361670-17 | 2014-12-15 10:23:27 | 2014-12-23 06:14:09 |             |          | 2014-12-23 06:14:09 |  1   |   1    |
| 5100000262804046291522327000266444540417+010370058 |      51      | SCAN_00361670-21 | 2014-12-15 10:23:29 | 2014-12-23 06:13:28 |             |          | 2014-12-23 06:13:28 |  1   |   1    |
| 5100000670202161318912030022234000043597+010015195 |      51      | SCAN_00361670-28 | 2014-12-15 10:23:32 | 2014-12-23 06:13:28 |             |          | 2014-12-23 06:13:28 |  1   |   1    |
| 5500000244508572290001973719800129880227+010263234 |      55      | SCAN_00361670-3  | 2014-12-15 10:23:21 | 2014-12-23 06:13:56 |             |          | 2014-12-23 06:13:56 |  1   |   1    |
| 5800000335506324935005866119800006751187+010018527 |      58      | SCAN_00361670-30 | 2014-12-15 10:23:33 | 2014-12-23 06:14:12 |             |          | 2014-12-23 06:14:12 |  1   |   1    |
| 6000000238057000000001180619800020010061+010856375 |      60      | SCAN_00361670-32 | 2014-12-15 10:23:34 | 2014-12-23 06:14:15 |             |          | 2014-12-23 06:14:15 |  1   |   1    |
| 5300000153001016291505377061696441294639+010370058 |      53      | SCAN_00361670-34 | 2014-12-15 10:23:35 | 2014-12-23 06:13:54 |             |          | 2014-12-23 06:13:54 |  1   |   1    |
| 5100000274157810299003319819800035180048+010015187 |      51      | SCAN_00361670-49 | 2014-12-15 10:23:41 | 2014-12-23 06:13:28 |             |          | 2014-12-23 06:13:28 |  1   |   1    |
| 5100002013400046291504984022047445303632+010370058 |      51      | SCAN_00361670-5  | 2014-12-15 10:23:22 | 2014-12-23 06:13:28 |             |          | 2014-12-23 06:13:28 |  1   |   1    |
| 5100000261304046291514404012891436676413+010370058 |      51      | SCAN_00361670-51 | 2014-12-15 10:23:42 | 2014-12-23 06:13:28 |             |          | 2014-12-23 06:13:28 |  1   |   1    |
| 5500000078309822292000000000000037777003+012000998 |      55      | SCAN_00361670-55 | 2014-12-15 10:23:43 | 2014-12-23 06:13:56 |             |          | 2014-12-23 06:13:56 |  1   |   1    |
| 5900000155100246986000000000002001303106+010052177 |      59      | SCAN_00361670-61 | 2014-12-15 10:23:46 | 2014-12-23 06:14:13 |             |          | 2014-12-23 06:14:13 |  1   |   1    |
| 5900000132205246986000000000002001277524+010052177 |      59      | SCAN_00361670-63 | 2014-12-15 10:23:47 | 2014-12-23 06:14:13 |             |          | 2014-12-23 06:14:13 |  1   |   1    |
| 5900000253953246986000000000002001327308+010052177 |      59      | SCAN_00361670-65 | 2014-12-15 10:23:48 | 2014-12-23 06:14:13 |             |          | 2014-12-23 06:14:13 |  1   |   1    |
| 5900000357853246986000000000002001350422+010052177 |      59      | SCAN_00361670-67 | 2014-12-15 10:23:49 | 2014-12-23 06:14:13 |             |          | 2014-12-23 06:14:13 |  1   |   1    |
| 5400000419653363810700394800419650593452+010060536 |      54      | SCAN_00361670-70 | 2014-12-15 10:23:50 | 2014-12-23 06:13:56 |             |          | 2014-12-23 06:13:56 |  1   |   1    |
| 5300000389301254127002029719800035560391+010040541 |      53      | SCAN_00361670-74 | 2014-12-15 10:23:52 | 2014-12-23 06:13:54 |             |          | 2014-12-23 06:13:54 |  1   |   1    |
| 5100000165803000000000000061800997560265+010418002 |      51      | SCAN_00361670-84 | 2014-12-15 10:23:57 | 2014-12-23 06:13:28 |             |          | 2014-12-23 06:13:28 |  1   |   1    |
| 2200000425203248488000011253821002532787+010040653 |      22      | SCAN_00361670-9  | 2014-12-15 10:23:24 | 2014-12-23 06:13:10 |             |          | 2014-12-23 06:13:10 |  1   |   1    |
+----------------------------------------------------+--------------+------------------+---------------------+---------------------+-------------+----------+---------------------+------+--------+



+--------+-------------------------------------------------------------------------------------------------------+------------------------------------+---+
| statut | commentaire                                                                                           | process pouvant "setter" ce status | - |
+--------+-------------------------------------------------------------------------------------------------------+------------------------------------+---+
| -9     | 1 enregistrement unique utilisé pour les tests de configuration                                       |                                    | - |
| -6     | document sans PDF (message à l'équipe scan ocr)                                                       |                                    | - |
| -5     | erreur de traitement du DMS                                                                           |                                    | - |
| -3     | erreur de traitement du DMS                                                                           |                                    | - |
| -2     | renvoyé pour rescannage (le PDF est déplacé et les autresfichiers du documentsont supprimés)          |                                    | - |
| -1     | doublon (les 4 fichiers du documents sont supprimés)                                                  |                                    | - |
| 0      | exporté par Scan Ocr                                                                                  |                                    | - |
| 1      | facture électronique commandée                                                                        |                                    | - |
| 2      | facture électronique reçue                                                                            | TGE_Reception_tctoken_main, embarqué dans entrant_traitements) | - |
| 3      | à traiter par le DMS (facture électronique non reçue dans les délais                                  |                                    | - |
| 4      | en cours de traitement par le DMS                                                                     |                                    | - |
| 5      | traité par le DMS (les 4 fichiers du document ont été déplacés)                                       |                                    | - |
| 6      | Suite à une facture électronique reçue (état 2) les 4 fichiers de la facture papier ont été supprimés | TGE_Controle_delai_main            | - |
+--------+-------------------------------------------------------------------------------------------------------+------------------------------------+---+
