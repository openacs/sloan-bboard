<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="forum_info">      
      <querytext>
      
    select short_name as forum_name, moderated_p,
       acs_permission__permission_p(:forum_id, :user_id, 'admin') as admin_p,
       acs_permission__permission_p(:forum_id, :user_id, 'bboard_create_category') 
          as category_create_p
      from bboard_forums
     where forum_id = :forum_id
        and bboard_id= :package_id

      </querytext>
</fullquery>


<fullquery name="messages_select">      
      <querytext>
      
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name,
	       to_char(last_reply_date,'MM/DD/YY hh12:MI am') as last_updated
          from bboard_messages_all b, persons
          where forum_id = :forum_id
            and age(sent_date) < case when :last_n_days = 0 
                                 then interval '99 years'
                                 else interval '$last_n_days days'
                                 end
	    and person_id = sender
            and reply_to is null
	order by sent_date desc
    
      </querytext>
</fullquery>

 
<fullquery name="categories_select">      
      <querytext>
    
        select short_name, count(message_id) as message_count, category_id
        from bboard_forum_message_map f join
             (bboard_categories c left outer join bboard_category_message_map m using (category_id))
             using (message_id)
        where f.forum_id = :forum_id
        group by category_id, short_name
        order by category_id;
  
      </querytext>
</fullquery>

 
<fullquery name="messages_select_approved">      
      <querytext>
      
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name,
	       to_char(last_reply_date,'MM/DD/YY hh12:MI am') as last_updated
          from bboard_messages_all b, persons
          where forum_id = :forum_id
            and age(sent_date) < case when :last_n_days = 0 
                                 then interval '99 years'
                                 else interval '$last_n_days days'
                                 end
	    and person_id = sender
            and reply_to is null
	    and status = 'approved'
	order by sent_date desc
    
      </querytext>
</fullquery>

 
<fullquery name="categories_select_approved">      
      <querytext>

        select short_name, count(message_id) as message_count, category_id
        from bboard_forum_message_map f join
             (bboard_categories c left outer join bboard_category_message_map m using (category_id))
             using (message_id)
        where f.forum_id = :forum_id
          and f.status = 'approved'
        group by category_id, short_name
        order by category_id;
    
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
