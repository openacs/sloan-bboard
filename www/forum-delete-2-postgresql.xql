<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="categories_delete">      
      <querytext>
	declare
	    category_val record;
        begin
	    for category_val in select distinct category_id
                     from bboard_categories c
                    where c.forum_id = :forum_id 
            loop
 
 	        delete from acs_permissions 
                   where object_id = category_val.category_id;

                perform bboard_category__delete(category_val.category_id);
            end loop;
	    return 0;
        end;    
      </querytext>
</fullquery>

 
<fullquery name="forum_delete">      
      <querytext>
	select bboard_forum__delete (:forum_id);
      </querytext>
</fullquery>

 
</queryset>
