<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="bboard_forum_p.bboard_forum_p">      
      <querytext>
            select bboard_forum__forum_p(:forum_id);
      </querytext>
</fullquery>

 
<fullquery name="bboard_forum_new.create_forum">      
      <querytext>
            select bboard_forum__new (
                :forum_id,
                :short_name,
                :charter,
                :moderated_p,
                :bboard_id,
                :context_id,
                now(),
                :creation_user,
                :creation_ip,
                'bboard_forum'
            );
      </querytext>
</fullquery>

 
<fullquery name="bboard_forum_set.update_forum">      
      <querytext>
         select bboard_forum__set_attrs (
                :forum_id,
                :short_name,
                :charter,
                :moderated_p,
                :bboard_id
            );
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_p.bboard_category_p">      
      <querytext>
        select bboard_category__category_p(:category_id);
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_new.create_category">      
      <querytext>
	    select bboard_category__new (
	        :category_id,
	        :short_name,
	        :description,
	        :forum_id,
                null,
                now(),
                null,
                null,
                'bboard_category'
	    );
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_set.update_category">      
      <querytext>
            select bboard_category__set_attrs (
                :category_id,
                :short_name,
                :description,
                :forum_id
            );
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_new.message_new">      
      <querytext>
            select bboard_message__new (
                :message_id,
                :reply_to,
                :sent_date,
                :sender,
                null,          -- rfc822_id
                :title,
                :mime_type,
                null,          -- text
	        null,          -- data
                :context_id,
                now(),
                :creation_user,
                :creation_ip,
                'acs_message'
            );
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_new.message_new_set_blob">      
      <querytext>

        update cr_revisions
            set content = :content
            where revision_id = :revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_set.message_set_attr">      
      <querytext>

          select bboard_message__set_attrs (
                :message_id,
                :reply_to,
                :sent_date,
                :sender,
                :title,
                :mime_type,
                :context_id
            );
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_set.message_set_content">      
      <querytext>
	update cr_revisions
 	set content = '$content'
        where revision_id = :revision_id
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_clear_categories.bboard_message_clear_categories">      
      <querytext>

          select bboard_message__clear_categories ( :message_id );
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_add_category.bboard_message_add_category">      
      <querytext>

        select bboard_message__add_category (
                :message_id,
                :category_id
            );
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_remove_category.bboard_message_remove_category">      
      <querytext>

            select bboard_message__remove_category (
                :message_id,
                :category_id
            );
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_set_status.bboard_message_set_status">      
      <querytext>

            select bboard_message__set_status (
                :message_id,
                :forum_id,
                :status
            );
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_subscribe_forum.forum_subscribe">      
      <querytext>

            select bboard_forum__subscribe (
                :forum_id,
                :subscriber_id
            );
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_subscribe_category.category_subscribe">      
      <querytext>

            select bboard_category__subscribe (
                :category_id,
                :subscriber_id
            );
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_subscribe_thread.thread_subscribe">      
      <querytext>

            select bboard_message__subscribe (
                :thread_id,
                :subscriber_id
            );
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_subscribed_p.check_message_subscribed">      
      <querytext>

	select count(*) as subscribed_p
         from bboard_thread_subscribers bs, acs_messages m, acs_messages m2
	 where bs.subscriber_id = :user_id
	   and bs.thread_id = m.message_id 
           and m2.message_id = :message_id
           and m.tree_sortkey between m2.tree_sortkey and tree_right(m2.tree_sortkey)

      </querytext>
