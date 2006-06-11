# preinstall.sh script for tgc_postfix

postfix_uid=@@POSTFIX_UID@@
postfix_gid=@@POSTFIX_GID@@
postfix_user=@@POSTFIX_USER@@
postfix_group=@@POSTFIX_GROUP@@
maildrop_group=@@MAILDROP_GROUP@@
maildrop_gid=@@MAILDROP_GID@@
postfix_queue_dir=@@POSTFIX_QUEUE_DIR@@

# Irix 6.2 and earlier doesnt have SVR4 style useradd/groupadd commands :(
PASSMGMT=""
[ -x /usr/sbin/passmgmt ] && PASSMGMT=/usr/sbin/passmgmt

echo "Attempting to create $postfix_group group (gid=$postfix_gid): \c"
if [ -z "`egrep "$postfix_group.*$postfix_gid.*" /etc/group`" ]; then
    echo "$postfix_group:*:$postfix_gid:" >> /etc/group
    [ $? -eq 0 ] && echo "done" || echo "failed"
else
    echo "already there"
fi
echo "Attempting to create $maildrop_group group (gid=$maildrop_gid): \c"
if [ -z "`egrep "$maildrop_group.*$maildrop_gid.*" /etc/group`" ]; then
    echo "$maildrop_group:*:$maildrop_gid:" >> /etc/group
    [ $? -eq 0 ] && echo "done" || echo "failed"
else
    echo "already there"
fi

echo "Attempting to create $postfix_user user (uid=$postfix_uid, gid=$postfix_gid): \c"
if [ -z "`egrep "$postfix_user.*$postfix_gid.*" /etc/passwd`" ]; then
    if [ ! -z $PASSMGMT ]; then
	$PASSMGMT -a -u $postfix_uid -g $postfix_gid -c "Postfix MTA" -h ${postfix_queue_dir} -s /bin/false $postfix_user
    else # Do it manually
	echo "$postfix_user:*:$postfix_uid:$postfix_gid:Postfix MTA:${postfix_queue_dir}:/bin/false" >> /etc/passwd
    fi
    [ $? -eq 0 ] && echo "done" || echo "failed"
else
    echo "already there"
fi

suffix=$$
echo "Attempting to add $postfix_user user to the mail group: \c"
if [ -z "`egrep "mail:.*$postfix_user.*" /etc/group`" ]; then
    mail_members=`/bin/grep "^mail" /etc/group | cut -d: -f4`
    if [ -n "$mail_members" ]; then
	postfix_user=",$postfix_user"
    fi
    /bin/sed -e "/^mail/s/$/$postfix_user/" /etc/group > /etc/group.$suffix
    retval=$?
    mv /etc/group.$suffix /etc/group
    [ $? -eq 0 ] && [ $retval -eq 0 ] && echo "done" || echo "failed"
else
    echo "already there"
fi
