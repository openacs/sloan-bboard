<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_attachments">      
      <querytext>
      
	select object_id as file_id, cr.title, ci.name
            from acs_objects ao, cr_items ci, cr_revisions cr
            where object_id = ci.item_id and
                  live_revision = revision_id and
	          object_type = 'content_item' and
                  context_id = :id
    
      </querytext>
</fullquery>

 
</queryset>
