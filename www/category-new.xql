<?xml version="1.0"?>
<queryset>

<fullquery name="forum_short_name">      
      <querytext>
      
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
</queryset>
