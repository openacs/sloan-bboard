<?xml version="1.0"?>
<queryset>

<fullquery name="forum_info">      
      <querytext>
      
    select short_name as forum_name, charter as forum_charter
    from bboard_forums
    where forum_id = :forum_id

      </querytext>
</fullquery>

 
<fullquery name="forum_message_count">      
      <querytext>
      
    select count(*) as message_count
    from bboard_forum_message_map bfmm
    where bfmm.forum_id = :forum_id

      </querytext>
</fullquery>

 
</queryset>
