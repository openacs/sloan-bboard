<?xml version="1.0"?>
<queryset>

<fullquery name="thread_title">      
      <querytext>
      
    select title
      from acs_messages_all
      where message_id = :message_id

      </querytext>
</fullquery>

 
</queryset>
