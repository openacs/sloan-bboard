<?xml version="1.0"?>
<queryset>

<fullquery name="messages_delete">      
      <querytext>

        delete from bboard_forum_message_map 
         where forum_id = :forum_id

      </querytext>

</fullquery>


<fullquery name="permissions_delete">      
      <querytext>
      
	delete from acs_permissions 
  	  where object_id = :forum_id

      </querytext>
</fullquery>

 
</queryset>
