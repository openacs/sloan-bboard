--
-- packages/bboard/sql/bboard-views.sql
--
-- @author Anukul Kapoor <akk@arsdigita.com>
-- @author John Prevost <jmp@arsdigita.com>
-- @creation-date 2001-02-05
-- @cvs-id $Id$
--



create or replace view bboard_messages_all as
    select m.message_id, m.reply_to, m.sent_date, m.sender,
           m.title, m.mime_type, m.content, f.forum_id, f.status,
           (select count(1) from acs_messages m2
               where m2.message_id in (select mf.message_id 
                                          from bboard_forum_message_map mf
                                          where mf.forum_id = f.forum_id)
               start with m2.message_id = m.message_id
               connect by m2.reply_to = prior m2.message_id) as num_replies,
           (select max(sent_date) from acs_messages m2
               where m2.message_id in (select mf.message_id 
                                          from bboard_forum_message_map mf
                                          where mf.forum_id = f.forum_id)
               start with m2.message_id = m.message_id
               connect by m2.reply_to = prior m2.message_id) as last_reply_date
        from acs_messages_all m, bboard_forum_message_map f
        where m.message_id = f.message_id;

create or replace view bboard_messages_by_category as
    select msg.*, cat.category_id
        from bboard_messages_all msg, bboard_category_message_map cat
        where msg.message_id = cat.message_id(+);

