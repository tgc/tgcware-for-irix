#!/bin/sh
#

# Irix 6.2 and earlier doesnt have SVR4 style useradd/groupadd commands :(
PASSMGMT=""
[ -x /usr/sbin/passmgmt ] && PASSMGMT=/usr/sbin/passmgmt

# Default values
ssh_uid=199
ssh_gid=199

get_input()
{
    if [ ! "$1" = "" ]; then
	if [ ! "$2" = "" ]; then
	    # Assume we got both arguments
	    ssh_uid="$1"
	    ssh_gid="$2"
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
    echo "Create group with gid=$ssh_gid"
    echo "Create user with uid=$ssh_uid"
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

# Attempt to create a group & user for sshd
do_create()
{
    echo "Attempting to create sshd group (gid=$SSHID)"
    # Ugh :( doing this the hard way on stupid Irix :(
    echo "sshd:*:$ssh_gid:" >> /etc/group

    echo "Attempting to create sshd user (uid=$SSHID, gid=$SSHID)"
    if [ ! -z $PASSMGMT ]; then
	$PASSMGMT -a -u $ssh_uid -g $ssh_gid -c "sshd privsep" -h /var/empty/sshd -s /bin/false sshd
    else # crap, we need to do it the hard way :(
	echo "sshd:*:$ssh_uid:$ssh_gid:sshd privsep:/var/empty/sshd:/bin/false" >> /etc/passwd
    fi

    # Create homedir
    mkdir -p /var/empty/sshd
    chown ${ssh_uid}:${ssh_gid} /var/empty/sshd
}

# Make sure the sshd user doesn't show up on the clogin screen
# Checking is minimal...
#if [ -r /var/Cadmin/clogin.conf ]; then
#    s=`grep sshd /var/Cadmin/clogin.conf`
#    if [ -z "$s" ]; then
#	echo sshd:noshow >> /var/Cadmin/clogin.conf
#    else
#	/usr/bin/sed -e "s;${s};sshd:noshow;g" /var/Cadmin/clogin.conf > /tmp/clogin.conf.new
#	mv /tmp/clogin.conf.new /var/Cadmin/clogin.conf
#    fi
#fi

# main()
get_input $1 $2
do_verify

