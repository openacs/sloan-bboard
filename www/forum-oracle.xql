<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="forum_info">      
      <querytext>
      
    select short_name as forum_name, moderated_p,
       acs_permission.permission_p(:forum_id, :user_id, 'admin') as admin_p,
       acs_permission.permission_p(:forum_id, :user_id, 'bboard_create_category') 
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
	       to_char(last_reply_date,'MM/DD/YY hh12:Mi am') as last_updated
          from bboard_messages_all b, persons
          where forum_id = :forum_id
	    and sent_date > case when :last_n_days = 0 then '1976-01-01' else to_char(sysdate - :last_n_days) end
	    and person_id = sender
            and reply_to is null
	order by sent_date desc
    
      </querytext>
</fullquery>

 
<fullquery name="categories_select">      
      <querytext>
      
	select c.category_id, c.short_name,
             count(m.message_id) as message_count
	  from bboard_categories c,
	       (select c.category_id, c.message_id
	          from bboard_category_message_map c,
	               bboard_forum_message_map f
	          where c.message_id = f.message_id
                    and f.forum_id = :forum_id) m
	  where c.forum_id = :forum_id
            and m.category_id(+) = c.category_id
	    and (m.message_id is null 
                or m.message_id in (select f.message_id
                                     from bboard_forum_message_map f
                                     where f.forum_id = :forum_id))
	  group by c.category_id, short_name
    
      </querytext>
</fullquery>

 
<fullquery name="messages_select_approved">      
      <querytext>
      
	select message_id, title, num_replies,
               first_names||' '||last_name as full_name,
	       to_char(last_reply_date,'MM/DD/YY hh12:Mi am') as last_updated
          from bboard_messages_all b, persons
          where forum_id = :forum_id
	    and sent_date > case when :last_n_days = 0 then '1976-01-01' else to_char(sysdate - :last_n_days) end
	    and person_id = sender
            and reply_to is null
	    and status = 'approved'
	order by sent_date desc
    
      </querytext>
</fullquery>

 
<fullquery name="categories_select_approved">      
      <querytext>
      
	select c.category_id, c.short_name,
             count(m.message_id) as message_count
	  from bboard_categories c,
	       (select c.category_id, c.message_id
	          from bboard_category_message_map c,
	               bboard_forum_message_map f
	          where c.message_id = f.message_id
                    and f.status = 'approved'
                    and f.forum_id = :forum_id) m
	  where c.forum_id = :forum_id
            and m.category_id(+) = c.category_id
	    and (m.message_id is null 
                or m.message_id in (select f.message_id
                                     from bboard_forum_message_map f
                                     where f.forum_id = :forum_id))
	  group by c.category_id, short_name
    
      </querytext>
</fullquery>

 
<fullquery name="unapproved_none">      
      <querytext>
      
	select 1 from dual where 1 = 0
    
      </querytext>
</fullquery>

 
<fullquery name="rejected_none">      
      <querytext>
      
	select 1 from dual where 1 = 0
    
      </querytext>
</fullquery>

 
</queryset>
