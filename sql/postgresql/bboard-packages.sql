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
-- packages/bboard/sql/bboard-packages.sql
--
-- @author Anukul Kapoor <akk@arsdigita.com>
-- @author John Prevost <jmp@arsdigita.com>
-- @creation-date 2000-11-22
-- @cvs-id $Id$
--

------------ bboard_forum package ---------------

create function bboard_forum__forum_p (integer)
returns char as '
declare
    p_forum_id alias for $1;
    v_check_forum_id integer;
begin
    select count(forum_id) into v_check_forum_id
        from bboard_forums
        where forum_id = p_forum_id;
    if v_check_forum_id = 1 then
        return ''t'';
    else
        return ''f'';
    end if;
end;
' language 'plpgsql';


create function bboard_forum__new (integer, varchar, varchar, char, varchar,
                    integer, integer, timestamp, integer, varchar, varchar)
returns integer as '
declare
    p_forum_id      alias for $1;         -- default null
    p_short_name    alias for $2;
    p_charter       alias for $3;         -- default null
    p_moderated_p   alias for $4;         -- default ''f''
    p_forum_type    alias for $5;
    p_bboard_id     alias for $6;
    p_context_id    alias for $7;         -- default null
    p_creation_date alias for $8;         -- default now()
    p_creation_user alias for $9;         -- default null
    p_creation_ip   alias for $10;         -- default null
    p_object_type   alias for $11;        -- default ''bboard_forum''
    v_context_id  integer;
    v_forum_id    integer;
begin
    v_context_id := coalesce(p_context_id, p_bboard_id);
    v_forum_id := acs_object__new (
        p_forum_id,
	p_object_type,
	p_creation_date,
	p_creation_user,
	p_creation_ip,
	v_context_id
    );

    insert into bboard_forums
               (forum_id, short_name, charter, moderated_p, forum_type, bboard_id)
        values (v_forum_id, p_short_name, p_charter, p_moderated_p, p_forum_type, p_bboard_id);
    return v_forum_id;   
end;
' language 'plpgsql';


create function bboard_forum__delete (integer)
returns integer as '
declare
    p_forum_id alias for $1;
begin
    delete from bboard_forums
        where forum_id = p_forum_id;
    PERFORM acs_object__delete(p_forum_id);
    return 0;
end;
' language 'plpgsql';


create function bboard_forum__set_attrs (integer, varchar, varchar, char, integer)
returns integer as '
declare
    p_forum_id         alias for $1;
    p_short_name       alias for $2;  -- default null
    p_charter          alias for $3;  -- default null
    p_moderated_p      alias for $4;  -- default null
    p_bboard_id        alias for $5;  -- default null
    v_check_forum_id integer;
begin
    select count(forum_id) into v_check_forum_id
        from bboard_forums
        where forum_id = p_forum_id;
    -- Not a forum.  Fail silently?
    if v_check_forum_id <> 1 then
        return -1;
    end if;
    if p_short_name is not null then
        update bboard_forums set short_name = p_short_name
            where forum_id = p_forum_id;
    end if;
        update bboard_forums set charter = p_charter
            where forum_id = p_forum_id;
    if p_moderated_p is not null then
        update bboard_forums set moderated_p = p_moderated_p
            where forum_id = p_forum_id;
    end if;
    if p_bboard_id is not null then
        update bboard_forums set bboard_id = p_bboard_id
            where forum_id = p_forum_id;
        update acs_objects set context_id = p_bboard_id
            where object_id = p_forum_id;
    end if;
    return 0;
end;
' language 'plpgsql';


create function bboard_forum__subscribe (integer, integer)
returns integer as '
declare
    p_forum_id      alias for $1;
    p_subscriber_id alias for $2;
begin
    insert into bboard_forum_subscribers (forum_id, subscriber_id)
        values (p_forum_id, p_subscriber_id);
    return 0;
end;
' language 'plpgsql';


create function bboard_forum__forum_containing_message (integer)
returns integer as '
declare
    p_message_id    alias for $1;
    v_forum_id      integer;
begin
    select max(forum_id) into v_forum_id
      from bboard_forum_message_map
     where message_id = p_message_id;

    if v_forum_id is null then
        return 0;
    else
        return v_forum_id;
    end if;
end;
' language 'plpgsql';


create function bboard_forum__name (integer)
returns varchar as '
declare
    p_forum_id      alias for $1;
    v_forum_name   varchar;
begin
    select short_name into v_forum_name
        from bboard_forums
	    where forum_id = p_forum_id;
    return v_forum_name;
end;
' language 'plpgsql';


---------- bboard_category package ---------------

create function bboard_category__category_p (integer)
returns char as '
declare
    p_category_id alias for $1;
    v_check_category_id integer;
begin
    select count(category_id) into v_check_category_id
        from bboard_categories
        where category_id = p_category_id;
    if v_check_category_id = 1 then
        return ''t'';
    else
        return ''f'';
    end if;
end;
' language 'plpgsql';


create function bboard_category__new (integer, varchar, varchar, integer, 
                               integer, timestamp, integer, varchar, varchar)
