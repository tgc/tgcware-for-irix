#!/bin/sh
#

# Irix 6.2 and earlier doesnt have SVR4 style useradd/groupadd commands :(
PASSMGMT=""
[ -x /usr/sbin/passmgmt ] && PASSMGMT=/usr/sbin/passmgmt

# Default values
ntp_uid=198
ntp_gid=198

get_input()
{
    if [ ! "$1" = "" ]; then
	if [ ! "$2" = "" ]; then
	    # Assume we got both arguments
	    ntp_uid="$1"
	    ntp_gid="$2"
	else
	    echo "You must supply a group id"
	    exit 1
	fi
    else
	echo "You must supply a userid and groupid"
	exit 1
    fi
}

do_verify()
{
    # Ask user to confirm input
    echo "Create group with gid=$ntp_gid"
    echo "Create user with uid=$ntp_uid"
    echo "Confirm (y/n):\c" 
    read input
    if [ "$input" = "y" ]; then
	echo
	do_create
    else
	echo "User/group creation aborted!"
	exit 1
    fi
}

# Attempt to create a group & user for ntp
do_create()
{
    echo "Attempting to create _ntp group (gid=$ntp_gid)"
    # Ugh :( doing this the hard way on stupid Irix :(
    echo "_ntp:*:$ntp_gid:" >> /etc/group

    echo "Attempting to create _ntp user (uid=$ntp_uid, gid=$ntp_gid)"
    if [ ! -z $PASSMGMT ]; then
	$PASSMGMT -a -u $ntp_uid -g $ntp_gid -c "OpenNTP daemon" -h /var/empty/ntpd -s /bin/false _ntp
    else # crap, we need to do it the hard way :(
	echo "_ntp:*:$ntp_uid:$ntp_gid:OpenNTP daemon:/var/empty/ntpd:/bin/false" >> /etc/passwd
    fi

    # Create homedir
    #mkdir -p /var/empty/ntpd
    #chown 0 /var/empty/ntpd
    #chgrp 0 /var/empty/ntpd
}

# main()
get_input $1 $2
do_verify

