<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="update_bboard_contexts">      
      <querytext>
      
	update acs_objects
	    set context_id = :dest_forum_id
	    where context_id = :forum_id
	          and object_type = 'acs_message'
                  and object_id in (select message_id
                                        from acs_messages m
                                        connect by prior message_id = reply_to
                                        start with message_id = :message_id) 
    
      </querytext>
</fullquery>

 
<fullquery name="move_bboard_messages">      
      <querytext>
      
        update bboard_forum_message_map 
            set forum_id = :dest_forum_id
            where forum_id = :forum_id
                  and message_id in (select message_id
                                         from acs_messages m
                                         connect by prior message_id = reply_to
                                         start with message_id = :message_id) 
    
      </querytext>
</fullquery>

 
</queryset>
