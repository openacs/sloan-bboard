<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="categories_delete">      
      <querytext>
      
	declare
	    cursor category_cursor is
	        select distinct category_id
                    from bboard_categories c
                    where c.forum_id = :forum_id;
        begin
	    for category_val in category_cursor loop
 
 	        delete from acs_permissions 
                   where object_id = category_val.category_id;

                bboard_category.delete(category_val.category_id);
            end loop;
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="forum_delete">      
      <querytext>
      
	begin
	    bboard_forum.delete (:forum_id);
	end;
    
      </querytext>
</fullquery>

 
</queryset>
