<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="im_convert_query">      
      <querytext>
      
    select bboard_im_convert(:query) as query from dual

      </querytext>
</fullquery>

 
<fullquery name="bboard_search">      
      <querytext>
      
	select score(10) as the_score, message_id,
            m.title, m.num_replies, to_char(m.sent_date,'MM/DD/YYYY') as sent_date,
	    p.first_names||' '||p.last_name as full_name
	  from bboard_messages_all m, persons p, bboard_forums f
	  where contains(content, :query, 10) > 0
	    and m.sender = p.person_id
	    and m.forum_id = :forum_id
	    and f.forum_id = m.forum_id
	    and f.bboard_id = :package_id
	  order by score(10) desc
    
      </querytext>
</fullquery>

 
</queryset>
