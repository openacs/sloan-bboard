--
-- packages/bboard/sql/bboard-packages.sql
--
-- @author Anukul Kapoor <akk@arsdigita.com>
-- @author John Prevost <jmp@arsdigita.com>
-- @creation-date 2000-11-22
-- @cvs-id $Id$
--

create or replace package bboard_forum
as

    function forum_p (
        forum_id in bboard_forums.forum_id%TYPE
    ) return char;

    function new (
        forum_id      in bboard_forums.forum_id%TYPE    default null,
        short_name    in bboard_forums.short_name%TYPE,
        charter       in bboard_forums.charter%TYPE     default null,
        moderated_p   in bboard_forums.moderated_p%TYPE default 'f',
        format        in bboard_forums.format%TYPE      default 'q-and-a',
        bboard_id     in bboard_forums.bboard_id%TYPE,
        context_id    in acs_objects.context_id%TYPE    default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip   in acs_objects.creation_ip%TYPE   default null,
        object_type   in acs_objects.object_type%TYPE   default 'bboard_forum'
    ) return acs_objects.object_id%TYPE;

    procedure delete (
        forum_id in bboard_forums.forum_id%TYPE
    );

    procedure set_attrs (
        forum_id      in bboard_forums.forum_id%TYPE,
        short_name    in bboard_forums.short_name%TYPE default null,
        charter       in bboard_forums.charter%TYPE     default null,
        moderated_p   in bboard_forums.moderated_p%TYPE default null,
        bboard_id     in acs_objects.context_id%TYPE    default null
    );

    procedure subscribe (
        forum_id      in bboard_forum_subscribers.forum_id%TYPE,
        subscriber_id in bboard_forum_subscribers.subscriber_id%TYPE
    );

    function forum_containing_message (
	message_id    in acs_messages.message_id%TYPE
    ) return bboard_forums.forum_id%TYPE;

    function name (
        forum_id      in acs_objects.object_id%TYPE
    ) return varchar2;

end bboard_forum;
/
show errors

create or replace package bboard_category
as

    function category_p (
        category_id in bboard_categories.category_id%TYPE
    ) return char;

    function new (
        category_id   in bboard_categories.category_id%TYPE default null,
        short_name    in bboard_categories.short_name%TYPE,
        description   in bboard_categories.description%TYPE default null,
        forum_id      in bboard_forums.forum_id%TYPE,
	context_id    in acs_objects.context_id%TYPE        default null,
        creation_date in acs_objects.creation_date%TYPE     default sysdate,
        creation_user in acs_objects.creation_user%TYPE     default null,
        creation_ip   in acs_objects.creation_ip%TYPE       default null,
        object_type   in acs_objects.object_type%TYPE default 'bboard_category'
    ) return acs_objects.object_id%TYPE;

    procedure delete (
        category_id in bboard_categories.category_id%TYPE
    );

    procedure set_attrs (
        category_id   in bboard_categories.category_id%TYPE,
        short_name    in bboard_categories.short_name%TYPE  default null,
        description   in bboard_categories.description%TYPE default null,
        forum_id      in integer           default null
    );

    procedure subscribe (
        category_id   in bboard_category_subscribers.category_id%TYPE,
        subscriber_id in bboard_category_subscribers.subscriber_id%TYPE
    );

    function name (
        category_id      acs_objects.object_id%TYPE
    ) return varchar2;

end bboard_category;
/
show errors

