<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="forward_queue">      
      <querytext>

            select acs_message__send (
                :new_message_id,
                :email,
                :new_message_id,
                current_timestamp
            );
    
      </querytext>
</fullquery>

 
</queryset>
