--
-- packages/bboard/sql/upgrade-4.0.1-4.0.2.sql
--
-- @author John Prevost <jmp@arsdigita.com>
-- @creation-date 2000-12-01
-- @cvs-id $Id$
--

set feedback off

-- arrgh.  This isn't entirely safe, but we can't do anything about it!
-- locking the table fails (alter table commands hit the lock, bounce,
-- and the transaction aborts, since DDL isn't transactional.)  Can't
-- create another constraint with the same behavior to change behind the
-- back.  Lose lose lose.

alter table bboard_forums
    drop constraint bboard_forums_bboard_id_fk;

alter table bboard_forums add (
    constraint bboard_forums_bboard_id_fk
        foreign key (bboard_id)
            references apm_packages (package_id)
                on delete cascade
);

create index bboard_forums_bboard_id_idx
    on bboard_forums (bboard_id);

alter table bboard_forum_message_map
    drop constraint bboard_fmm_forum_id_fk;
alter table bboard_forum_message_map
    drop constraint bboard_fmm_message_id_fk;

alter table bboard_forum_message_map add (
    constraint bboard_fmm_forum_id_fk
        foreign key (forum_id)
            references bboard_forums (forum_id)
                on delete cascade,
    constraint bboard_fmm_message_id_fk
        foreign key (message_id)
            references acs_messages (message_id)
                on delete cascade
);

alter table bboard_categories
    drop constraint bboard_c_forum_id_fk;

alter table bboard_categories add (
    constraint bboard_c_forum_id_fk
        foreign key (forum_id)
            references bboard_forums (forum_id)
                on delete cascade
);

create index bboard_categories_forum_id_idx
    on bboard_categories (forum_id);

alter table bboard_forum_subscribers
    drop constraint bboard_fs_forum_id_fk;
alter table bboard_forum_subscribers
    drop constraint bboard_fs_subscriber_id_fk;

alter table bboard_forum_subscribers add (
    constraint bboard_fs_forum_id_fk
        foreign key (forum_id)
            references bboard_forums (forum_id)
                on delete cascade,
    constraint bboard_fs_subscriber_id_fk
        foreign key (subscriber_id)
            references parties (party_id)
                on delete cascade
);

create index bboard_fs_subscriber_id_idx
    on bboard_forum_subscribers (subscriber_id);

alter table bboard_category_subscribers
    drop constraint bboard_cs_category_id_fk;
alter table bboard_category_subscribers
    drop constraint bboard_cs_subscriber_id_fk;

alter table bboard_category_subscribers add (
    constraint bboard_cs_category_id_fk
        foreign key (category_id)
            references bboard_categories (category_id)
                on delete cascade,
    constraint bboard_cs_subscriber_id_fk
        foreign key (subscriber_id)
            references parties (party_id)
                on delete cascade
);

create index bboard_cs_subscriber_id_idx
    on bboard_category_subscribers (subscriber_id);

alter table bboard_thread_subscribers
    drop constraint bboard_ts_thread_id_fk;
alter table bboard_thread_subscribers
    drop constraint bboard_ts_subscriber_id_fk;

alter table bboard_thread_subscribers add (
    constraint bboard_ts_thread_id_fk
        foreign key (thread_id)
            references acs_messages (message_id)
                on delete cascade,
    constraint bboard_ts_subscriber_id_fk
        foreign key (subscriber_id)
            references parties (party_id)
                on delete cascade
);

create index bboard_ts_subscriber_id_idx
    on bboard_thread_subscribers (subscriber_id);


@@ bboard-views

-- NOTE: this is only temporary until we figure out how
--       packages will register child types to an acs-message
declare
    v_exists	integer;
begin

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'content_revision'
      );
    end if;

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'image'
      );
    end if;

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'content_extlink'
      );
    end if;

end;
/
show errors