create or replace package bboard_message
as

    function new (
        message_id    in acs_messages.message_id%TYPE   default null,
        reply_to      in acs_messages.message_id%TYPE   default null,
        sent_date     in acs_messages.sent_date%TYPE    default sysdate,
        sender        in acs_messages.sender%TYPE       default null,
        rfc822_id     in acs_messages.rfc822_id%TYPE    default null,
        title         in cr_revisions.title%TYPE        default null,
        mime_type     in cr_revisions.mime_type%TYPE    default 'text/plain',
	text          in varchar2                       default null,
	data          in cr_revisions.content%TYPE      default null,
        context_id    in acs_objects.context_id%TYPE    default 0,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip   in acs_objects.creation_ip%TYPE   default null,
        object_type   in acs_objects.object_type%TYPE   default 'acs_message'
    ) return acs_objects.object_id%TYPE;

    function message_p (
        message_id in acs_messages.message_id%TYPE
    ) return char;

    procedure set_attrs (
        message_id in acs_messages.message_id%TYPE,
        reply_to   in acs_messages.reply_to%TYPE  default null,
        sent_date  in acs_messages.sent_date%TYPE default null,
        sender     in acs_messages.sender%TYPE    default null,
        title      in cr_revisions.title%TYPE     default null,
        mime_type  in cr_revisions.mime_type%TYPE default null,
        context_id in acs_objects.context_id%TYPE default null
    );

    procedure set_status (
        message_id in bboard_forum_message_map.message_id%TYPE,
        forum_id   in bboard_forum_message_map.forum_id%TYPE,
        status     in bboard_forum_message_map.status%TYPE
    );

    procedure add_category (
        message_id  in bboard_category_message_map.message_id%TYPE,
        category_id in bboard_category_message_map.category_id%TYPE
    );

    procedure remove_category (
        message_id  in bboard_category_message_map.message_id%TYPE,
        category_id in bboard_category_message_map.category_id%TYPE
    );

    procedure clear_categories (
        message_id in bboard_category_message_map.message_id%TYPE
    );

    procedure subscribe (
        thread_id     in bboard_thread_subscribers.thread_id%TYPE,
        subscriber_id in bboard_thread_subscribers.subscriber_id%TYPE
    );

    function name (
        message_id      acs_objects.object_id%TYPE
    ) return varchar2;

    procedure remove_thread (
        thread_id    in bboard_messages_all.message_id%TYPE
    );

    procedure remove (
        message_id   in bboard_messages_all.message_id%TYPE
    );

end bboard_message;
/
show errors




create or replace package body bboard_forum
as

    function forum_p (
        forum_id in bboard_forums.forum_id%TYPE
    ) return char
    is
        v_check_forum_id integer;
    begin
        select count(forum_id) into v_check_forum_id
            from bboard_forums
            where forum_id = forum_p.forum_id;
        if v_check_forum_id = 1 then
            return 't';
        else
            return 'f';
        end if;
    end forum_p;

    function new (
        forum_id      in bboard_forums.forum_id%TYPE    default null,
        short_name    in bboard_forums.short_name%TYPE,
        charter       in bboard_forums.charter%TYPE     default null,
        moderated_p   in bboard_forums.moderated_p%TYPE default 'f',
        format        in bboard_forums.format%TYPE      default 'q-and-a',
        bboard_id     in bboard_forums.bboard_id%TYPE,
        context_id    in acs_objects.context_id%TYPE    default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip   in acs_objects.creation_ip%TYPE   default null,
        object_type   in acs_objects.object_type%TYPE   default 'bboard_forum'
    ) return acs_objects.object_id%TYPE
    is
        v_context_id acs_objects.context_id%TYPE;
        v_forum_id bboard_forums.forum_id%TYPE;
    begin
        v_context_id := nvl(context_id, bboard_id);
        v_forum_id := acs_object.new (
            context_id    => v_context_id,
            object_id     => forum_id,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip   => creation_ip,
            object_type   => object_type
        );
        insert into bboard_forums
                   (forum_id, short_name, charter, moderated_p, format, bboard_id)
            values (v_forum_id, short_name, charter, moderated_p, format, bboard_id);
        return v_forum_id;   
    end new;

    procedure delete (
        forum_id in bboard_forums.forum_id%TYPE
    )
    is
    begin
        delete from bboard_forums
            where forum_id = bboard_forum.delete.forum_id;
        acs_object.delete(forum_id);
    end delete;

    procedure set_attrs (
        forum_id      in bboard_forums.forum_id%TYPE,
        short_name    in bboard_forums.short_name%TYPE default null,
        charter       in bboard_forums.charter%TYPE     default null,
        moderated_p   in bboard_forums.moderated_p%TYPE default null,
        bboard_id     in acs_objects.context_id%TYPE    default null
    )
    is
        v_check_forum_id integer;
    begin
        select count(forum_id) into v_check_forum_id
            from bboard_forums
            where forum_id = set_attrs.forum_id;
        -- It's not a forum.  Fail silently?
        if v_check_forum_id <> 1 then
            return;
        end if;
        if short_name is not null then
            update bboard_forums set short_name = set_attrs.short_name
                where forum_id = set_attrs.forum_id;
        end if;
            update bboard_forums set charter = set_attrs.charter
                where forum_id = set_attrs.forum_id;
        if moderated_p is not null then
            update bboard_forums set moderated_p = set_attrs.moderated_p
                where forum_id = set_attrs.forum_id;
        end if;
        if bboard_id is not null then
            update bboard_forums set bboard_id = set_attrs.bboard_id
                where forum_id = set_attrs.forum_id;
            update acs_objects set context_id = set_attrs.bboard_id
                where object_id = set_attrs.forum_id;
        end if;
    end set_attrs;

    procedure subscribe (
        forum_id      in bboard_forum_subscribers.forum_id%TYPE,
        subscriber_id in bboard_forum_subscribers.subscriber_id%TYPE
    )
    is
    begin
        insert into bboard_forum_subscribers (forum_id, subscriber_id)
            values (forum_id, subscriber_id);
    end;

    function forum_containing_message (
        message_id    in acs_messages.message_id%TYPE
    ) return bboard_forums.forum_id%TYPE
    is
	v_forum_id	bboard_forums.forum_id%TYPE;
    begin
	select max(forum_id) into v_forum_id
	  from bboard_forum_message_map
	  where message_id = forum_containing_message.message_id;
	if v_forum_id is null then
	   return 0;
        else
  	   return v_forum_id;
        end if;
    end forum_containing_message;

    function name (
        forum_id      in acs_objects.object_id%TYPE
    ) return varchar2
    is
        v_forum_name   bboard_forums.short_name%TYPE;
    begin
        select short_name into v_forum_name
            from bboard_forums
	    where forum_id = name.forum_id;
        return v_forum_name;
    end name;

