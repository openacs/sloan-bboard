ad_page_contract {
    
    Marks a message as approved for display in a moderated forum.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-09-10
    @cvs-id $Id$

} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
}

ad_require_permission $forum_id bboard_moderate_forum

bboard_message_set_status -message_id $message_id -forum_id $forum_id \
	-status "approved"

db_1row sender_info {
    select sender from acs_messages where message_id = :message_id
}

# Should this check if it was already approved?
bboard_alert_one_mesg -message_id $message_id -forum_id $forum_id \
	-user_id $sender -creation_ip [ad_conn peeraddr]

ad_returnredirect "forum?forum_id=$forum_id"
