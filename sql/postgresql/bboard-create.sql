--
-- packages/bboard/sql/bboard-create.sql
--
-- @author Anukul Kapoor <akk@arsdigita.com>
-- @author John Prevost <jmp@arsdigita.com>
-- @creation-date 2000-08-29
-- @cvs-id $Id$
--

-- separate parts so that if one fails, the rest happens

-- create the privileges

begin;

 select acs_privilege__create_privilege('bboard_create_forum',null,null);
 select acs_privilege__create_privilege('bboard_create_category',null,null);
 select acs_privilege__create_privilege('bboard_create_message',null,null);
 select acs_privilege__create_privilege('bboard_write_forum',null,null);
 select acs_privilege__create_privilege('bboard_write_category',null,null);
 select acs_privilege__create_privilege('bboard_write_message',null,null);
 select acs_privilege__create_privilege('bboard_read_forum',null,null);
 select acs_privilege__create_privilege('bboard_read_category',null,null);
 select acs_privilege__create_privilege('bboard_read_message',null,null);
 select acs_privilege__create_privilege('bboard_delete_forum',null,null);
 select acs_privilege__create_privilege('bboard_delete_category',null,null);
 select acs_privilege__create_privilege('bboard_delete_message',null,null);
 select acs_privilege__create_privilege('bboard_moderate_forum',null,null);


 -- temporarily drop this trigger to avoid a data-change violation 
 -- on acs_privilege_hierarchy_index while updating the child privileges.

 drop trigger acs_priv_hier_ins_del_tr on acs_privilege_hierarchy;

 select acs_privilege__add_child('create','bboard_create_forum');
 select acs_privilege__add_child('create','bboard_create_category');
 select acs_privilege__add_child('create','bboard_create_message');
 select acs_privilege__add_child('write','bboard_write_forum');
 select acs_privilege__add_child('write','bboard_write_category');
 select acs_privilege__add_child('write','bboard_write_message');
 select acs_privilege__add_child('read','bboard_read_forum');
 select acs_privilege__add_child('read','bboard_read_category');
 select acs_privilege__add_child('read','bboard_read_message');
 select acs_privilege__add_child('delete','bboard_delete_forum');
 select acs_privilege__add_child('delete','bboard_delete_category');
 select acs_privilege__add_child('delete','bboard_delete_message');
 
 -- re-enable the trigger before the last insert to force the 
 -- acs_privilege_hierarchy_index table to be updated.

 create trigger acs_priv_hier_ins_del_tr after insert or delete
 on acs_privilege_hierarchy for each row
 execute procedure acs_priv_hier_ins_del_tr ();

select acs_privilege__add_child('admin','bboard_moderate_forum');
end;


create function inline_0 ()
returns integer as '
declare
    default_context integer;
    registered_users integer;
    the_public integer;
begin

    default_context := acs__magic_object_id(''default_context'');
    registered_users := acs__magic_object_id(''registered_users'');
    the_public := acs__magic_object_id(''the_public'');

    -- give registered users the power to post by default

    perform acs_permission__grant_permission (
        default_context,
        registered_users,
        ''bboard_create_message''
    );

    -- give the public the power to read by default

    perform acs_permission__grant_permission (
        default_context,
        the_public,
        ''bboard_read_message''
    );

    perform acs_permission__grant_permission (
        default_context,
        the_public,
        ''bboard_read_category''
    );

    perform acs_permission__grant_permission (
        default_context,
        the_public,
        ''bboard_read_forum''
    );


    return 0;
end;
' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();


select acs_object_type__create_type (
    'bboard_forum',
    'BBoard Forum',
    'BBoard Forum',
    'acs_object',
    'BBOARD_FORUMS',
    'FORUM_ID',
    null,
    'f',
    null,
    'BBOARD_FORUM__NAME'
);

select acs_object_type__create_type (
    'bboard_category',
    'BBoard Category',
    'BBoard Categories',
    'acs_object',
    'BBOARD_CATEGORIES',
    'CATEGORY_ID',
    null,
    'f',
     null,
    'BBOARD_CATEGORY__NAME'
);



-- bboard forums
--
-- these act as primary containers for messages
-- a message's context_id will point to its forum

create table bboard_forums (
    forum_id integer
        constraint bboard_forums_forum_id_fk
            references acs_objects (object_id)
        constraint bboard_forums_pk
            primary key,    
    short_name varchar(400)
        constraint bboard_forums_short_name_nn
            not null,
    charter varchar(4000),
    moderated_p char(1)
        constraint bboard_forums_moderated_p_nn
            not null
        constraint bboard_forums_moderated_p_ck
            check (moderated_p in ('t','f')),
    forum_type  varchar(200) default 'q-and-a' 
        constraint bboard_forums_forum_type_nn not null
        constraint bboard_forums_forum_type_ck
                   check (forum_type in ('q-and-a','thread')),
    track_new_postings_p   char(1) default 'f'
        constraint bboard_forums_track_new_ck
                   check (track_new_postings_p in ('t','f')),
    bboard_id integer
        constraint bboard_forums_bboard_id_nn
            not null
        constraint bboard_forums_bboard_id_fk
            references apm_packages (package_id)
                on delete cascade
);

create index bboard_forums_bboard_id_idx
    on bboard_forums (bboard_id);