end bboard_forum;
/
show errors

create or replace package body bboard_category
as

    function category_p (
        category_id in bboard_categories.category_id%TYPE
    ) return char
    is
        v_check_category_id integer;
    begin
        select count(category_id) into v_check_category_id
            from bboard_categories
            where category_id = category_p.category_id;
        if v_check_category_id = 1 then
            return 't';
        else
            return 'f';
        end if;
    end category_p;

    function new (
        category_id   in bboard_categories.category_id%TYPE default null,
        short_name    in bboard_categories.short_name%TYPE,
        description   in bboard_categories.description%TYPE default null,
        forum_id      in bboard_forums.forum_id%TYPE,
	context_id    in acs_objects.context_id%TYPE  default null,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip   in acs_objects.creation_ip%TYPE default null,
        object_type   in acs_objects.object_type%TYPE default 'bboard_category'
    ) return acs_objects.object_id%TYPE
    is
        v_category_id bboard_categories.category_id%TYPE;
        v_context_id acs_objects.context_id%TYPE;	
    begin
        v_context_id := nvl(context_id, forum_id);
        v_category_id := acs_object.new (
            object_id => category_id,
            context_id => v_context_id,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            object_type => object_type
        );
        insert into bboard_categories
                (category_id, short_name, description, forum_id)
            values (v_category_id, short_name, description, forum_id);
        return v_category_id;    
    end new;

    procedure delete (
        category_id in bboard_categories.category_id%TYPE
    )
    is
    begin
        delete from bboard_categories
            where category_id = bboard_category.delete.category_id;
        acs_object.delete(category_id);
    end delete;

    procedure set_attrs (
        category_id   in bboard_categories.category_id%TYPE,
        short_name    in bboard_categories.short_name%TYPE  default null,
        description   in bboard_categories.description%TYPE default null,
        forum_id      in integer                            default null
    )
    is
        v_check_category_id integer;
    begin
        select count(category_id) into v_check_category_id
            from bboard_categories
            where category_id = set_attrs.category_id;
        -- It's not a category.  Fail silently?
        if v_check_category_id <> 1 then
            return;
        end if;
        -- It's a category.  Go for it.
        if short_name is not null then
            update bboard_categories set short_name = set_attrs.short_name
                where category_id = set_attrs.category_id;
        end if;
        if description is not null then
            update bboard_categories set description = set_attrs.description
                where category_id = set_attrs.category_id;
        end if;
        if forum_id is not null then
            update bboard_categories set forum_id = set_attrs.forum_id
                where category_id = set_attrs.category_id;
            update acs_objects set context_id = set_attrs.forum_id
                where object_id = set_attrs.category_id;
        end if;
    end set_attrs;

    procedure subscribe (
        category_id   in bboard_category_subscribers.category_id%TYPE,
        subscriber_id in bboard_category_subscribers.subscriber_id%TYPE
    )
    is
    begin
        insert into bboard_category_subscribers (category_id, subscriber_id)
            values (category_id, subscriber_id);
    end;

    function name (
        category_id      in acs_objects.object_id%TYPE
    ) return varchar2
    is
        v_category_name   bboard_categories.short_name%TYPE;
    begin
        select short_name into v_category_name
            from bboard_categories
	    where category_id = name.category_id;
        return v_category_name;
    end name;

