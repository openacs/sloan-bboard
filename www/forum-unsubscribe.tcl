ad_page_contract {

    Unsubscribe the current user from a given forum.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-10-28
    @cvs-id $Id$

} {
    forum_id:integer,notnull,bboard_forum_id
    {return_url ""}
    {sub_page ""}
}

catch {
    bboard_unsubscribe_forum \
	-forum_id $forum_id -subscriber_id [ad_verify_and_get_user_id]
}

if {[empty_string_p $return_url]} {
    if [empty_string_p $sub_page] {
        ad_returnredirect "forum?forum_id=$forum_id"
    } else {
        ad_returnredirect "subscriptions"
    }
} else {
    ad_returnredirect $return_url
}
