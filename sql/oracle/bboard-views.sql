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

