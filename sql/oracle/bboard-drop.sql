--
-- packages/message/sql/bboard-drop.sql
--
-- @author jmp@arsdigita.com
-- @creation-date 2000-08-31
-- @cvs-id $Id$
--

-- This drop script destroys all messages that belong to forums.
-- It should handle any permission changes that have been done since
-- install by removing any permissions having to do with the standard
-- bboard permissions.

-- We need to get rid of things that might be referring to
-- bboard objects that would prevent removal.  This includes:
-- email-a-friend droppings
-- attachments (files and images)

-- if something else is pointing at one of our messages, this script
-- will fail and removing bboard will be icky.  this is sort of hairy
-- problem with unknown potential intra-package references.

-- 

-- Delete all messages that belong to forums
declare
    cursor message_cursor is
        select object_id as message_id
	    from acs_objects
	    where object_id in (select object_id
                                  from acs_objects
	                          where object_type = 'acs_message'
    	                          start with context_id in (select forum_id
                                                              from bboard_forums)
	                          connect by prior object_id = context_id)
            order by object_id desc;
begin
    for message_val in message_cursor loop
        bboard_message.remove(message_val.message_id);
    end loop;
end;
/
show errors

-- Delete all subscriptions
delete from bboard_thread_subscribers;
delete from bboard_category_subscribers;
delete from bboard_forum_subscribers;

-- Delete all categories
delete from bboard_category_message_map;
delete from bboard_categories;
delete from acs_objects where object_type = 'bboard_category';

-- Delete all forums
delete from bboard_forum_message_map;
delete from bboard_forums;
delete from acs_objects where object_type = 'bboard_forum';

-- Drop all schema objects
drop package bboard_message;
drop package bboard_category;
drop package bboard_forum;
drop view bboard_messages_by_category;
drop view bboard_messages_all;
drop table bboard_thread_subscribers;
drop table bboard_category_subscribers;
drop table bboard_forum_subscribers;
drop table bboard_category_message_map;
drop table bboard_categories;
drop table bboard_forum_message_map;
drop table bboard_forums;

-- Drop object type metadata
begin
    acs_object_type.drop_type ('bboard_forum');
    acs_object_type.drop_type ('bboard_category');
end;
/
show errors

-- Drop permission metadata
delete from acs_permissions
    where privilege in
        ('bboard_create_forum', 'bboard_create_category',
         'bboard_create_message', 'bboard_write_forum',
         'bboard_write_category', 'bboard_write_message',
         'bboard_read_forum', 'bboard_read_category',
         'bboard_read_message', 'bboard_delete_forum',
         'bboard_delete_category', 'bboard_delete_message',
         'bboard_moderate_forum');

delete from acs_privilege_hierarchy
    where privilege in
        ('bboard_create_forum', 'bboard_create_category',
         'bboard_create_message', 'bboard_write_forum',
         'bboard_write_category', 'bboard_write_message',
         'bboard_read_forum', 'bboard_read_category',
         'bboard_read_message', 'bboard_delete_forum',
         'bboard_delete_category', 'bboard_delete_message',
         'bboard_moderate_forum');

delete from acs_privilege_hierarchy
    where child_privilege in
        ('bboard_create_forum', 'bboard_create_category',
         'bboard_create_message', 'bboard_write_forum',
         'bboard_write_category', 'bboard_write_message',
         'bboard_read_forum', 'bboard_read_category',
         'bboard_read_message', 'bboard_delete_forum',
         'bboard_delete_category', 'bboard_delete_message',
         'bboard_moderate_forum');

delete from acs_privileges
    where privilege in
        ('bboard_create_forum', 'bboard_create_category',
         'bboard_create_message', 'bboard_write_forum',
         'bboard_write_category', 'bboard_write_message',
         'bboard_read_forum', 'bboard_read_category',
         'bboard_read_message', 'bboard_delete_forum',
         'bboard_delete_category', 'bboard_delete_message',
         'bboard_moderate_forum');