end bboard_category;
/
show errors


create or replace package body bboard_message
as

    function new (
        message_id    in acs_messages.message_id%TYPE   default null,
        reply_to      in acs_messages.message_id%TYPE   default null,
        sent_date     in acs_messages.sent_date%TYPE    default sysdate,
        sender        in acs_messages.sender%TYPE       default null,
        rfc822_id     in acs_messages.rfc822_id%TYPE    default null,
        title         in cr_revisions.title%TYPE        default null,
        mime_type     in cr_revisions.mime_type%TYPE    default 'text/plain',
	text          in varchar2                       default null,
	data          in cr_revisions.content%TYPE      default null,
        context_id    in acs_objects.context_id%TYPE    default 0,
        creation_date in acs_objects.creation_date%TYPE default sysdate,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip   in acs_objects.creation_ip%TYPE   default null,
        object_type   in acs_objects.object_type%TYPE   default 'acs_message'
    ) return acs_objects.object_id%TYPE
    is
        v_sent_date acs_messages.sent_date%TYPE;
    begin
        v_sent_date := nvl(sent_date, sysdate);

        return acs_message.new (
            message_id => message_id,
            reply_to => reply_to,
            sent_date => v_sent_date,
            sender => sender,
            title => title,
            mime_type => mime_type,
            text => text,
            data => data,
            context_id => context_id,
            creation_date => creation_date,
            creation_user => creation_user,
            creation_ip => creation_ip,
            object_type => object_type
        );
    end new;

    function message_p (
        message_id in acs_messages.message_id%TYPE
    ) return char
    is
        v_check_message_id integer;
    begin
        select count(message_id) into v_check_message_id
            from acs_messages
            where message_id = message_p.message_id;
        if v_check_message_id = 1 then
            return 't';
        else
            return 'f';
        end if;
    end message_p;

    procedure set_attrs (
        message_id in acs_messages.message_id%TYPE,
        reply_to   in acs_messages.reply_to%TYPE             default null,
        sent_date  in acs_messages.sent_date%TYPE            default null,
        sender     in acs_messages.sender%TYPE               default null,
        title      in cr_revisions.title%TYPE                default null,
        mime_type  in cr_revisions.mime_type%TYPE            default null,
        context_id in acs_objects.context_id%TYPE            default null
    )
    is
        v_check_message_id integer;
        v_revision_id integer;
    begin
        if message_p(message_id) = 'f' then
            return;
        end if;

        -- modify the parts that are in acs_messages

        if reply_to is not null then
            update acs_messages set reply_to = set_attrs.reply_to
                where message_id = set_attrs.message_id;
        end if;
        if sent_date is not null then
            update acs_messages set sent_date = set_attrs.sent_date
                where message_id = set_attrs.message_id;
        end if;
        if sender is not null then
            update acs_messages set sender = set_attrs.sender
                where message_id = set_attrs.message_id;
        end if;

        -- modify the parts that are in cr_revisions
        if title is not null or mime_type is not null then
            select live_revision into v_revision_id
                from cr_items where item_id = set_attrs.message_id
                for update;
            if title is not null then
                update cr_revisions set title = set_attrs.title
                    where revision_id = v_revision_id;
            end if;
            if mime_type is not null then
                update cr_revisions set mime_type = set_attrs.mime_type
                    where revision_id = v_revision_id;
            end if;
        end if;

        -- modify the context_id is acs_objects

        if context_id is not null then
            update acs_objects set context_id = set_attrs.context_id
                where object_id = set_attrs.message_id;
        end if;

    end set_attrs;

    procedure set_status (
        message_id in bboard_forum_message_map.message_id%TYPE,
        forum_id   in bboard_forum_message_map.forum_id%TYPE,
        status     in bboard_forum_message_map.status%TYPE
    )
    is
    begin
        if message_p(message_id) = 'f'
                or bboard_forum.forum_p(forum_id) = 'f' then
            return;
        end if;
        delete from bboard_forum_message_map
            where message_id = set_status.message_id
                and forum_id = set_status.forum_id;
        if status is not null then
            insert into bboard_forum_message_map
                    (forum_id, message_id, status)
                values (set_status.forum_id, set_status.message_id,
                    set_status.status);
        end if;
    end set_status;

    procedure add_category (
        message_id  in bboard_category_message_map.message_id%TYPE,
        category_id in bboard_category_message_map.category_id%TYPE
    )
    is
    begin
        insert into bboard_category_message_map (message_id, category_id)
            values (add_category.message_id, add_category.category_id);
    end add_category;

    procedure remove_category (
        message_id  in bboard_category_message_map.message_id%TYPE,
        category_id in bboard_category_message_map.category_id%TYPE
    )
    is
    begin
        delete from bboard_category_message_map
            where category_id = remove_category.category_id
              and message_id = remove_category.message_id;
    end remove_category;

    procedure clear_categories (
        message_id in bboard_category_message_map.message_id%TYPE
    )
    is
    begin
        delete from bboard_category_message_map
            where message_id = clear_categories.message_id;
    end clear_categories;

    procedure subscribe (
        thread_id     in bboard_thread_subscribers.thread_id%TYPE,
        subscriber_id in bboard_thread_subscribers.subscriber_id%TYPE
    )
    is
    begin
        insert into bboard_thread_subscribers (thread_id, subscriber_id)
            values (thread_id, subscriber_id);
    end;

    function name (
        message_id      in acs_objects.object_id%TYPE
    ) return varchar2
    is
        v_message_name   bboard_messages_all.title%TYPE;
    begin
        select title into v_message_name
            from bboard_messages_all
            where message_id = name.message_id;
        return v_message_name;
    end name;

    procedure remove_thread (
        thread_id    in bboard_messages_all.message_id%TYPE
    )
    is
	cursor messages_children is
	   select object_id as child_id, object_type
	       from acs_objects
               where context_id in (select message_id 
                                       from acs_messages
                                       connect by prior message_id = reply_to
                                       start with message_id = thread_id);

        cursor messages is
	   select message_id
	       from acs_messages
	       connect by prior message_id = reply_to
	       start with message_id = thread_id;

        image_p	     number;
    begin
	for child_val in messages_children loop
	    if child_val.object_type = 'acs_message' then
	       acs_message.delete(child_val.child_id);
	    elsif child_val.object_type = 'content_item' then
		select count(*) into image_p
		    from images
                    where image_id = child_val.child_id;
                if image_p = 1 then
                    acs_message.delete_image(child_val.child_id);
                else
                    acs_message.delete_file(child_val.child_id);
                end if;
           end if;
       end loop;

       for message_val in messages loop
           acs_message.delete(message_val.message_id);
       end loop;

    end remove_thread;

    procedure remove (
        message_id    in bboard_messages_all.message_id%TYPE
    )
    is
	cursor messages_children is
	   select object_id as child_id, object_type
	       from acs_objects
               where context_id = message_id;
        image_p	     number;
    begin
	for child_val in messages_children loop
	    if child_val.object_type = 'acs_message' then
	       acs_message.delete(child_val.child_id);
	    elsif child_val.object_type = 'content_item' then
		select count(*) into image_p
		    from images
                    where image_id = child_val.child_id;
                if image_p = 1 then
                    acs_message.delete_image(child_val.child_id);
                else
                    acs_message.delete_file(child_val.child_id);
                end if;
           end if;
       end loop;

       acs_message.delete(message_id);
    end remove;

end bboard_message;
/
show errors
