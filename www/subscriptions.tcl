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
    This is the central interface for managing a user's subscriptions.

    @author Anukul Kapoor <akk@arsdigita.com>
    @creation-date 2001-03-27
    @cvs-id $Id$
} {
} -properties {
    forum_subs:multirow
    category_subs:multirow
    thread_subs:multirow
}

ad_maybe_redirect_for_registration

set package_id [ad_conn package_id]
set user_id [ad_verify_and_get_user_id]

# three sorts of subscriptions:
#  forums

db_multirow forum_subs get_forum_subs {
    select bfs.forum_id, short_name as name
      from bboard_forum_subscribers bfs, bboard_forums bf
      where bfs.forum_id = bf.forum_id
            and bfs.subscriber_id = :user_id
            and bf.bboard_id= :package_id
      order by forum_id asc
}

#  categories
db_multirow category_subs get_category_subs {
    select bcs.category_id, bc.short_name as name, bf.forum_id
      from bboard_category_subscribers bcs, bboard_categories bc, bboard_forums bf
      where bcs.category_id = bc.category_id
            and bcs.subscriber_id = :user_id
            and bc.forum_id = bf.forum_id
            and bf.bboard_id= :package_id
      order by category_id asc
}


#  threads

db_multirow thread_subs get_thread_subs {
    select thread_id, title as name, forum_id
      from bboard_thread_subscribers bts, bboard_messages_all bma, bboard_forums bf
      where bts.thread_id = bma.message_id
            and bts.subscriber_id = :user_id
            and bma.forum_id= bf.forum_id
            and bf.bboard_id= :package_id
      order by thread_id asc
}
