<?xml version="1.0"?>
<queryset>

<fullquery name="bboard_forum_get.forum_get">      
      <querytext>
      
        select * from bboard_forums where forum_id = :forum_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_get.category_get">      
      <querytext>
      
        select * from bboard_categories where category_id = :category_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_new.message_new_revision">      
      <querytext>
      
        select live_revision as revision_id
            from cr_items
            where item_id = :message_id
        for update
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_set.message_revision">      
      <querytext>
      
        select live_revision as revision_id from cr_items
            where item_id = :message_id
            for update
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_get.message_get">      
      <querytext>
      
        select * from acs_messages_all where message_id = :message_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_unsubscribe_forum.forum_unsubscribe">      
      <querytext>
      
        delete from bboard_forum_subscribers
            where forum_id = :forum_id
                and subscriber_id = :subscriber_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_unsubscribe_category.category_unsubscribe">      
      <querytext>
      
        delete from bboard_category_subscribers
            where category_id = :category_id
                and subscriber_id = :subscriber_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_unsubscribe_thread.thread_unsubscribe">      
      <querytext>
      
        delete from bboard_thread_subscribers
            where thread_id = :thread_id
                and subscriber_id = :subscriber_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_subscribed_p.check_category_subscribed">      
      <querytext>
      
        select count(*) as subscribed_p from bboard_category_subscribers
            where category_id = :category_id
                and subscriber_id = :user_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_subscribed_p.check_category_forums_subscribed">      
      <querytext>
      
		select count(*) as subscribed_p from bboard_forum_subscribers
     	            where subscriber_id = :user_id
		        and forum_id in (select bc.forum_id
		                            from bboard_categories bc
  		                            where bc.category_id = 
                                                  :category_id)
	    
      </querytext>
</fullquery>

 
<fullquery name="bboard_forum_subscribed_p.check_forum_subscribed">      
      <querytext>
      
        select count(*) as subscribed_p 
            from bboard_forum_subscribers
            where forum_id = :forum_id
                and subscriber_id = :user_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_subscribed_p.check_message_cats_subscribed">      
      <querytext>
      
		select count(*) as subscribed_p 
		from bboard_category_subscribers
		where subscriber_id = :user_id
		      and category_id in (select bcmm.category_id
		                          from bboard_category_message_map bcmm
		                          where bcmm.message_id = :message_id)

	    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_subscribed_p.check_message_forums_subscribed">      
      <querytext>
      
		    select count(*) as subscribed_p 
		    from bboard_forum_subscribers
		    where subscriber_id = :user_id
		          and forum_id in (select bfmm.forum_id
   		                           from bboard_forum_message_map bfmm
		                           where bfmm.message_id = :message_id)
		
      </querytext>
</fullquery>

 
<fullquery name="bboard_forum_moderated_p.forum_moderated_p">      
      <querytext>
      
	select moderated_p
  	  from bboard_forums
	  where forum_id = :forum_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_check_and_register_mime_type.check_mime_type">      
      <querytext>
      
	select mime_type
	    from cr_mime_types
	    where mime_type = :type
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_check_and_register_mime_type.insert_mime">      
      <querytext>
      
		insert into cr_mime_types (mime_type)
		values (:type)
	    
      </querytext>
</fullquery>

 
<fullquery name="bboard_alert_message.forum_info">      
      <querytext>
      
	select short_name as forum_name
	    from bboard_forums
	    where forum_id = :forum_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_alert_one_mesg.bboard_mesg_info">      
      <querytext>
      
	select reply_to, sender, title, mime_type, content, email,
               first_names||' '||last_name as full_name
            from acs_messages_all, persons, parties
            where message_id = :message_id
                  and person_id = sender
	          and party_id = person_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_alert_message.forum_info">      
      <querytext>
      
	select short_name as forum_name
	    from bboard_forums
	    where forum_id = :forum_id
    
      </querytext>
</fullquery>

 
</queryset>
