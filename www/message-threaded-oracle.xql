<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="forum_short_name">      
      <querytext>
      
    select short_name as forum_name,
       acs_permission.permission_p(:forum_id, :user_id, 'admin') as admin_p,
       acs_permission.permission_p(:forum_id, :user_id, 'bboard_moderate_forum') 
         as moderate_p
      from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
<fullquery name="messages_and_replies">      
      <querytext>
      
  select m.message_id, m.reply_to, m.title, m.sent_date, m.mime_type,
         to_char(m.sent_date, 'Month DD, YYYY HH:Mi am') as pretty_date,
         m.content, p.first_names||' '||p.last_name as full_name, 
         p.person_id as user_id,
         mt.depth - 1 as thread_depth,
      acs_permission.permission_p(m.message_id, :user_id,
                                  'bboard_write_message') as write_p
    from acs_messages_all m, persons p, 
      (select message_id, level as depth, rownum as seqnum
         from acs_messages im
         connect by prior message_id = reply_to
         start with message_id = :message_id) mt
    where p.person_id = m.sender
      and m.message_id = mt.message_id
      and m.message_id in (select bfmm.message_id 
                               from bboard_forum_message_map bfmm
                               where bfmm.forum_id = :forum_id)
      order by seqnum

      </querytext>
</fullquery>

 
</queryset>
