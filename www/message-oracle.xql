<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="forum_short_name">      
      <querytext>
      
    select short_name as forum_name,
       acs_permission.permission_p(:forum_id, :user_id, 'admin') as admin_p,
       acs_permission.permission_p(:forum_id, :user_id, 'bboard_moderate_forum') 
         as moderate_p,
      forum_type
      from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

<fullquery name="message_info">      
      <querytext>
      
  select message_id, reply_to, title, bboard_message.new_p(message_id, :user_id) as new_p,
      to_char(sent_date, 'Month DD, YYYY HH:Mi am') as pretty_date, sender as user_id,
      mime_type, content, first_names||' '||last_name as full_name,
      acs_permission.permission_p(message_id, :user_id,
                                  'bboard_write_message') as write_p
    from acs_messages_all m, persons p
    where message_id = :message_id
      and person_id = sender

      </querytext>
</fullquery>

<fullquery name="reply_message_info">      
      <querytext>
      
  select message_id, reply_to, title, bboard_message.new_p(message_id, :user_id) as new_p,
      to_char(sent_date, 'Month DD, YYYY HH:Mi am') as pretty_date, sender as user_id,
      mime_type, content, first_names||' '||last_name as full_name,
      acs_permission.permission_p(message_id, :user_id,
                                  'bboard_write_message') as write_p
    from acs_messages_all m, persons p
    where message_id = :reply_to
      and person_id = sender

      </querytext>
</fullquery>

 
<fullquery name="message_replies">      
      <querytext>
      
    select m.message_id, m.reply_to, m.title, m.mime_type, m.content, bboard_message.new_p(m.message_id, :user_id) as new_p,
         to_char(m.sent_date,'Month DD, YYYY HH:Mi am') as pretty_date, sender as user_id,
         p.first_names||' '||p.last_name as full_name, 
         mt.depth - 1 as thread_depth, rownum,
         acs_permission.permission_p(m.message_id, :user_id,
                                  'bboard_write_message') as write_p
        from acs_messages_all m, persons p,
            (select message_id, level as depth, rownum as seqnum
                from acs_messages
                connect by prior message_id = reply_to
                start with message_id = :message_id) mt
        where m.message_id <> :message_id
            and p.person_id = m.sender
            and m.message_id = mt.message_id
            and m.message_id in (select bfmm.message_id 
                                     from bboard_forum_message_map bfmm
                                     where bfmm.forum_id = :forum_id)
    order by mt.seqnum

      </querytext>
</fullquery>

 
</queryset>
