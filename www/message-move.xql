<?xml version="1.0"?>
<queryset>

<fullquery name="message_info">      
      <querytext>
      
    select p.first_names ||' '|| p.last_name as sender_name, b.title,
           b.mime_type as msg_mime_type, b.content
      from bboard_messages_all b, persons p
      where message_id = :message_id
            and b.sender = p.person_id

      </querytext>
</fullquery>

 
<fullquery name="allowed_target_forums">      
      <querytext>
      
    select forum_id, short_name
      from bboard_forums
      where not forum_id = :forum_id
        and exists (select 1 from all_object_party_privilege_map
                      where object_id = forum_id
                        and party_id = :user_id
                        and privilege = 'admin')


      </querytext>
</fullquery>

 
</queryset>
