<?xml version="1.0"?>
<queryset>

<fullquery name="user_info">      
      <querytext>
      
    select first_names||' '||last_name as full_name
      from persons
      where person_id = :user_id

      </querytext>
</fullquery>

 
<fullquery name="forum_info">      
      <querytext>
      
    select short_name as forum_name, moderated_p from bboard_forums
      where forum_id = :forum_id

      </querytext>
</fullquery>

 
<fullquery name="messages_select">      
      <querytext>
      
        select title, num_replies, message_id,
               first_names||' '||last_name as full_name
        from bboard_messages_all, persons
        where sender = :user_id
              and forum_id = :forum_id
              and person_id = sender
    
      </querytext>
</fullquery>

 
<fullquery name="messages_select">      
      <querytext>
      
        select title, num_replies, message_id,
               first_names||' '||last_name as full_name
        from bboard_messages_all, persons
        where sender = :user_id
              and forum_id = :forum_id
              and person_id = sender
    
      </querytext>
</fullquery>

 
<fullquery name="alt_forums_select">      
      <querytext>
      
    select forum_id, short_name
    from bboard_forums bf
    where not forum_id = :forum_id
          and bboard_id = :package_id
          and exists (select 1
                      from bboard_messages_all bma
                      where sender = :user_id 
                            and bma.forum_id = bf.forum_id)
          and exists (select 1 from all_object_party_privilege_map
                          where object_id = bf.forum_id
                            and party_id = :current_user_id
                            and privilege = 'bboard_read_forum')

      </querytext>
</fullquery>

 
</queryset>
