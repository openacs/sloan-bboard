ad_page_contract {

    Displays a single message, and all replies.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-09-01
    @cvs-id $Id$
} {
    message_id:integer,notnull,acs_message_id
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    message_create_p:onevalue
    context_bar:onevalue
    forum_name:onevalue
    forum_id:onevalue
    message:onerow
    replies:multirow
    subscribed_p:onevalue
    moderate_p:onevalue
}

ad_require_permission $message_id bboard_read_forum

set user_id [ad_verify_and_get_user_id]

if [string equal [bboard_message_subscribed_p -direct $user_id $message_id] "t"] {
    set subscribed_p 1
} else {
    set subscribed_p 0
}

db_1row forum_short_name {
    select short_name as forum_name,
       acs_permission.permission_p(:forum_id, :user_id, 'admin') as admin_p,
       acs_permission.permission_p(:forum_id, :user_id, 'bboard_moderate_forum') 
         as moderate_p,
      forum_type
      from bboard_forums
      where forum_id = :forum_id
}

db_1row message_info {
  select message_id, reply_to, title, 
      to_char(sent_date, 'Month DD, YYYY HH:Mi am') as pretty_date, sender as user_id,
      mime_type, content, first_names||' '||last_name as full_name,
      acs_permission.permission_p(message_id, :user_id,
                                  'bboard_write_message') as write_p
    from acs_messages_all m, persons p
    where message_id = :message_id
      and person_id = sender
} -column_array message

set context_bar [list [list "forum?[export_url_vars forum_id]" $forum_name] \
		      "One Message"]
                   
db_multirow replies message_replies {
    select m.message_id, m.reply_to, m.title, m.mime_type, m.content, 
         to_char(m.sent_date,'Month DD, YYYY HH:Mi am') as pretty_date, sender as user_id,
         p.first_names||' '||p.last_name as full_name, 
         mt.depth - 1 as thread_depth, rownum,
         acs_permission.permission_p(m.message_id, :user_id,
                                  'bboard_write_message') as write_p
        from acs_messages_all m, persons p,
            (select message_id, level as depth, rownum as seqnum
                from acs_messages im
                connect by prior message_id = reply_to
                start with message_id = :message_id) mt
        where m.message_id <> :message_id
            and p.person_id = m.sender
            and m.message_id = mt.message_id
            and m.message_id in (select bfmm.message_id 
                                     from bboard_forum_message_map bfmm
                                     where bfmm.forum_id = :forum_id)
order by mt.seqnum
}

# How does a user want this presented
set presentation [bboard_user_view_pref]

# Should we allow replies to replies?
if {$forum_type == "thread"} {
    set replies_p 1
} else {
    set replies_p 0
}

ad_return_template