returns integer as '
declare
    p_category_id   alias for $1;  -- default null
    p_short_name    alias for $2;
    p_description   alias for $3;  -- default null
    p_forum_id      alias for $4;
    p_context_id    alias for $5;  -- default null
    p_creation_date alias for $6;  -- default now()
    p_creation_user alias for $7;  -- default null
    p_creation_ip   alias for $8;  -- default null
    p_object_type   alias for $9;  -- default ''bboard_category''
    v_category_id   integer;
    v_context_id    integer;
begin
    v_context_id := coalesce(p_context_id, p_forum_id);
    v_category_id := acs_object__new (
        p_category_id,
        p_object_type,
        p_creation_date,
        p_creation_user,
        p_creation_ip,
        v_context_id
    );

    insert into bboard_categories
           (category_id, short_name, description, forum_id)
    values (v_category_id, p_short_name, p_description, p_forum_id);

    return v_category_id;    
end;
' language 'plpgsql';


create function bboard_category__delete (integer)
returns integer as '
declare
    p_category_id alias for $1;
begin
    delete from bboard_categories
        where category_id = p_category_id;
    PERFORM acs_object__delete(p_category_id);
    return 0;
end;
' language 'plpgsql';


create function bboard_category__set_attrs (integer, varchar, varchar, integer)
returns integer as '
declare
    p_category_id         alias for $1;
    p_short_name          alias for $2;  -- default null
    p_description         alias for $3;  -- default null
    p_forum_id            alias for $4;  -- default null
    v_check_category_id integer;
begin
    select count(category_id) into v_check_category_id
        from bboard_categories
        where category_id = p_category_id;
    -- Not a category.  Fail silently?
    if v_check_category_id <> 1 then
        return -1;
    end if;
    -- It is a category.  Go for it.
    if p_short_name is not null then
        update bboard_categories set short_name = p_short_name
            where category_id = p_category_id;
    end if;
    if p_description is not null then
        update bboard_categories set description = p_description
            where category_id = p_category_id;
    end if;
    if p_forum_id is not null then
        update bboard_categories set forum_id = p_forum_id
            where category_id = p_category_id;
        update acs_objects set context_id = p_forum_id
            where object_id = p_category_id;
    end if;
    return 0;
end;
' language 'plpgsql';

create function bboard_category__subscribe (integer, integer)
returns integer as '
declare
    p_category_id   alias for $1;
    p_subscriber_id alias for $2;
begin
    insert into bboard_category_subscribers (category_id, subscriber_id)
        values (p_category_id, p_subscriber_id);
    return 0;
end;
' language 'plpgsql';


create function bboard_category__name (integer)
returns varchar as '
declare
    category_id      alias for $1;
    v_category_name   varchar;
begin
    select short_name into v_category_name
        from bboard_categories
	    where category_id = name.category_id;
    return v_category_name;
end;
' language 'plpgsql';


--------------- bboard_message package ----------------

create function bboard_message__new (integer, integer, timestamp, integer,
        varchar, varchar, varchar, varchar, text, 
        integer, timestamp, integer, varchar, varchar)
returns integer as '
declare
    p_message_id    alias for $1;   -- default null
    p_reply_to      alias for $2;   -- default null
    p_sent_date     alias for $3;   -- default sysdate
    p_sender        alias for $4;   -- default null
    p_rfc822_id     alias for $5;   -- default null
    p_title         alias for $6;   -- default null
    p_mime_type     alias for $7;   -- default ''text/plain''
    p_text          alias for $8;   -- default null
    p_data          alias for $9;   -- default null
    p_context_id    alias for $10;  -- default 0
    p_creation_date alias for $11;  -- default sysdate
    p_creation_user alias for $12;  -- default null
    p_creation_ip   alias for $13;  -- default null
    p_object_type   alias for $14;  -- default ''acs_message''
    v_sent_date   timestamp;
begin
    v_sent_date := coalesce(p_sent_date, now());

    return acs_message__new (
        p_message_id,
        p_reply_to,
        v_sent_date,
        p_sender,
        p_rfc822_id,
        p_title,
        null,
        p_mime_type,
        p_text,
        p_data,
        0,
        p_context_id,
        p_creation_user,
        p_creation_ip,
        p_object_type,
        ''t''
    );
    return 0;
end;
' language 'plpgsql';


create function bboard_message__message_p (integer)
returns char as '
declare
    p_message_id alias for $1;
    v_check_message_id integer;
begin
    select count(message_id) into v_check_message_id
        from acs_messages
        where message_id = p_message_id;
    if v_check_message_id = 1 then
        return ''t'';
    else
        return ''f'';
    end if;
end;
' language 'plpgsql';


create function bboard_message__set_attrs (integer, integer, timestamp,
                                           integer, varchar, varchar, integer)
returns integer as '
declare
    p_message_id         alias for $1;
    p_reply_to           alias for $2; -- default null
    p_sent_date          alias for $3; -- default null
    p_sender             alias for $4; -- default null
    p_title              alias for $5; -- default null
    p_mime_type          alias for $6; -- default null
    p_context_id         alias for $7; -- default null
    v_check_message_id   integer;
    v_revision_id        integer;
