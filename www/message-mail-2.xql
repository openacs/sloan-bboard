<?xml version="1.0"?>
<queryset>

<fullquery name="user_email">      
      <querytext>
      
        select email as user_email from parties where party_id = :user_id
    
      </querytext>
</fullquery>

 
<fullquery name="message_info">      
      <querytext>
      
        select reply_to, sender, title, mime_type, content
            from acs_messages_all
            where message_id = :message_id
    
      </querytext>
</fullquery>

 
</queryset>
