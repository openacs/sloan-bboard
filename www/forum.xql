<?xml version="1.0"?>
<queryset>

<fullquery name="uncategorized_count">      
      <querytext>
      
	select count(*) as uncategorized_count
            from bboard_forum_message_map msg
	    where forum_id = :forum_id
              and not exists (select 1
                              from bboard_category_message_map cat
                              where msg.message_id = cat.message_id)
    
      </querytext>
</fullquery>

 
<fullquery name="uncategorized_approved_count">      
      <querytext>
      
	select count(*) as uncategorized_count
            from bboard_forum_message_map msg
	    where forum_id = :forum_id
              and status = 'approved'
              and not exists (select 1
                              from bboard_category_message_map cat
                              where msg.message_id = cat.message_id)
    
      </querytext>
</fullquery>

 
<fullquery name="messages_select_unmoderated">      
      <querytext>
      
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name
	  from bboard_messages_all, persons
	  where forum_id = :forum_id
	    and person_id = sender
	    and reply_to is null
	    and status = 'unmoderated'

      </querytext>
</fullquery>

 
<fullquery name="rejected_messages_select">      
      <querytext>
      
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name
	  from bboard_messages_all, persons
	  where forum_id = :forum_id
	    and person_id = sender
	    and reply_to is null
	    and status = 'rejected'
    
      </querytext>
</fullquery>

 
</queryset>