begin
    if bboard_message__message_p(p_message_id) = ''f'' then
        return -1;
    end if;

    -- modify the parts that are in acs_messages

    if p_reply_to is not null then
        update acs_messages set reply_to = p_reply_to
            where message_id = p_message_id;
    end if;
    if p_sent_date is not null then
        update acs_messages set sent_date = p_sent_date
            where message_id = p_message_id;
    end if;
    if p_sender is not null then
        update acs_messages set sender = p_sender
            where message_id = p_message_id;
    end if;

    -- modify the parts that are in cr_revisions
    if p_title is not null or p_mime_type is not null then
        select live_revision into v_revision_id
            from cr_items where item_id = p_message_id
            for update;
        if p_title is not null then
            update cr_revisions set title = p_title
                where revision_id = v_revision_id;
        end if;
        if p_mime_type is not null then
            update cr_revisions set mime_type = p_mime_type
                where revision_id = v_revision_id;
        end if;
    end if;

    -- modify the context_id in acs_objects

    if p_context_id is not null then
        update acs_objects set context_id = p_context_id
            where object_id = p_message_id;
    end if;

    return 0;
end;
' language 'plpgsql';


create function bboard_message__set_status (integer, integer, varchar)
returns integer as '
declare
    p_message_id alias for $1;
    p_forum_id   alias for $2;
    p_status     alias for $3;
begin
    if bboard_message__message_p(p_message_id) = ''f''
            or bboard_forum__forum_p(p_forum_id) = ''f'' then
        return -1;
    end if;
    delete from bboard_forum_message_map
        where message_id = p_message_id
            and forum_id = p_forum_id;
    if p_status is not null then
        insert into bboard_forum_message_map (forum_id, message_id, status)
        values (p_forum_id, p_message_id, p_status);
    end if;

    return 0;
end;
' language 'plpgsql';


create function bboard_message__add_category (integer, integer)
returns integer as '
declare
    p_message_id  alias for $1;
    p_category_id alias for $2;
begin
    insert into bboard_category_message_map (message_id, category_id)
        values (p_message_id, p_category_id);
    return 0;
end;
' language 'plpgsql';


create function bboard_message__remove_category (integer, integer)
returns integer as '
declare
    p_message_id  alias for $1;
    p_category_id alias for $2;
begin
    delete from bboard_category_message_map
     where category_id = p_category_id
       and message_id = p_message_id;
    return 0;
end;
' language 'plpgsql';


create function bboard_message__clear_categories (integer)
returns integer as '
declare
    p_message_id alias for $1;
begin
    delete from bboard_category_message_map
     where message_id = p_message_id;
    return 0;
end;
' language 'plpgsql';


create function bboard_message__subscribe (integer, integer)
returns integer as '
declare
    p_thread_id     alias for $1;
    p_subscriber_id alias for $2;
begin
    insert into bboard_thread_subscribers (thread_id, subscriber_id)
    values (p_thread_id, p_subscriber_id);
    return 0;
end;
' language 'plpgsql';


create function bboard_message__remove_thread (integer)
returns integer as '
declare
    thread_id    alias for $1;
    child_val record;
    message_val record;
    image_p integer;
    v_search_key varbit;
begin
    select tree_sortkey into v_search_key
      from acs_messages
     where message_id = thread_id;

    for child_val in 
        select object_id as child_id, object_type
          from acs_objects o, acs_messages m
         where o.context_id = m.message_id 
           and m.tree_sortkey between v_search_key and tree_right(v_search_key)
    loop
        if child_val.object_type = ''acs_message'' then
           perform acs_message__delete(child_val.child_id);
        elsif child_val.object_type = ''content_item'' then
            select count(*) into image_p
	      from images
             where image_id = child_val.child_id;
            if image_p = 1 then
                perform acs_message__delete_image(child_val.child_id);
            else
                perform acs_message__delete_file(child_val.child_id);
            end if;
       end if;
    end loop;

    for message_val in 
        select message_id
	  from acs_messages
         where tree_sortkey between v_search_key and tree_right(v_search_key)
    loop
        perform acs_message__delete(message_val.message_id);
    end loop;

    return 0;
end;
' language 'plpgsql';


create function bboard_message__remove (integer)
returns integer as '
declare
    message_id alias for $1;
    child_val record;
    image_p integer;
begin
    for child_val in 
        select object_id as child_id, object_type
	  from acs_objects
         where context_id = message_id
    loop
	if child_val.object_type = ''acs_message'' then
	   perform acs_message__delete(child_val.child_id);
	elsif child_val.object_type = ''content_item'' then
	    select count(*) into image_p
	      from images
                where image_id = child_val.child_id;
            if image_p = 1 then
                perform acs_message__delete_image(child_val.child_id);
            else
                perform acs_message__delete_file(child_val.child_id);
            end if;
       end if;
   end loop;

   perform acs_message__delete(message_id);
   return 0;
end;
' language 'plpgsql';
