ad_page_contract {

    Unsubscribe the current user from a given mesage thread.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-10-28
    @cvs-id $Id$

} {
    forum_id:integer,notnull,bboard_forum_id
    message_id:integer,notnull,acs_message_id
    {sub_page ""}
}

catch {
    bboard_unsubscribe_thread \
	-thread_id $message_id -subscriber_id [ad_verify_and_get_user_id]
}

if [empty_string_p $sub_page] {
    ad_returnredirect "[bboard_message_page]?forum_id=$forum_id&message_id=$message_id"
} else {
    ad_returnredirect "subscriptions"
}
