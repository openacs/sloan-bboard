<?xml version="1.0"?>
<queryset>

<fullquery name="forum_info">      
      <querytext>
      
    select f.short_name as forum_name, f.moderated_p
        from bboard_forums f
        where f.forum_id = :forum_id

      </querytext>
</fullquery>

 
<fullquery name="category_info">      
      <querytext>
      
        select f.forum_id, f.short_name as forum_name, f.moderated_p
            from bboard_categories c, bboard_forums f
            where c.category_id = :category_id
                and c.forum_id = f.forum_id
    
      </querytext>
</fullquery>

 
<fullquery name="category_info">      
      <querytext>
        select short_name as category_name from bboard_categories
          where category_id = :category_id    
      </querytext>
</fullquery>

 
<fullquery name="messages_select_unmoderated">      
      <querytext>
      
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name
	  from bboard_messages_by_category, persons
	  where category_id = :category_id
	    and person_id = sender
	    and reply_to is null
	    and status = 'unmoderated'
    
      </querytext>
</fullquery>

 
<fullquery name="rejected_messages_select">      
      <querytext>
      
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name
	  from bboard_messages_by_category, persons
	  where category_id = :category_id
	    and person_id = sender
	    and reply_to is null
	    and status = 'rejected'
    
      </querytext>
</fullquery>

 
</queryset>
