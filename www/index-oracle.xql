<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="forums_select">      
      <querytext>
      
    select forum_id, short_name, moderated_p, charter 
      from bboard_forums f
      where bboard_id = :package_id
        and acs_permission.permission_p(forum_id,:user_id,'bboard_read_forum') = 't'
    order by short_name

      </querytext>
</fullquery>

 
</queryset>
