<?xml version="1.0"?>
<queryset>

<fullquery name="category_info">      
      <querytext>
      
    select f.short_name as forum_name, f.forum_id, c.short_name
      from bboard_forums f, bboard_categories c
      where c.category_id = :category_id
        and f.forum_id = c.forum_id

      </querytext>
</fullquery>

 
</queryset>
