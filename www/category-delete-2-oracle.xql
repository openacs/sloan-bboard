<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_category">      
      <querytext>
      
    begin
        bboard_category.delete (:category_id);
    end;

      </querytext>
</fullquery>

 
</queryset>
