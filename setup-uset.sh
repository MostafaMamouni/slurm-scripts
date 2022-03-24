#!/bin/bash


GREEN="\033[1;32m"
NOCOLOR="\033[0m"


if [ $1 == "-h" ]; then
		echo "usage: ./create_users_account username [--dacc defaultaccount cpuhours] [--acc account cpuhours] [--qos qos]"
		exit 0
fi


if [ $1 ]; then
	if ! id $1 > /dev/null 2>&1; then
		echo error: "\"$1\" user doesn't exit"
		exit 1
	fi
	if [[ "$1" == [^\-\-] ]]; then
		echo the first argument should be the username
		echo "usage: ./create_users_account username [--dacc defaultaccount cpuhours] [--acc account cpuhours] [--qos qos]"
		exit 1
	fi
	USER="$1"
fi

shift 1

while [ : ];do
	if [ "$1" == "--acc" ]; then
		if [ ! $2 ] || [[ "$2" == [^\-\-] ]]; then
			echo acc option requires an argument
			exit 1
		fi
		echo $3
		if [[ $3 =~ [0-9] ]]; then
			echo salam
			ACPUHOURS=$3
			shift 1
		fi
		argrexist=true
		ACCOUNT=$2
	elif [ "$1" == "--dacc" ]; then
		if [ ! $2 ] || [[ "$2" == [^\-\-] ]]; then
			echo dacc option requires an argument
			exit 1
		fi
		if [[ $3 =~ [0-9] ]]; then
			DACPUHOURS=$3
			shift 1
		fi
		argrexist=true
		DEFAULTACCOUNT="$2-account"
	elif [ "$1" == "--qos" ]; then
		if [ ! $2 ] || [[ "$2" == [^\-\-] ]]; then
			echo qos option requires an argument
			exit 1
		fi
		argrexist=true
		QOS=$2
	else
		break
	fi
	shift 2
done


if [ ! $argrexist ] ; then
	echo too few arguments
	echo "usage: ./create_users_account username [--dacc defaultaccount cpuhours] [--acc account cpuhours] [--qos qos]"
	exit 1
fi

if [ $ACCOUNT ]; then
	echo -e "${GREEN}"
	echo "sacctmgr add account $ACCOUNT"
	echo -e ${NOCOLOR}
#	sacctmgr add account $ACCOUNT
	echo -e ${GREEN}
	echo "sacctmgr add user $USER account=$ACCOUNT"
	echo -e ${NOCOLOR}
#	sacctmgr add user $USER account=$ACCOUNT
fi

if [ $DEFAULTACCOUNT ]; then
	echo -e "${GREEN}"
	echo "sacctmgr add account $DEFAULTACCOUNT"
	echo -e ${NOCOLOR}
#	sacctmgr add account $ACCOUNT
	echo -e ${GREEN}
	echo "sacctmgr add user $USER defaultaccount=$ACCOUNT"
	echo -e ${NOCOLOR}
#	sacctmgr add user $USER defaultaccount=$ACCOUNT
fi
if [ $QOS ]; then
	echo -e ${GREEN}
	echo "sacctmgr modify user $USER set qos=$QOS"
	echo -e ${NOCOLOR}
#	sacctmgr modify user $USER set qos=$4
fi

if [ $ACPUHOURS ]; then
	echo -e ${GREEN}
	echo "sbank deposit -c slurm_cluster -a $ACCOUNT -t $ACPUHOURS"
	echo -e ${NOCOLOR}
#	sbank deposit -c slurm_cluster -a $ACCOUNT -t $CPUHOURS
fi

if [ $DACPUHOURS ]; then
	echo -e ${GREEN}
	echo "sbank deposit -c slurm_cluster -a $DEFAULTACCOUNT -t $DACPUHOURS"
	echo -e ${NOCOLOR}
#	sbank deposit -c slurm_cluster -a $ACCOUNT -t $CPUHOURS
fi
