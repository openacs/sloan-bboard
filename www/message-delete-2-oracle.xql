<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="bboard_delete_threads">      
      <querytext>
      
	delete from bboard_forum_message_map bfm
	    where message_id in (select message_id
                                     from acs_messages m
                                     connect by prior message_id = reply_to
                                     start with message_id = :message_id)
                  and exists (select 1 from all_object_party_privilege_map
                                  where object_id = bfm.message_id
                                        and party_id in (:user_id, -1)
                                        and privilege = 'bboard_delete_message')

    
      </querytext>
</fullquery>

 
</queryset>
