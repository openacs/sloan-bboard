ad_page_contract {
    
    Confirmation page for a new posting.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-datee 2000-08-29
    @cvs $Id$

    @param forum_id
    @param short_name
    @param content
    @param mime_type
} {
    message_id:integer,notnull
    forum_id:integer,notnull,bboard_forum_id
    category_id:integer,bboard_category_id
    title:notnull,trim
    content:allhtml,notnull,trim
    mime_type:notnull
    {reply_to:integer,acs_message_id ""}
    {subscribe_p:optional ""}
}

ad_require_permission $forum_id bboard_create_message

set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

db_transaction {

    bboard_message_new -message_id $message_id -reply_to $reply_to \
            -sender $user_id -title $title -mime_type $mime_type \
            -content $content -context_id $forum_id \
	    -creation_ip $creation_ip

    bboard_message_set_status \
            -message_id $message_id -forum_id $forum_id -status "unmoderated"

    if {![empty_string_p $category_id]} {
        bboard_message_add_category \
                -message_id $message_id -category_id $category_id
    }

    if ![empty_string_p $subscribe_p] {
	bboard_subscribe_thread -thread_id $message_id -subscriber_id $user_id
    }

    if ![string equal [bboard_forum_moderated_p $forum_id] "t"] {
	bboard_alert_one_mesg -message_id $message_id -forum_id $forum_id \
		-user_id $user_id -creation_ip $creation_ip
    }

    if [string equal [ad_parameter "UserPostsEditableP"] "t"] {
	db_exec_plsql grant {
	    begin
	    acs_permission.grant_permission(:message_id, :user_id, 'bboard_write_message');
	    end;
	}
    }

}

ad_returnredirect "forum?[export_url_vars forum_id]"
