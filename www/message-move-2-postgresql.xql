<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="update_bboard_contexts">      
      <querytext>

	update acs_objects
	    set context_id = :dest_forum_id
	    where context_id = :forum_id
              and object_type = 'acs_message'
              and object_id in 
                  (select m.message_id
                     from acs_messages m, acs_messages m2
                    where m2.message_id = :message_id
                      and m.tree_sortkey between m2.tree_sortkey and tree_right(m2.tree_sortkey)) 
    
      </querytext>
</fullquery>

 
<fullquery name="move_bboard_messages">      
      <querytext>

        update bboard_forum_message_map 
            set forum_id = :dest_forum_id
            where forum_id = :forum_id
              and message_id in 
                  (select m.message_id
                   from acs_messages m, acs_messages m2
                   where m2.message_id = :message_id
                     and m.tree_sortkey between m2.tree_sortkey and tree_right(m2.tree_sortkey))
    
      </querytext>
</fullquery>

 
</queryset>
