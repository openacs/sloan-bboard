<?xml version="1.0"?>
<queryset>

<fullquery name="forum_info">      
      <querytext>
      
    select short_name as forum_name, charter, moderated_p from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
<fullquery name="allowed_target_forums">      
      <querytext>
      
    select forum_id, short_name
      from bboard_forums
      where not forum_id = :forum_id
        and exists (select 1 from all_object_party_privilege_map
                      where object_id = forum_id
                        and party_id in (:user_id, -1)
                        and privilege = 'admin')


      </querytext>
</fullquery>

 
</queryset>
