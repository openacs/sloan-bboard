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
 

<fullquery name="messages_and_replies">      
      <querytext>

  select m.message_id, m.reply_to, m.title, m.sent_date, m.mime_type,
         to_char(m.sent_date, 'Month DD, YYYY HH:MI am') as pretty_date,
         m.content, p.first_names||' '||p.last_name as full_name, 
         p.person_id as user_id,
         tree_level(m.tree_sortkey) - 1 as thread_depth, 
      acs_permission__permission_p(m.message_id, :user_id,
                                  'bboard_write_message') as write_p
    from acs_messages_all m, persons p, acs_messages m2, bboard_forum_message_map bfmm
   where m2.message_id = :message_id
     and bfmm.forum_id = :forum_id
     and m.tree_sortkey between m2.tree_sortkey and tree_right(m2.tree_sortkey)
     and p.person_id = m.sender
     and m.message_id = bfmm.message_id 
   order by m.tree_sortkey

      </querytext>
</fullquery>

 
</queryset>
