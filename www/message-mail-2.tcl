ad_page_contract {
    
    Confirmation page for a new posting.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-datee 2000-08-29
    @cvs $Id$

    @param forum_id        The forum ID to return to
    @param message_id      The message ID to copy and return to
    @param new_message_id  Debounce for the new message creation
    @param email           Recipient of email
} {
    forum_id:integer,notnull,bboard_forum_id
    message_id:integer,notnull,acs_message_id
    new_message_id:integer,notnull
    email:notnull,trim
}

ad_require_permission $forum_id bboard_create_message

set user_id [ad_verify_and_get_user_id]
set creation_ip [ad_conn peeraddr]

db_transaction {

    db_1row user_email {
        select email as user_email from parties where party_id = :user_id
    }

    db_1row message_info {
        select reply_to, sender, title, mime_type, content
            from acs_messages_all
            where message_id = :message_id
    }

    bboard_message_new -message_id $new_message_id \
            -sender $user_id -title "\[Fwd by $user_email\] $title" \
            -mime_type $mime_type -content $content -context_id $message_id

    if ![string equal [bboard_forum_moderated_p $forum_id] "t"] {
	bboard_schedule_sends -message_id $message_id
    }

    # queue it up to be sent
    db_exec_plsql forward_queue {
        begin
            acs_message.send (
                message_id => :new_message_id,
                to_address => :email,
                grouping_id => :new_message_id,
                wait_until => sysdate
            );
        end;
    }

}

ad_returnredirect "[bboard_message_url $message_id $forum_id]"
