<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="grant">      
      <querytext>
      
	    begin
	    acs_permission.grant_permission(:message_id, :user_id, 'bboard_write_message');
	    end;
	
      </querytext>
</fullquery>

 
</queryset>
