<?xml version="1.0"?>
<queryset>

<fullquery name="forum_short_name_id">      
      <querytext>
      
    select f.short_name as forum_name, f.forum_id
        from bboard_forums f, bboard_categories c
        where c.category_id = :category_id
          and c.forum_id = f.forum_id

      </querytext>
</fullquery>

 
<fullquery name="category_short_name">      
      <querytext>
      
    select short_name as category_name
        from bboard_categories
        where category_id = :category_id

      </querytext>
</fullquery>

 
<fullquery name="category_message_count">      
      <querytext>
      
    select count(*) as message_count
        from bboard_category_message_map
        where category_id = :category_id

      </querytext>
</fullquery>

 
</queryset>
