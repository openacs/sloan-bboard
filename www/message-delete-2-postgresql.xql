<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="bboard_delete_threads">      
      <querytext>

	delete from bboard_forum_message_map
        where message_id in
          (select m.message_id
           from acs_messages m, acs_messages m2
           where m2.message_id = :message_id
             and m.tree_sortkey between m2.tree_sortkey and tree_right(m2.tree_sortkey))
          and exists (select 1 from all_object_party_privilege_map
                      where object_id = message_id
                        and party_id = :user_id
                        and privilege = 'bboard_delete_message')

      </querytext>
</fullquery>

 
</queryset>
