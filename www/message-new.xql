<?xml version="1.0"?>
<queryset>

<fullquery name="forum_short_name">      
      <querytext>
      
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
<fullquery name="quote_info">      
      <querytext>
      
    select reply_to, title, sent_date,
           mime_type, content, 
           first_names||' '||last_name as full_name
      from acs_messages_all m, persons p
      where message_id = :reply_to
        and person_id = sender

      </querytext>
</fullquery>

 
<fullquery name="quote_first_category">      
      <querytext>
      
    select min(category_id) as category_id from bboard_category_message_map
      where message_id = :reply_to
      group by message_id

      </querytext>
</fullquery>

 
<fullquery name="category_list">      
      <querytext>
      
    select category_id, short_name
      from bboard_categories
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
</queryset>
