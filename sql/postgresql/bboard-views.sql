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

-- DRB: This view is several orders of magnitude faster than the old one
-- using "in".  It would be nice to avoid having two aggregate subselects
-- but there's no easy way to to do this.  

-- Also ... Postgres does seem to optimize away the two subselects that
-- calculate the number of replies and last reply date if the query 
-- using the view doesn't include those columns in its resultset.  So 
-- at the moment it does not appear necessary to create simpler views
-- with those stripped out.

create view bboard_messages_all as
    select m.message_id, m.reply_to, m.sent_date, m.sender,
           m.title, m.mime_type, m.content, f.forum_id, f.status,
           (select count(1) from acs_messages m2, bboard_forum_message_map mf
            where m2.message_id = mf.message_id 
              and m2.tree_sortkey between m.tree_sortkey and tree_right(m.tree_sortkey))
           as num_replies,
           (select max(sent_date) from acs_messages m2, bboard_forum_message_map mf
            where m2.message_id = mf.message_id 
              and m2.tree_sortkey between m.tree_sortkey and tree_right(m.tree_sortkey))
              as last_reply_date
    from acs_messages_all m, bboard_forum_message_map f
    where m.message_id = f.message_id;

create view bboard_messages_by_category as
    select msg.*, cat.category_id
    from bboard_messages_all msg left join bboard_category_message_map cat on (msg.message_id = cat.message_id);

