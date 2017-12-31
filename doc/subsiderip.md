sed -r -e "s/(messageId)>[^<]+/\\1>$(uuidgen)/" message_5-12.xml | grep -E '^|messageId'

for i in $(find /dataflow/contrat/subsiderip/20141013_XSD_Datenaustausch_PV/example -name '*xml'); do 
	sed -i -r -e "s/(messageId)>[^<]+/\\1>$(uuidgen)/" $i 
 	scp $i ibatch@gmaibat02:/batchdata/documents/integration/contrat/rip/etlinput/inbox/AV
	/d/uc4/RIP_Input_Main/int/exec_uc4_and_tail
done
