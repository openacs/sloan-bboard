<?xml version="1.0"?>
<queryset>

<fullquery name="get_forum_subs">      
      <querytext>
      
    select bfs.forum_id, short_name as name
      from bboard_forum_subscribers bfs, bboard_forums bf
      where bfs.forum_id = bf.forum_id
            and bfs.subscriber_id = :user_id
      order by forum_id asc

      </querytext>
</fullquery>

 
<fullquery name="get_category_subs">      
      <querytext>
      
    select bcs.category_id, short_name as name, forum_id
      from bboard_category_subscribers bcs, bboard_categories bc
      where bcs.category_id = bc.category_id
            and bcs.subscriber_id = :user_id
      order by category_id asc

      </querytext>
</fullquery>

 
<fullquery name="get_thread_subs">      
      <querytext>
      
    select thread_id, title as name, forum_id
      from bboard_thread_subscribers bts, bboard_messages_all bma
      where bts.thread_id = bma.message_id
            and bts.subscriber_id = :user_id
      order by thread_id asc

      </querytext>
</fullquery>

 
</queryset>
