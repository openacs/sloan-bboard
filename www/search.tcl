#
#  Copyright (C) 2001, 2002 OpenForce, Inc.
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {
    
    Displays search results from a user query.

    @author Anukul Kapoor <akk@arsdigita.com>
    @creation-date 2000-10-26
    @cvs-id $Id$
} {
    query:notnull
    forum_id:integer,notnull,bboard_forum_id
} -properties { 
    query:onevalue
    results:multirow
    forum_id:onevalue
    context_bard:onevalue
    title:onevalue
}

set user_id [ad_conn user_id]

set title "Search Results for \"$query\""
set context_bar [list "Search"]

set package_id [ad_conn package_id] 

ad_require_permission $forum_id bboard_read_forum

# convert query string to im happy query string

db_1row im_convert_query {
    select bboard_im_convert(:query) as query from dual
}

# if you're not running context, you'll need to run this by hand
# alter index cr_rev_content_index rebuild online parameters('sync memory 45M');

db_multirow results bboard_search {
	select score(10) as the_score, message_id,
        m.title, m.num_replies, to_char(m.sent_date,'MM/DD/YYYY') as sent_date,
	    p.first_names||' '||p.last_name as full_name
	  from bboard_messages_all m, persons p, bboard_forums f
	  where contains(content, :query, 10) > 0
	    and m.sender = p.person_id
	    and m.forum_id = :forum_id
	    and f.forum_id = m.forum_id
	    and f.bboard_id = :package_id
	  order by score(10) desc
}

ad_return_template