create table bboard_forum_message_map (
    forum_id integer
        constraint bboard_fmm_forum_id_fk
            references bboard_forums (forum_id)
                on delete cascade,
    message_id integer
        constraint bboard_fmm_message_id_fk
            references acs_messages (message_id)
                on delete cascade,
    status varchar(20)
        constraint bboard_fmm_status_ck
            check (status in ('unmoderated', 'approved', 'rejected'))
        constraint bboard_fmm_status_nn
            not null,
    last_reply_date timestamp,
    num_replies integer,
    constraint bboard_forum_message_map_pk
        primary key (forum_id, message_id)
);

create index bboard_fmm_message_id_idx
    on bboard_forum_message_map (message_id);

create index bboard_fmm_status_idx
    on bboard_forum_message_map (status);

--
-- For tracking individual views on messages
-- (This is a client request, but I still think this will be problematic - ben)
--
create table bboard_message_user_map (
       message_id integer
          constraint bboard_mum_message_id_fk
            references acs_messages (message_id)
            on delete cascade,
       user_id integer
          constraint bboard_mum_user_id_fk
            references users (user_id)
            on delete cascade,
       view_date date default now()
          constraint bboard_mum_view_date_nn
          not null
);

-- bboard categories
--
-- these are for intra-forum categorization
-- categories will be scoped to forums via their acs_object.context_id

create table bboard_categories (
    category_id integer
        constraint bboard_c_category_id_fk
            references acs_objects (object_id)
        constraint bboard_c_category_id_pk
            primary key,
    short_name varchar(400)
        constraint bboard_c_short_name_nn
            not null,
    forum_id integer
        constraint bboard_c_forum_id_fk
            references bboard_forums (forum_id)
                on delete cascade
        constraint bboard_c_forum_id_nn
            not null,
    description varchar(4000)
);

create index bboard_categories_forum_id_idx
    on bboard_categories (forum_id);

create table bboard_category_message_map (
    category_id integer
        constraint bboard_cmm_category_id_fk
            references bboard_categories (category_id)
                on delete cascade,
    message_id integer
        constraint bboard_cmm_message_id_fk
            references acs_messages (message_id)
                on delete cascade,
    constraint bboard_category_message_map_pk
        primary key (category_id, message_id)
);

create index bboard_cmm_message_id_idx
    on bboard_category_message_map (message_id);

-- @@ bboard-views

-- Tables to track subscriptions

create table bboard_forum_subscribers (
    forum_id integer
        constraint bboard_fs_forum_id_fk
            references bboard_forums (forum_id)
                on delete cascade,
    subscriber_id integer
        constraint bboard_fs_subscriber_id_fk
            references parties (party_id)
                on delete cascade,
    constraint bboard_forum_subscribers_pk
        primary key (forum_id, subscriber_id)
);

create index bboard_fs_subscriber_id_idx
    on bboard_forum_subscribers (subscriber_id);

create table bboard_category_subscribers (
    category_id integer
        constraint bboard_cs_category_id_fk
            references bboard_categories (category_id)
                on delete cascade,
    subscriber_id integer
        constraint bboard_cs_subscriber_id_fk
            references parties (party_id)
                on delete cascade,
    constraint bboard_category_subscribers_pk
        primary key (category_id, subscriber_id)
);

create index bboard_cs_subscriber_id_idx
    on bboard_category_subscribers (subscriber_id);

create table bboard_thread_subscribers (
    thread_id integer
        constraint bboard_ts_thread_id_fk
            references acs_messages (message_id)
                on delete cascade,
    subscriber_id integer
        constraint bboard_ts_subscriber_id_fk
            references parties (party_id)
                on delete cascade,
    constraint bboard_thread_subscribers_pk
        primary key (thread_id, subscriber_id)
);

create index bboard_ts_subscriber_id_idx
    on bboard_thread_subscribers (subscriber_id);

\i bboard-views.sql
\i bboard-packages.sql

insert into cr_mime_types (mime_type) 
 values ('text/plain; format=flowed');


-- -- NOTE: this is only temporary until we figure out how
-- --       packages will register child types to an acs-message
-- declare
--     v_exists	integer;
-- begin

--     select decode(count(*),0,0,1) into v_exists 
--       from cr_type_children
--       where parent_type = 'acs_message_revision'
--       and child_type = 'content_revision';

--     if v_exists = 0 then
--       content_type.register_child_type (
--           parent_type => 'acs_message_revision',
--           child_type  => 'content_revision'
--       );
--     end if;

--     select decode(count(*),0,0,1) into v_exists 
--       from cr_type_children
--       where parent_type = 'acs_message_revision'
--       and child_type = 'content_revision';

--     if v_exists = 0 then
--       content_type.register_child_type (
--           parent_type => 'acs_message_revision',
--           child_type  => 'image'
--       );
--     end if;

--     select decode(count(*),0,0,1) into v_exists 
--       from cr_type_children
--       where parent_type = 'acs_message_revision'
--       and child_type = 'content_revision';

--     if v_exists = 0 then
--       content_type.register_child_type (
--           parent_type => 'acs_message_revision',
--           child_type  => 'content_extlink'
--       );
--     end if;

-- end;
-- /
-- show errors
