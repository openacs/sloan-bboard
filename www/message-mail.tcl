ad_page_contract {
    
    A form for posting a new message to a bboard forum.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-datee 2000-08-29
    @cvs $Id$

    @param forum_id    The forum to post in
    @param category_id The default category for the message
    @param reply_to    The message this post should be in reply to

} {
    forum_id:integer,notnull,bboard_forum_id
    message_id:integer,notnull,acs_message_id
} -properties { 
    context_bar:onevalue
    forum_id:onevalue
    message:onerow
    message_id:onevalue
    new_message_id:onevalue
    sender_email:onevalue
}

ad_require_permission $forum_id bboard_create_message

db_1row forum_short_name {
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id
}

set user_id [ad_verify_and_get_user_id]

db_1row sender_email {
    select email as sender_email from parties
        where party_id = :user_id
}

set new_message_id [db_nextval acs_object_id_seq]

set context_bar \
	[list [list "forum?[export_url_vars forum_id]" $forum_name] \
              "Post"]

db_0or1row message_info {
    select reply_to, title, sent_date,
           mime_type, content, 
           first_names||' '||last_name as full_name
      from acs_messages_all m, persons p
      where message_id = :message_id
        and person_id = sender
} -column_array quote

ad_return_template "message-mail"
