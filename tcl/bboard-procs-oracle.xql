<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="bboard_forum_p.bboard_forum_p">      
      <querytext>
      
        begin
            :1 := bboard_forum.forum_p(:forum_id);
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_forum_new.create_forum">      
      <querytext>
      
        begin
            :1 := bboard_forum.new (
                forum_id => :forum_id,
                short_name => :short_name,
                charter => :charter,
                moderated_p => :moderated_p,
                bboard_id => :bboard_id,
                context_id => :context_id,
                creation_user => :creation_user,
                creation_ip => :creation_ip
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_forum_set.update_forum">      
      <querytext>
      
        begin
            bboard_forum.set_attrs (
                forum_id => :forum_id,
                short_name => :short_name,
                charter => :charter,
                moderated_p => :moderated_p,
                bboard_id => :bboard_id
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_p.bboard_category_p">      
      <querytext>
      
        begin
            :1 := bboard_category.category_p(:category_id);
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_new.create_category">      
      <querytext>
      
	begin
	    :1 := bboard_category.new (
	        category_id => :category_id,
	        short_name => :short_name,
	        description => :description,
	        forum_id => :forum_id
	    );
	end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_category_set.update_category">      
      <querytext>
      
        begin
            bboard_category.set_attrs (
                category_id => :category_id,
                short_name => :short_name,
                description => :description,
                forum_id => :forum_id
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_new.message_new">      
      <querytext>
      
        begin
            :1 := bboard_message.new (
                message_id => :message_id,
                reply_to => :reply_to,
                sent_date => :sent_date,
                sender => :sender,
                title => :title,
                mime_type => :mime_type,
                data => empty_blob(),
                context_id => :context_id,
                creation_user => :creation_user,
                creation_ip => :creation_ip
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_new.message_new_set_blob">      
      <querytext>
      
        update cr_revisions
            set content = empty_blob()
            where revision_id = :revision_id
        returning content into :1
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_set.message_set_attr">      
      <querytext>
      
        begin
            bboard_message.set_attrs (
                message_id => :message_id,
                reply_to => :reply_to,
                sent_date => :sent_date,
                sender => :sender,
                title => :title,
                mime_type => :mime_type,
                context_id => :context_id
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_set.message_set_content">      
      <querytext>
      
        update cr_revisions
            set content = empty_blob()
            where revision_id = :revision_id
        returning content into :1
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_clear_categories.bboard_message_clear_categories">      
      <querytext>
      
        begin
            bboard_message.clear_categories ( :message_id );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_add_category.bboard_message_add_category">      
      <querytext>
      
        begin
            bboard_message.add_category (
                message_id => :message_id,
                category_id => :category_id
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_remove_category.bboard_message_remove_category">      
      <querytext>
      
        begin
            bboard_message.remove_category (
                message_id => :message_id,
                category_id => :category_id
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_set_status.bboard_message_set_status">      
      <querytext>
      
        begin
            bboard_message.set_status (
                message_id => :message_id,
                forum_id => :forum_id,
                status => :status
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_subscribe_forum.forum_subscribe">      
      <querytext>
      
        begin
            bboard_forum.subscribe (
                forum_id => :forum_id,
                subscriber_id => :subscriber_id
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_subscribe_category.category_subscribe">      
      <querytext>
      
        begin
            bboard_category.subscribe (
                category_id => :category_id,
                subscriber_id => :subscriber_id
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_subscribe_thread.thread_subscribe">      
      <querytext>
      
        begin
            bboard_message.subscribe (
                thread_id => :thread_id,
                subscriber_id => :subscriber_id
            );
        end;
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_subscribed_p.check_message_subscribed">      
      <querytext>
      
	select count(*) as subscribed_p from bboard_thread_subscribers
	where subscriber_id = :user_id
	      and thread_id in (select message_id
	                        from acs_messages b
	                        connect by b.message_id = prior b.reply_to 
	                        start with message_id = :message_id)

    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_forum.bboard_forum_containing_message">      
      <querytext>
      
	select bboard_forum.forum_containing_message(:message_id) as forum_id
	  from dual
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_message_url.first_ancestor">      
      <querytext>
      
	select acs_message.first_ancestor(:message_id) as ancestor_id 
            from dual
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_image.insert_image">      
      <querytext>
      
             begin
                :1 := acs_message.new_image (
                    message_id     => :message_id,
                    image_id       => :file_id,
                    file_name      => :short_filename,
                    title          => :title,
                    mime_type      => :mime_type,
                    content        => empty_blob(),
                    width          => :width,
                    height         => :height,
                    creation_user  => :user_id,
                    creation_ip    => :creation_ip,
                    is_live        => 't'
            );
            end;
        
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_image.get_revision">      
      <querytext>
      
        select content_item.get_latest_revision(:file_id) as revision_id
        from dual
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_image.set_content_size">      
      <querytext>
      
	update cr_revisions
 	set filename = :filename,
	    content_length = :size
	where revision_id = :revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_file.insert_file">      
      <querytext>
      
            begin
                :1 := acs_message.new_file (
                    message_id     => :message_id,
                    file_id        => :file_id,
                    file_name      => :short_filename,
                    title          => :title,
                    mime_type      => :mime_type,
                    content        => empty_blob(),
                    creation_user  => :user_id,
                    creation_ip    => :creation_ip,
                    is_live        => 't'
            );
            end;
        
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_file.get_revision">      
      <querytext>
      
        select content_item.get_latest_revision(:file_id) as revision_id
        from dual
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_attach_file.set_content_size">      
      <querytext>
      
	update cr_revisions
 	set filename = :filename,
	    content_length = :size
	where revision_id = :revision_id
      
      </querytext>
</fullquery>

 
<fullquery name="bboard_delete_attachment.is_file_image">      
      <querytext>
      
	select image_id
            from images
            where image_id = content_item.get_latest_revision(:file_id)
    
      </querytext>
</fullquery>

 
<fullquery name="bboard_delete_attachment.delete_image">      
      <querytext>
      
	    begin
	        acs_message.delete_image(:file_id);
	    end;
	
      </querytext>
</fullquery>

 
<fullquery name="bboard_delete_attachment.delete_file">      
      <querytext>
      
	    begin
   	        acs_message.delete_file(:file_id);
	    end;
	
      </querytext>
</fullquery>

 
<fullquery name="bboard_garbage_collect.clear_revision_references">      
      <querytext>

update cr_items 
   set latest_revision=null, live_revision=null
 where item_id = -1;

      </querytext>
</fullquery>

<fullquery name="bboard_garbage_collect.bboard_alert_clean">      
      <querytext>
      
	declare
	    cursor alerts_cursor is
 
 	    select object_id
 	         from acs_objects
 	         where object_id in (select object_id
                                       from acs_objects
                                      where object_type = 'acs_message'
                  	              start with context_id in (select forum_id
                                                                  from bboard_forums)
 	                              connect by prior object_id = context_id)
 	               and object_id not in (select message_id
 	                                       from bboard_forum_message_map)
             order by object_id desc;
	begin
  	    for alert_val in alerts_cursor loop
	        bboard_message.remove(alert_val.object_id);
	    end loop;
	end;
    
      </querytext>
</fullquery>

<partialquery name="bboard_schedule_sends.thread_subscribers">      
  <querytext>
        select subscriber_id as recipient_id, thread_id as grouping_id,
               sysdate as wait_until
          from bboard_thread_subscribers s
          where s.thread_id in (select message_id 
                                  from acs_messages
                                 start with message_id = :message_id
                               connect by message_id = prior reply_to)
            and s.subscriber_id in (select party_id 
                                      from all_object_party_privilege_map 
                                     where object_id = :message_id 
                                       and privilege = 'bboard_read_message')
  </querytext>
</partialquery>
 
<partialquery name="bboard_schedule_sends.category_subscribers">      
  <querytext>
	select s.subscriber_id as recipient_id, s.category_id as grouping_id,
	       sysdate as wait_until
	  from bboard_category_subscribers s, bboard_category_message_map m
	  where m.message_id = :message_id
	    and s.category_id = m.category_id
            and s.subscriber_id in (select party_id 
                                      from acs_object_party_privilege_map 
                                     where object_id = :message_id 
                                       and privilege = 'bboard_read_message')
  </querytext>
</partialquery>


<partialquery name="bboard_schedule_sends.forum_subscribers">      
  <querytext>
        select s.subscriber_id as recipient_id, s.forum_id as grouping_id,
               sysdate as wait_until
            from bboard_forum_subscribers s, bboard_forum_message_map m
            where m.message_id = :message_id
              and s.forum_id = m.forum_id
              and s.subscriber_id in (select party_id 
                                        from acs_object_party_privilege_map 
                                       where object_id = :message_id 
                                         and privilege = 'bboard_read_message')
  </querytext>
</partialquery>
</queryset>

