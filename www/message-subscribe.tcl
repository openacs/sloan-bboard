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

    Subscribe the current user to a given message thread.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-10-28
    @cvs-id $Id$

} {
    forum_id:integer,notnull,bboard_forum_id
    message_id:integer,notnull,acs_message_id
}

# Not strictly right
ad_require_permission $forum_id bboard_create_message

catch {
    bboard_subscribe_thread \
	-thread_id $message_id -subscriber_id [ad_verify_and_get_user_id]
}

ad_returnredirect "[bboard_message_page]?forum_id=$forum_id&message_id=$message_id"
