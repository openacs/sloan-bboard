<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="forward_queue">      
      <querytext>
      
        begin
            acs_message.send (
                message_id => :new_message_id,
                to_address => :email,
                grouping_id => :new_message_id,
                wait_until => sysdate
            );
        end;
    
      </querytext>
</fullquery>

 
</queryset>
