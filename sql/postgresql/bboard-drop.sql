--
--  Copyright (C) 2001, 2002 OpenForce, Inc.
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

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


create function inline_0 ()
returns integer as '

    raise NOTICE ''currently it is impossible to delete multiple threads within a transaction.  please ensure you have removed all forums through the admin interface before you try to drop the package.''

' language 'plpgsql';

select inline_0 ();
drop function inline_0();


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

drop function bboard_forum__forum_p (integer);
drop function bboard_forum__new (integer, varchar, varchar, char, integer,
                            integer, timestamp, integer, varchar, varchar);
drop function bboard_forum__delete (integer);
drop function bboard_forum__set_attrs (integer, varchar, varchar, char, integer);
drop function bboard_forum__subscribe (integer, integer);
drop function bboard_forum__forum_containing_message (integer);
drop function bboard_forum__name (integer);
drop function bboard_category__category_p (integer);
drop function bboard_category__new (integer, varchar, varchar, integer, 
                               integer, timestamp, integer, varchar, varchar);
drop function bboard_category__delete (integer);
drop function bboard_category__set_attrs (integer, varchar, varchar, integer);
drop function bboard_category__subscribe (integer, integer);
drop function bboard_category__name (integer);
drop function bboard_message__new (integer, integer, timestamp, integer,
        varchar, varchar, varchar, varchar, text, 
        integer, timestamp, integer, varchar, varchar);
drop function bboard_message__message_p (integer);
drop function bboard_message__set_attrs (integer, integer, timestamp,
                                      integer, varchar, varchar, integer);
drop function bboard_message__set_status (integer, integer, varchar);
drop function bboard_message__add_category (integer, integer);
drop function bboard_message__remove_category (integer, integer);
drop function bboard_message__clear_categories (integer);
drop function bboard_message__subscribe (integer, integer);
drop function bboard_message__remove_thread (integer);
drop function bboard_message__remove (integer);



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
begin;
    select acs_object_type__drop_type ('bboard_forum', 'f');
    select acs_object_type__drop_type ('bboard_category', 'f');
end;


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

