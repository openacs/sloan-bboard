<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="grant">      
      <querytext>

	    select acs_permission__grant_permission(:message_id, :user_id, 'bboard_write_message');
	
      </querytext>
</fullquery>

 
</queryset>
