<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_category">      
      <querytext>
        select bboard_category__delete (:category_id);
      </querytext>
</fullquery>

 
</queryset>
