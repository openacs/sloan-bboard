<?xml version="1.0"?>
<queryset>

<fullquery name="message_info">      
      <querytext>
      
    select message_id, reply_to, title, mime_type, content
        from acs_messages_all m
        where message_id = :message_id

      </querytext>
</fullquery>

 
<fullquery name="first_category">      
      <querytext>
      
    select min(category_id) as category_id from bboard_category_message_map
        where message_id = :message_id
        group by message_id

      </querytext>
</fullquery>

 
<fullquery name="forum_short_name">      
      <querytext>
      
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
<fullquery name="quote_info">      
      <querytext>
      
    select m.reply_to, m.title, m.sent_date,
           m.mime_type, m.content, 
           p.first_names||' '||p.last_name as full_name
      from acs_messages_all m, persons p
      where message_id = :reply_to
        and person_id = sender

      </querytext>
</fullquery>

 
<fullquery name="category_list">      
      <querytext>
      
    select c.category_id, c.short_name
      from bboard_categories c
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
</queryset>