</fullquery>

 
<fullquery name="bboard_message_forum.bboard_forum_containing_message">      
      <querytext>
      
	select bboard_forum__forum_containing_message(:message_id) as forum_id
	  
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_url.first_ancestor">      
      <querytext>
      
	select acs_message__first_ancestor(:message_id) as ancestor_id 
            
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_image.insert_image">      
      <querytext>

                select acs_message__new_image (
                    :message_id,
                    :file_id,
                    :short_filename,
                    :title,
                    null,       -- description
                    :mime_type,
                    null,       -- data
                    :width,
                    :height,
                    now(),
                    :user_id,
                    :creation_ip,
                    't',        -- is_live
                    'file'
                );
        
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_image.get_revision">      
      <querytext>
      
        select content_item__get_latest_revision(:file_id) as revision_id
        
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_image.set_content_size">      
      <querytext>
	update cr_revisions
 	set content = :filename,
	    content_length = :size
        where revision_id = :revision_id
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_file.insert_file">      
      <querytext>
                select acs_message__new_file (
                    :message_id,
                    :file_id,
                    :short_filename,
                    :title,
                    null,           -- description
                    :mime_type,
                    null,           -- content
                    now(),
                    :user_id,
                    :creation_ip,
                    't',             -- is_live
                    'file'
                );
        
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_file.get_revision">      
      <querytext>
      
        select content_item__get_latest_revision(:file_id) as revision_id
        
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_file.set_content_size">      
      <querytext>
	update cr_revisions
 	set content = :filename,
	    content_length = :size
        where revision_id = :revision_id
      </querytext>
</fullquery>

 
<fullquery name="bboard_delete_attachment.is_file_image">      
      <querytext>
      
	select image_id
            from images
            where image_id = content_item__get_latest_revision(:file_id)
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_delete_attachment.delete_image">      
      <querytext>

	    select acs_message__delete_image(:file_id);
	
      </querytext>
</fullquery>

 
<fullquery name="bboard_delete_attachment.delete_file">      
      <querytext>

   	    select acs_message__delete_file(:file_id);
	
      </querytext>
</fullquery>

 
 
<fullquery name="bboard_garbage_collect.clear_revision_references">      
      <querytext>

update cr_items
   set latest_revision=null, live_revision=null
 where item_id in 
       (select object_id as message_id
          from acs_objects
         where object_type = 'acs_message'
           and object_id not in (select message_id 
                                 from bboard_forum_message_map));
    
      </querytext>
</fullquery>

<fullquery name="bboard_garbage_collect.bboard_alert_clean">      
      <querytext>

declare
    message_rec record;
begin
    for message_rec in
        select o.object_id as message_id
          from acs_objects o
         where o.object_type = 'acs_message'
            and not exists (select 1
                            from bboard_forum_message_map bfmm, acs_objects o2
                            where o2.object_id = bfmm.message_id and
                              o.tree_sortkey between o2.tree_sortkey and tree_right(o2.tree_sortkey))
    loop
        perform bboard_message__remove(message_rec.message_id);
    end loop;

    return 0;
end;
    
      </querytext>
</fullquery>


<partialquery name="bboard_schedule_sends.thread_subscribers">      
  <querytext>
        select s.subscriber_id as recipient_id, s.thread_id as grouping_id,
               now() as wait_until
          from bboard_thread_subscribers s, acs_messages m,
            (select tree_ancestor_keys(acs_message_get_tree_sortkey(:message_id)) as tree_sortkey) parents
         where s.thread_id = m.message_id
           and m.tree_sortkey = parents.tree_sortkey
           and exists (select 1
                       from all_object_party_privilege_map map
                       where map.object_id = :message_id and
                           map.party_id = s.subscriber_id and
                           privilege = 'bboard_read_message')

  </querytext>
</partialquery>
 
<partialquery name="bboard_schedule_sends.category_subscribers">      
  <querytext>
  
	select s.subscriber_id as recipient_id, s.category_id as grouping_id,
	       now() as wait_until
	  from bboard_category_subscribers s, bboard_category_message_map m
	  where m.message_id = :message_id
	    and s.category_id = m.category_id
            and exists (select 1
                        from all_object_party_privilege_map map
                        where map.object_id = :message_id and
                            map.party_id = s.subscriber_id and
                            privilege = 'bboard_read_message')

  </querytext>
</partialquery>


<partialquery name="bboard_schedule_sends.forum_subscribers">      
  <querytext>
        select s.subscriber_id as recipient_id, s.forum_id as grouping_id,
               now() as wait_until
            from bboard_forum_subscribers s, bboard_forum_message_map m
            where m.message_id = :message_id
              and s.forum_id = m.forum_id
              and exists (select 1
                          from all_object_party_privilege_map map
                          where map.object_id = :message_id and
                              map.party_id = s.subscriber_id and
                              privilege = 'bboard_read_message')
  </querytext>
</partialquery>

</queryset>
