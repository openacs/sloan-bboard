<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="forum_short_name">      
      <querytext>
      
    select short_name as forum_name,
       acs_permission__permission_p(:forum_id, :user_id, 'admin') as admin_p,
       acs_permission__permission_p(:forum_id, :user_id, 'bboard_moderate_forum') 
         as moderate_p
      from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>


<fullquery name="message_info">      
      <querytext>
      
  select message_id, reply_to, title, 
      to_char(sent_date, 'Month DD, YYYY HH:MI am') as pretty_date, sender as user_id,
      mime_type, content, first_names||' '||last_name as full_name,
      acs_permission__permission_p(message_id, :user_id,
                                  'bboard_write_message') as write_p
    from acs_messages_all m, persons p
    where message_id = :message_id
      and person_id = sender

      </querytext>
</fullquery>

 
<fullquery name="message_replies">      
      <querytext>

    select m.message_id, m.reply_to, m.title, m.mime_type, m.content, 
           to_char(m.sent_date,'Month DD, YYYY HH:MI am') as pretty_date, m.sender as user_id,
           p.first_names||' '||p.last_name as full_name, 
           tree_level(m.tree_sortkey) - 1 as thread_depth, 
           acs_permission__permission_p(m.message_id, :user_id,
                                       'bboard_write_message') as write_p
      from acs_messages_all m, acs_messages m2, persons p, bboard_forum_message_map bfmm
     where m2.message_id = :message_id
       and m.message_id <> :message_id
       and bfmm.forum_id = :forum_id
       and m.tree_sortkey between m2.tree_sortkey and tree_right(m2.tree_sortkey) 
       and p.person_id = m.sender
       and m.message_id = bfmm.message_id 
     order by m.sent_date

      </querytext>
</fullquery>

 
</queryset>
