<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="categories_select_none">      
      <querytext>
      
    select 1  where 0 = 1

      </querytext>
</fullquery>

 
<fullquery name="messages_select_by_cat">      
      <querytext>
      
    select message_id, title, num_replies,
         first_names||' '||last_name as full_name,
  	 to_char(last_reply_date,'MM/DD/YY hh12:MI am') as last_updated
    from bboard_messages_by_category b, persons
    where person_id = sender
        and reply_to is null
        and forum_id = :forum_id
  	$category_sql
        $moderated_sql
    order by sent_date desc
	
      </querytext>
</fullquery>

 
<fullquery name="unapproved_none">      
      <querytext>
      
	select 1  where 1 = 0
    
      </querytext>
</fullquery>

 
<fullquery name="rejected_none">      
      <querytext>
      
	select 1  where 1 = 0
    
      </querytext>
</fullquery>

 
</queryset>
