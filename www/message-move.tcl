ad_page_contract {
    
    Confirmation screem for moving a message to another forum.

    @author Anukul Kapoor <akk@arsdigita.com>
    @creation-date 2001-02-20
    @cvs-id $Id$

} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
    {replies ""}
} -properties {
    message_id:onevalue
    forum_id:onevalue
    title:onevalue
    sender_name:onevalue
    content:onevalue
    msg_mime_type:onevalue
    forums:multirow
    form_date:onevalue
}

ad_require_permission $message_id admin

set user_id [ad_conn user_id]

db_1row message_info {
    select p.first_names ||' '|| p.last_name as sender_name, b.title,
           b.mime_type as msg_mime_type, b.content
      from bboard_messages_all b, persons p
      where message_id = :message_id
            and b.sender = p.person_id
}


db_multirow forums allowed_target_forums {
    select forum_id, short_name
      from bboard_forums
      where not forum_id = :forum_id
        and exists (select 1 from acs_object_party_privilege_map
                      where object_id = forum_id
                        and party_id in (:user_id, -1)
                        and privilege = 'admin')

}

set form_data [export_form_vars message_id forum_id]

ad_return_template