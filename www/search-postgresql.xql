<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="im_convert_query">      
      <querytext>
      
    select :query as query 

      </querytext>
</fullquery>

 
<fullquery name="bboard_search">      
      <querytext>
      
	select 10 as the_score, message_id,
            m.title, m.num_replies, to_char(m.sent_date,'MM/DD/YYYY') as sent_date,
	    p.first_names||' '||p.last_name as full_name
	  from bboard_messages_all m, persons p, bboard_forums f
          where content like '%' || :query || '%'
	    and m.sender = p.person_id
	    and m.forum_id = :forum_id
	    and f.forum_id = m.forum_id
	    and f.bboard_id = :package_id

      </querytext>
</fullquery>

</queryset>
