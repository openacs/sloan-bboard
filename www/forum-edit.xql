<?xml version="1.0"?>
<queryset>

<fullquery name="forum_info">      
      <querytext>
      
    select short_name, charter, moderated_p from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
</queryset>
