<?xml version="1.0"?>
<queryset>

<fullquery name="update_bboard_contexts">      
      <querytext>
      
	update acs_objects
	    set context_id = :dest_forum_id
	    where context_id = :forum_id
	          and (object_type = 'acs_message' or
                       object_type = 'bboard_category')
    
      </querytext>
</fullquery>

 
<fullquery name="move_bboard_messages">      
      <querytext>
      
        update bboard_forum_message_map 
            set forum_id = :dest_forum_id
            where forum_id = :forum_id
    
      </querytext>
</fullquery>

 
<fullquery name="move_bboard_categories">      
      <querytext>
      
	update bboard_categories
	    set forum_id = :dest_forum_id
            where forum_id = :forum_id
    
      </querytext>
</fullquery>

 
</queryset>
