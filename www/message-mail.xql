<?xml version="1.0"?>
<queryset>

<fullquery name="forum_short_name">      
      <querytext>
      
    select short_name as forum_name from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
<fullquery name="sender_email">      
      <querytext>
      
    select email as sender_email from parties
        where party_id = :user_id

      </querytext>
</fullquery>

 
<fullquery name="message_info">      
      <querytext>
      
    select reply_to, title, sent_date,
           mime_type, content, 
           first_names||' '||last_name as full_name
      from acs_messages_all m, persons p
      where message_id = :message_id
        and person_id = sender

      </querytext>
</fullquery>

 
</queryset>
