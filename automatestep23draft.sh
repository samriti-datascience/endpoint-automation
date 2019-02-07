exec 1> $PMRootDir/Scripts/automate_log_$(date '+%Y_%m_%d_%H%M%S').log 2>&1 
#!/bin/bash
######################################################################################################################
# Program    : automate_end.sh                                                         #
# Author     : Samriti Attrey (sattrey@vmware.com)              #
# Date       : 3-Oct-2018                                  #
# Purpose    : This script is used to automate the end points  #
# Modification History                                                                                               #
# -----------  ------------------  --------------------------------------                                            #
# 11/14/2016   Samriti Attrey         Initial version                                                              #
#                                                                                                                    #
######################################################################################################################
#
set -x -v
. /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/automate.env
#inf_log : capture the user defined message in the logfile 
#SYNTAX  : inf_log "<user defined comments>"
#USAGE   : inf_log "\nServer Found"
################################################################################
inf_log() 
{
        echo -e "INFO: $ScriptName: $@" | tee -a $LogFile
}
execSQL()
{
   echo -e "\n##### CALLING FUNCTION execSQL #######" >> $LogFile
   
   ############# Check arguments ##############################
   if [ $# -lt 1 ]
	   then
		  err "ERROR: Incorrect number of arguments passed\n\nDB Login file is an optional argument." 
		  ##### ENDING FUNCTION execSQL #######
	   fi
   SQLSTRING=$1
   DBCONNECTSTRING=$DBUSER/$PASSWD@$SERVER
   echo -e "Obtained DB connection details.\n" >> $LogFile
   
   ############### Create SQL file  ###########################
   SQLFILE=SQLName_$$.sql
   echo -e "Creating temp Query file..." >> $LogFile
   
   echo -e "set trimspool on;" > $SQLFILE
   echo -e "set linesize 10000;" >> $SQLFILE
   echo -e "set serveroutput on;" >> $SQLFILE
   echo -e "$SQLSTRING" >> $SQLFILE
   echo -e "Created Query file $SQLFILE." >> $LogFile
   echo -e "$SQLSTRING"  >> $LogFile
   echo -e "SQL file contents to be executed:\n" >> $LogFile
   cat $SQLFILE >> $LogFile
       
   ####### Execute the query ##############
   echo -e "Connecting to DB to execute query..." >> $LogFile
   
QUERYOUTPUT=`sqlplus -s $DBCONNECTSTRING @$SQLFILE 2>&1 <<- EOF
commit
exit
EOF`
   
      ####### Check if SQLPLUS returned an error ##########
   if [ $? -ne 0 ]
   then
      inf_log "Output of the query is:\n\n$QUERYOUTPUT\n\n"
      err "Error $? : Error executing SQLPLUS. Please check log"	
   fi
   
   #inf_log "Output of the query is:\n\n$QUERYOUTPUT\n\n" 
   ######### Check if QUERY returned an error ##########
   ERR_COUNT1=`echo -e "$QUERYOUTPUT"|grep -i "^ERROR"|wc -l|tr -s ' '`
   ERR_COUNT2=`echo -e "$QUERYOUTPUT"|grep -i "^SP2-"|wc -l|tr -s ' '`
   ERR_COUNT3=`echo -e "$QUERYOUTPUT"|grep -i "^CPY-"|wc -l|tr -s ' '`
   ERR_COUNT=`expr $ERR_COUNT1 + $ERR_COUNT2 + $ERR_COUNT3`
 
   if [ $ERR_COUNT -ne 0 ]
	   then
		  echo -e "Deleting temporary SQL file $SQLFILE..." >> $LogFile
		  rm $SQLFILE 2>&1 >> $LogFile
		  echo -e "Deleted temporary SQL file $SQLFILE..." >> $LogFile
		  cat $LogFile
		  err "ERROR!!! Errors were generated by SQL query. Please check query output for more details"
	   else 
			echo -e "SQL executed successfully!!" >> $LogFile
			echo -e "Deleting temporary SQL file $SQLFILE..." >> $LogFile
			rm $SQLFILE 2>&1 >> $LogFile
			echo -e "Deleted temporary SQL file $SQLFILE..." >> $LogFile
   fi
   
      echo -e "##### ENDING FUNCTION execSQL #######\n\n" >> $LogFile

   echo -e "$QUERYOUTPUT"  ## This output will be captured by a variable in the main script   

   return 0
}
execSQL1()
{
   echo -e "\n##### CALLING FUNCTION execSQL1 #######" >> $LogFile
   
   ############# Check arguments ##############################
   if [ $# -lt 1 ]
	   then
		  err "ERROR: Incorrect number of arguments passed\n\nDB Login file is an optional argument." 
		  ##### ENDING FUNCTION execSQL1 #######
	   fi
   SQLSTRING=$1
   DBCONNECTSTRING=$DBUSER1/$PASSWD1@$SERVER1
   echo -e "Obtained DB connection details.\n" >> $LogFile
   
   ############### Create SQL file  ###########################
   SQLFILE=SQLName_$$.sql
   echo -e "Creating temp Query file..." >> $LogFile
   
   echo -e "set trimspool on;" > $SQLFILE
   echo -e "set linesize 10000;" >> $SQLFILE
   echo -e "set serveroutput on;" >> $SQLFILE
   echo -e "$SQLSTRING" >> $SQLFILE
   echo -e "Created Query file $SQLFILE." >> $LogFile
   echo -e "$SQLSTRING"  >> $LogFile
   echo -e "SQL file contents to be executed:\n" >> $LogFile
   cat $SQLFILE >> $LogFile
       
   ####### Execute the query ##############
   echo -e "Connecting to DB to execute query..." >> $LogFile
   
QUERYOUTPUT=`sqlplus -s $DBCONNECTSTRING @$SQLFILE 2>&1 <<- EOF
commit
exit
EOF`
   
      ####### Check if SQLPLUS returned an error ##########
   if [ $? -ne 0 ]
   then
      inf_log "Output of the query is:\n\n$QUERYOUTPUT\n\n"
      err "Error $? : Error executing SQLPLUS. Please check log"	
   fi
   
   #inf_log "Output of the query is:\n\n$QUERYOUTPUT\n\n" 
   ######### Check if QUERY returned an error ##########
   ERR_COUNT1=`echo -e "$QUERYOUTPUT"|grep -i "^ERROR"|wc -l|tr -s ' '`
   ERR_COUNT2=`echo -e "$QUERYOUTPUT"|grep -i "^SP2-"|wc -l|tr -s ' '`
   ERR_COUNT3=`echo -e "$QUERYOUTPUT"|grep -i "^CPY-"|wc -l|tr -s ' '`
   ERR_COUNT=`expr $ERR_COUNT1 + $ERR_COUNT2 + $ERR_COUNT3`
 
   if [ $ERR_COUNT -ne 0 ]
	   then
		  echo -e "Deleting temporary SQL file $SQLFILE..." >> $LogFile
		  rm $SQLFILE 2>&1 >> $LogFile
		  echo -e "Deleted temporary SQL file $SQLFILE..." >> $LogFile
		  cat $LogFile
		  err "ERROR!!! Errors were generated by SQL query. Please check query output for more details"
	   else 
			echo -e "SQL executed successfully!!" >> $LogFile
			echo -e "Deleting temporary SQL file $SQLFILE..." >> $LogFile
			rm $SQLFILE 2>&1 >> $LogFile
			echo -e "Deleted temporary SQL file $SQLFILE..." >> $LogFile
   fi
   
      echo -e "##### ENDING FUNCTION execSQL1 #######\n\n" >> $LogFile

   echo -e "$QUERYOUTPUT"  ## This output will be captured by a variable in the main script   

   return 0
}
LogFile=/apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/log_automate.log
#unix common function remove by putting it here
cat /dev/null >sqloutput.csv
cat /dev/null >sqloutput2.csv
cat /dev/null >sqloutput_1.csv
cat /dev/null >sqloutput_2.csv
cat /dev/null >cnx_hardcoded.csv
cat /dev/null >cnx_parametrised.csv
cat /dev/null >paramfilename.csv
cat /dev/null >connection_details.csv
#touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/input_wf.csv
w_count_exp=`wc -l $Workflow_File_host`
w_count=`echo $w_count_exp | cut -d' ' -f1`
for item in $(cat $Workflow_File_host)
do
	workflow=$item
	inf_log "Processing for workflow $workflow "
	echo "Processing workflow"
	echo $workflow
	if [ $w_count -lt 0 ]
		then
		break
	fi
	w_count=`expr $w_count - 1`
#session=`echo $item | cut -d',' -f2`
#find the session names from workflow
#TWO TEMP FILES sqloutput_1.csv,sqloutput_2.csv
	SQLSTRING="set echo off;
	set head off;
	set feed off;
	SELECT SESS.INSTANCE_NAME AS SESSION_NAME FROM INFAREP_DEV11.OPB_SUBJECT F, (SELECT TASK_NAME,TASK_ID,SUBJECT_ID,IS_VISIBLE,TASK_TYPE,MAX(VERSION_NUMBER) as VR FROM   INFAREP_DEV11.OPB_TASK WHERE IS_ENABLED=1 GROUP  BY TASK_NAME,TASK_ID,SUBJECT_ID,IS_VISIBLE,TASK_TYPE) WF,(SELECT WORKFLOW_ID,INSTANCE_ID,TASK_ID,INSTANCE_NAME FROM INFAREP_DEV11.OPB_TASK_INST WHERE( WORKFLOW_ID, INSTANCE_ID, TASK_ID, VERSION_NUMBER ) IN(SELECT   WORKFLOW_ID,INSTANCE_ID,TASK_ID,VERSION_NUMBER FROM (SELECT WORKFLOW_ID,INSTANCE_ID,TASK_ID, MAX(VERSION_NUMBER) AS VERSION_NUMBER    FROM  INFAREP_DEV11.OPB_TASK_INST GROUP  BY WORKFLOW_ID,INSTANCE_ID,TASK_ID))) WL,(SELECT WORKFLOW_ID,INSTANCE_ID, TASK_ID,INSTANCE_NAME, TASK_TYPE,VERSION_NUMBER FROM   INFAREP_DEV11.OPB_TASK_INST WHERE  ( WORKFLOW_ID,VERSION_NUMBER ) IN (SELECT WORKFLOW_ID,max(VERSION_NUMBER) FROM INFAREP_DEV11.OPB_TASK_INST  GROUP  BY WORKFLOW_ID)) SESS,    (SELECT SESSION_ID,MAPPING_ID,MAX(VERSION_NUMBER) AS VERSION_NUMBER    FROM   INFAREP_DEV11.OPB_SESSION        GROUP  BY SESSION_ID,MAPPING_ID) S,(SELECT MAPPING_NAME,IS_VISIBLE,MAPPING_ID,MAX(VERSION_NUMBER) FROM INFAREP_DEV11.OPB_MAPPING GROUP  BY MAPPING_NAME,IS_VISIBLE,MAPPING_ID) M
	WHERE  WF.IS_VISIBLE = 1 
	AND WF.SUBJECT_ID = F.SUBJ_ID      
	AND WF.TASK_ID = WL.WORKFLOW_ID     
	AND WF.TASK_TYPE = 71 
	AND ( WL.TASK_ID = SESS.WORKFLOW_ID  OR WL.WORKFLOW_ID = SESS.WORKFLOW_ID )    
	AND WF.IS_VISIBLE = 1 AND SESS.TASK_TYPE IN (  58,68 )   
	AND SESS.TASK_ID = S.SESSION_ID 
	AND S.MAPPING_ID = M.MAPPING_ID 
	AND M.IS_VISIBLE = 1 
	AND WF.TASK_NAME ='$workflow' 
	group by F.SUBJ_NAME,WF.TASK_NAME,SESS.INSTANCE_NAME,M.MAPPING_NAME;"
	QUERY_RES=`execSQL "$SQLSTRING"`
	rm sqloutput_1.csv
	touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sqloutput_1.csv
	echo $QUERY_RES>> sqloutput_1.csv
	rm sqloutput_2.csv
	touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sqloutput_2.csv
	sed -e 's/ /\n/g' sqloutput_1.csv>> sqloutput_2.csv
	#count_sess=$(grep -c 's_m_*' "sess_file.csv")
	#rm sess_file2.csv
	#touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sess_file2.csv
	#ses=$(grep 's_m_*' "sess_file.csv")
	#echo $ses>>sess_file2.csv
	#rm sess_file3.csv
	#touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sess_file3.csv
	#sed -e 's/ /\n/g' sess_file2.csv>> sess_file3.csv
	sess_file_name=/apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sqloutput_2.csv
	count_sess=`wc -l $sess_file_name`
	sess_count=`echo $count_sess | cut -d' ' -f1`
	#echo $sess_count>sqloutput_2.csv
	#looping for each session name 
for session in $(cat $sess_file_name)
	do
	#From the session name for a workflow find the connection name
	session_name=$session
	rm sqloutput2.csv
	rm sqloutput.csv
	#rm connection_details1.csv
	rm cnx_hardcoded.csv
	rm cnx_parametrised.csv
	rm paramfilename.csv
	sess_count=`expr $sess_count - 1`
	if [ $sess_count -lt 0 ]
		then
		break
	fi
	wf_name=$workflow
	#Find the connection name from a particular session
	#Temp files sqloutput2.csv,sqloutput.csv,cnx_hardcoded.csv,cnx_parametrised.csv
	SQLSTRING="set echo off;
	set head off;
	set feed off;
	select REF_OBJ from(select distinct B.ref_object_value AS REF_OBJ,RANK() OVER (PARTITION BY B.session_id ORDER BY B.VERSION_NUMBER DESC ) RNK from INFAREP_DEV11.OPB_SWIDGET_INST A,INFAREP_DEV11.OPB_SESS_CNX_REFS B,INFAREP_DEV11.OPB_TASK_INST C,INFAREP_DEV11.OPB_TASK D,INFAREP_DEV11.REP_ALL_TASKS E
	where A.widget_type in (1,11,6,2,14,84,5,4,55,45,80,3)and C.INSTANCE_NAME='$session_name'
	and B.REF_OBJECT_VALUE is not null AND A.sess_widg_inst_id =B.sess_widg_inst_id
	and A.session_id=B.session_id and A.session_id=C.task_id and C.workflow_id=D.task_ID and A.SESSION_ID=E.TASK_ID and E.SUBJECT_ID IN(SELECT SUBJECT_ID FROM INFAREP_DEV11.REP_ALL_TASKS E WHERE E.TASK_NAME='$wf_name' AND E.IS_ENABLED='1'))
	where RNK=1;"
	QUERY_RES=`execSQL "$SQLSTRING"`
	#QUERY_OP=`echo -e "$QUERY_RES" | grep '^$DB'`
	#QUERY_OP_App=`echo -e "$QUERY_RES" | grep '^$App'`
	#HTTP transformation--if connection is made then $App will cover cases else we need to figure out
	#SO WE grep on #https ,also check on the commenting
	touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sqloutput2.csv
	#echo $QUERY_OP>> sqloutput2.csv
	#echo $QUERY_OP_App>> sqloutput2.csv
	echo $QUERY_RES>> sqloutput2.csv
	touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sqloutput.csv
	sed -e 's/ /\n/g' sqloutput2.csv>> sqloutput.csv
	cnx_file=/apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sqloutput.csv
	#count1=$(grep -c '$DB*' "sqloutput.csv")
	#count2=$(grep -c '$App*' "sqloutput.csv")
	#count=$((count1 + count2))
	#Read all lines in sqloutput.csv and check if they have $ or not
	touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/cnx_hardcoded.csv
	touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/cnx_parametrised.csv
	for conn in $(cat $cnx_file)
	do
		conn_ch=$conn
		#check_conn=`echo -e "$conn_ch" | grep '^$'`
		check_conn=`echo $conn |cut -c 1`
		echo "Demo check started"
		echo "value for check conn is"
		echo $check_conn
		if [ "$check_conn" == "$" ]
		then
		#if [ -z "$check_conn" ]
		#then
		echo $conn>> cnx_parametrised.csv
		else
		echo "Going inside line and writing into hardcoded csv file"
		echo $conn
		echo $conn>> cnx_hardcoded.csv
		fi
	done
	#Find the parametre file names for a particular workflow and find the corresponding value
	#Temp file paramfilename.csv
	rm paramfilename.csv
	#rm fy.csv
	SQLSTRING="set echo off;
	set head off;
	set feed off;
	SELECT PRM_FILE_PATH FROM (SELECT 
      B.SUBJECT_AREA,
      B.TASK_NAME AS SES_WF_NAME,
      A.VERSION_NUMBER AS VR,
      cast(A.ATTR_VALUE as varchar(200)) AS PRM_FILE_PATH
FROM
       INFAREP_DEV11.OPB_TASK_ATTR A,
       INFAREP_DEV11.REP_ALL_TASKS B
WHERE
        A.ATTR_ID IN (1,4)
        AND A.TASK_ID = B.TASK_ID
        and LTRIM(RTRIM(A.ATTR_VALUE)) is not null
        AND  NOT REGEXP_LIKE(attr_value, '^[0-9]+$')
        AND B.TASK_NAME='$wf_name'
                             AND B.IS_ENABLED='1'                
                             AND SUBJECT_ID IN(SELECT SUBJECT_ID FROM INFAREP_DEV11.REP_ALL_TASKS A WHERE TASK_NAME='$wf_name' AND A.IS_ENABLED='1' )
ORDER BY 1,2,3 DESC) where rownum=1;"
	QUERY_OP2=`execSQL "$SQLSTRING"`
	param_file=`echo $QUERY_OP2 |cut -d' ' -f1`
	#handling the param file at session and workflow level
	if [ -z "$QUERY_OP2" ]
	then
	SQLSTRING="set echo off;
	set head off;
	set feed off;
	SELECT PRM_FILE_PATH FROM (SELECT 
      B.SUBJECT_AREA,
      B.TASK_NAME AS SES_WF_NAME,
      A.VERSION_NUMBER AS VR,
      cast(A.ATTR_VALUE as varchar(200)) AS PRM_FILE_PATH
FROM
       INFAREP_DEV11.OPB_TASK_ATTR A,
       INFAREP_DEV11.REP_ALL_TASKS B
WHERE
        A.ATTR_ID IN (1,4)
        AND A.TASK_ID = B.TASK_ID
        and LTRIM(RTRIM(A.ATTR_VALUE)) is not null
        AND  NOT REGEXP_LIKE(attr_value, '^[0-9]+$')
        AND B.TASK_NAME='$session_name'
                             AND B.IS_ENABLED='1'                
                             AND SUBJECT_ID IN(SELECT SUBJECT_ID FROM INFAREP_DEV11.REP_ALL_TASKS A WHERE TASK_NAME='$wf_name' AND A.IS_ENABLED='1' )
ORDER BY 1,2,3 DESC) where rownum=1;"
	QUERY_OP2=`execSQL "$SQLSTRING"`
	#param_file=`echo $QUERY_OP2 |cut -d'/' -f1`
	#TO ADD FOR apps and \ back slashes
	#QUERY_OP2=`echo -e "$QUERY_RES2"| grep '^$PM'`
	fi
	param_file_name=`echo $QUERY_OP2`
	touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/paramfilename.csv
	#touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/fy.csv
	echo $param_file_name>> paramfilename.csv
	#replace $PM -->replace with echo variable
	#sed -e "s/12345678/${replace}/g"
	replace=/apps/infa/PowerCenter8.6.1/server/infa_shared/
	#Unable to replace with variable value
	#sed -i 's/$PMRootDir/'$replace'/g' paramfilename.csv>> fy.csv
	sed -i "s%\$PMRootDir%$replace%g" paramfilename.csv
	sed -i 's/\\/\//g' paramfilename.csv
	sed -i 's/ /\n/g' paramfilename.csv
	#finding the connection value from param file and displaying the actual value
	#!/bin/bash
	#param_file_name_arg=`echo $param_file_name |cut -d'/' -f1`
	#param_file_firstarg=`echo $param_file_name_arg | cut -c 2-`
	#if [ "$param_file_firstarg" == "PMRootDir" ]
	#then
	#filename=`echo $param_file_name |cut -d'/' -f2,3,4`
	#filepath=/apps/infa/PowerCenter8.6.1/server/infa_shared/$filename
	#else
	#filepath=$param_file_name
	#fi
	#rm filepath1.csv
	#rm filepath.csv
	#touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/filepath1.csv
	#touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/filepath.csv
	#filepath1=`echo $QUERY_OP2`
	#echo $filepath1>> filepath1.csv
	#sed -e 's/\///g' filepath1.csv>> filepath.csv
	dm=/apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/paramfilename.csv
	for i in $(cat $dm)
	do
	filepath=$i
	dos2unix $filepath
	#done
	#fi
	#echo "checking for $word word."
	#Grep the word in the param file now
	#taking parametrised conn from the cnx_parametrised
	#adding for HTTP transformation
	pat1=http://
	pat2=https://
	rm http_file.csv
	touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/http_file.csv
	http_file_name=/apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/http_file.csv
	HTTP_OP=$(grep "$pat1" "$filepath")
	if [ -z "$HTTP_OP" ]
	then
	echo "Do nothing"
	else
	echo $HTTP_OP>>http_file.csv
	sed -i 's/ /\n/g' http_file.csv
	#sed -i 's/\\/\//g' paramfilename.csv
	fi
	HTTP_OP2=$(grep "$pat2" "$filepath")
	if [ -z "$HTTP_OP2" ]
	then
	echo "Do nothing"
	else
	echo $HTTP_OP2>>http_file.csv
	sed -i 's/ /\n/g' http_file.csv
	fi
	dos2unix $http_file_name
	for i in $(cat $http_file_name)
	do
	ch_http=$i
	check_hash=`echo $ch_http |cut -c 1`
	if [ "$check_hash" == "#" ]
	then
	echo "Commented value"
	else
	SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','Not required for HTTP','Not required for HTTP','$HTTP_OP','HTTP in session','Not required for HTTP','Not required for HTTP');"
	http_query=`execSQL1 "$SQLSTRING"`
	echo http_query
	fi
	done
	HOSTFILE=/apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/cnx_parametrised.csv
			for host in $(cat $HOSTFILE)
			#while [$count !=0]
			do
			#print $host
			word=$host
			#var_path=`echo $PMRootDir`
			#filepath=var_path/$filename
			#back slash convert to 
			#sed command to convert back to forward slash
			#and var_path will replace first $PMRootDir--informatica tool
			#filepath=/apps/infa/PowerCenter8.6.1/server/infa_shared/$filename
			if [[ -f $filepath ]] ; 
			then
			QUERY_RES3=$(grep -w "$word" "$filepath")
			#QUERY_OPcheck=`echo $QUERY_OP | cut -d' ' -f$count`
			#count=`expr $count - 1`
			#if [ $count -lt 0 ]
			#	then
			#	break
			Conn_detail=`echo $QUERY_RES3 | cut -d'=' -f2`
			#TODO
			#FOR ORACLE AND ODBC COnnections
			SQLSTRING="Select connection_name,host_name,CONNECTION_SUBTYPE
			from INFAREP_DEV11.V_IME_CONNECTION WHERE CONNECTION_NAME='$Conn_detail' AND 
			CONNECTION_SUBTYPE IN ('Oracle','ODBC') ;"
			C_Detailone=`execSQL "$SQLSTRING"`
			C_Detail2=`echo -e "$C_Detailone"| grep "$Conn_detail"`
			C_Detail=`echo $C_Detail2 | cut -d' ' -f2`
			Conn_SUBTYPE=`echo $C_Detail2 | cut -d' ' -f3`
			echo "value for cinn"
			echo "$Conn_SUBTYPE"
			touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sqloutput.csv
			#touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/connection_details.csv
			touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/connection_details1.csv
			#for_host=HOST
			#echo $QUERY_RES3>> sqloutput.csv
			#echo  $C_Detail>>connection_details.csv
			echo  $C_Detail>>sqloutput.csv
			#For other application connections
			SQLSTRING="Select connection_name,User_name,CONNECTION_SUBTYPE
			from INFAREP_DEV11.V_IME_CONNECTION 
			WHERE CONNECTION_NAME='$Conn_detail' AND
			CONNECTION_SUBTYPE IN ('Http Transformation','Salesforce Connection','FTP','Greenplum Connection','Web Services Consumer') ;"
			C_Detailone_APP=`execSQL "$SQLSTRING"`
			C_Detail2_APP=`echo -e "$C_Detailone_APP"| grep "$Conn_detail"`
			C_Detail_APP=`echo $C_Detail2_APP | cut -d' ' -f2`
			Conn_SUBTYPE2=`echo $C_Detail2_APP | cut -d' ' -f3,4,5`
			echo  $C_Detail_APP>>sqloutput.csv
			#Host_names1=`echo grep -A 50 $C_detail $File_host`
			#Host_names1=$(grep -A 50 "$C_Detail" "$File_host")
			#Host_names2=`echo -e "$Host_names1" | grep 'HOST'
			#Host_names2=`echo -e "$Host_names1"| grep "$for_host"``
			#Host_names2=$(grep "" "$File_host")

			#Host_names=`echo awk -F"HOST=" '{print $2}'|cut -d')' -f1`
			#Getting relational conn details from tnsoranames file
			if [ "$Conn_SUBTYPE" == "Oracle" ]
			then
			for_host=HOST
			ch='='
			Host_names1=$(grep -i -A 10 "$C_Detail" "$File_host")
			echo  $Host_names1>>sqloutput.csv
			Host_names2=`echo -e "$Host_names1"| grep "$for_host" |head -1`
			#Host_names3=`echo -e "$Host_names2"| grep "$ch"`
			echo  $Host_names2>>connection_details1.csv
			#echo  $Host_names3>>connection_details.csv
			fi
			if [ "$Conn_SUBTYPE" == "ODBC" ]
			then
			for_host=HOST
			ch='='
			Host_names1=$(grep -i -A 10 "$C_Detail" "$File_host")
			echo  $Host_names1>>sqloutput.csv
			Host_names2=`echo -e "$Host_names1"| grep "$for_host|head -1"`
			#Host_names3=`echo -e "$Host_names2"| grep "$ch"`
			echo  $Host_names2>>connection_details1.csv
			#echo  $Host_names3>>connection_details.csv
			fi
			if [ "$Conn_SUBTYPE" == "Oracle" ]
			then 
			SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_detail','$C_Detail','Not required since relational','$Conn_SUBTYPE','$Host_names2','$filepath');"
			Final_op=`execSQL1 "$SQLSTRING"`
			fi
			if [ "$Conn_SUBTYPE" == "ODBC" ]
			then 
			SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_detail','$C_Detail','Not required since relational','$Conn_SUBTYPE','$Host_names2','$filepath');"
			Final_op=`execSQL1 "$SQLSTRING"`
			fi
			if [ "$Conn_SUBTYPE2" == "Http Transformation" ]
			then 
			SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_detail','$C_Detail','$C_Detail_APP','$Conn_SUBTYPE2','Not required since it is application','$filepath');"
			Final_op=`execSQL1 "$SQLSTRING"`
			fi
			if [ "$Conn_SUBTYPE2" == "Greenplum Connection" ]
			then 
			SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_detail','$C_Detail','$C_Detail_APP','$Conn_SUBTYPE2','Not required since it is application','$filepath');"
			Final_op=`execSQL1 "$SQLSTRING"`
			fi
			if [ "$Conn_SUBTYPE2" == "Salesforce Connection" ]
			then 
			SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_detail','$C_Detail','$C_Detail_APP','$Conn_SUBTYPE2','Not required since it is application','$filepath');"
			Final_op=`execSQL1 "$SQLSTRING"`
			fi
			if [ "$Conn_SUBTYPE2" == "FTP" ]
			then 
			SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_detail','$C_Detail','$C_Detail_APP','$Conn_SUBTYPE2','Not required since it is application','$filepath');"
			Final_op=`execSQL1 "$SQLSTRING"`
			fi
			if [ "$Conn_SUBTYPE2" == "Web Services Consumer" ]
			then 
			SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_detail','$C_Detail','$C_Detail_APP','$Conn_SUBTYPE2','Not required since it is application','$filepath');"
			Final_op=`execSQL1 "$SQLSTRING"`
			fi
			#else
			#echo "The file $/apps/infa/PowerCenter8.6.1/server/infa_shared/filename does not exist."
			fi
			done
	done
			#Adding for hardcoded
			hardcodedfile=/apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/cnx_hardcoded.csv
			rm sqloutput_hardcoded.csv
			rm connection_details1_hardcoded.csv
				for hard_cnx in $(cat $hardcodedfile)
				do
					Conn_Detail_hardcoded=$hard_cnx
					echo "Hardcoded connection value"
					echo "$Conn_Detail_hardcoded"
					#FOR ORACLE AND ODBC COnnections
					SQLSTRING="Select connection_name,host_name,CONNECTION_SUBTYPE
					from INFAREP_DEV11.V_IME_CONNECTION WHERE CONNECTION_NAME='$Conn_Detail_hardcoded' AND 
					CONNECTION_SUBTYPE IN ('Oracle','ODBC') ;"
					C_Detailone_hd=`execSQL "$SQLSTRING"`
					C_Detail2_hd=`echo -e "$C_Detailone_hd"| grep "$Conn_Detail_hardcoded"`
					C_Detail_hd=`echo $C_Detail2_hd | cut -d' ' -f2`
					Conn_SUBTYPE_hd=`echo $C_Detail2_hd | cut -d' ' -f3`
					echo "value for cinn"
					echo "$Conn_SUBTYPE"
					touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/sqloutput_hardcoded.csv
					#touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/connection_details.csv
					touch /apps/infa/PowerCenter8.6.1/server/infa_shared/Scripts/connection_details1_hardcoded.csv
					#for_host=HOST
					#echo $QUERY_RES3>> sqloutput.csv
					#echo  $C_Detail>>connection_details.csv
					echo  $C_Detail_hd>>sqloutput_hardcoded.csv
					#For other application connections
					SQLSTRING="Select connection_name,User_name,CONNECTION_SUBTYPE
					from INFAREP_DEV11.V_IME_CONNECTION 
					WHERE CONNECTION_NAME='$Conn_Detail_hardcoded' AND
					CONNECTION_SUBTYPE IN ('Http Transformation','Salesforce Connection','FTP','Greenplum Connection','Web Services Consumer') ;"
					C_Detailone_APP_hd=`execSQL "$SQLSTRING"`
					C_Detail2_APP_hd=`echo -e "$C_Detailone_APP_hd"| grep "$Conn_Detail_hardcoded"`
					C_Detail_APP_hd=`echo $C_Detail2_APP_hd= | cut -d' ' -f2`
					Conn_SUBTYPE2_hd=`echo $C_Detail2_APP_hd= | cut -d' ' -f3,4,5`
					echo  $C_Detail_APP_hd>>sqloutput_hardcoded.csv
					#Host_names1=`echo grep -A 50 $C_detail $File_host`
					#Host_names1=$(grep -A 50 "$C_Detail" "$File_host")
					#Host_names2=`echo -e "$Host_names1" | grep 'HOST'
					#Host_names2=`echo -e "$Host_names1"| grep "$for_host"``
					#Host_names2=$(grep "" "$File_host")

					#Host_names=`echo awk -F"HOST=" '{print $2}'|cut -d')' -f1`
					#Getting relational conn details from tnsoranames file
					if [ "$Conn_SUBTYPE_hd" == "Oracle" ]
					then
					for_host=HOST
					ch='='
					Host_names1=$(grep -i -A 10 "$C_Detail_hd" "$File_host")
					echo  $Host_names1>>sqloutput_hardcoded.csv
					Host_names2=`echo -e "$Host_names1"| grep "$for_host"|head -1`
					#Host_names3=`echo -e "$Host_names2"| grep "$ch"`
					echo  $Host_names2>>connection_details1_hardcoded.csv
					#echo  $Host_names3>>connection_details.csv
					fi
					if [ "$Conn_SUBTYPE_hd" == "ODBC" ]
					then
					for_host=HOST
					ch='='
					Host_names1=$(grep -i -A 10 "$C_Detail_hd" "$File_host")
					echo  $Host_names1>>sqloutput_hardcoded.csv
					Host_names2=`echo -e "$Host_names1"| grep "$for_host"|head -1`
					#Host_names3=`echo -e "$Host_names2"| grep "$ch"`
					echo  $Host_names2>>connection_details1_hardcoded.csv
					#echo  $Host_names3>>connection_details.csv
					fi
					if [ "$Conn_SUBTYPE_hd" == "Oracle" ]
					then 
					SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_Detail_hardcoded','$C_Detail_hd','Not required since relational','$Conn_SUBTYPE_hd','$Host_names2','No param file required');"
					Final_op=`execSQL1 "$SQLSTRING"`
					fi
					if [ "$Conn_SUBTYPE_hd" == "ODBC" ]
					then 
					SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_Detail_hardcoded','$C_Detail_hd','Not required since relational','$Conn_SUBTYPE_hd','$Host_names2','No param file required');"
					Final_op=`execSQL1  "$SQLSTRING"`
					fi
					if [ "$Conn_SUBTYPE2_hd" == "Http Transformation" ]
					then 
					SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_Detail_hardcoded','$C_Detail_hd','$C_Detail_APP_hd','$Conn_SUBTYPE2_hd','Not required since it is application','$QUERY_OP2');"
					Final_op=`execSQL1 "$SQLSTRING"`
					fi
					if [ "$Conn_SUBTYPE2_hd" == "Greenplum Connection" ]
					then 
					SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_Detail_hardcoded','$C_Detail_hd','$C_Detail_APP_hd','$Conn_SUBTYPE2_hd','Not required since it is application','$QUERY_OP2');"
					Final_op=`execSQL1 "$SQLSTRING"`
					fi
					if [ "$Conn_SUBTYPE2_hd" == "Salesforce Connection" ]
					then 
					SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_Detail_hardcoded','$C_Detail_hd','$C_Detail_APP_hd','$Conn_SUBTYPE2_hd','Not required since it is application','$QUERY_OP2');"
					Final_op=`execSQL1 "$SQLSTRING"`
					fi
					if [ "$Conn_SUBTYPE2_hd" == "FTP" ]
					then 
					SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_Detail_hardcoded','$C_Detail_hd','$C_Detail_APP_hd','$Conn_SUBTYPE2_hd','Not required since it is application','$QUERY_OP2');"
					Final_op=`execSQL1 "$SQLSTRING"`
					fi
					if [ "$Conn_SUBTYPE2_hd" == "Web Services Consumer" ]
					then 
					SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$Conn_Detail_hardcoded','$C_Detail_hd','$C_Detail_APP_hd','$Conn_SUBTYPE2_hd','Not required since it is application','$QUERY_OP2');"
					Final_op=`execSQL1 "$SQLSTRING"`
					fi
				done
	done
done
#inserting the connection details into the endpoint table

#SQLSTRING="INSERT INTO STG_ENDPOINT values('$session_name','$wf_name','$QUERY_OPch','$Conn_detail','$C_Detail','$C_Detail_APP','$QUERY_OP2');"
#Final_op=`execSQL "$SQLSTRING"`

exit 0