<?xml version="1.0"?>
<queryset>

<fullquery name="message_info">      
      <querytext>
      
        select m.message_id, m.reply_to, m.title,
               m.sent_date, m.mime_type, m.content, 
               p.first_names ||' '||p.last_name as full_name
            from acs_messages_all m, persons p, bboard_forum_message_map f
            where m.message_id = :message_id
                and f.message_id = :message_id
                and f.forum_id = :forum_id
                and p.person_id = m.sender
    
      </querytext>
</fullquery>

 
<fullquery name="forum_short_name">      
      <querytext>
      
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
</queryset>
