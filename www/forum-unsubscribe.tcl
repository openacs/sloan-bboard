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

    Unsubscribe the current user from a given forum.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-10-28
    @cvs-id $Id$

} {
    forum_id:integer,notnull,bboard_forum_id
    {return_url ""}
    {sub_page ""}
}

catch {
    bboard_unsubscribe_forum \
	-forum_id $forum_id -subscriber_id [ad_conn user_id]
}

if {[empty_string_p $return_url]} {
    if [empty_string_p $sub_page] {
        ad_returnredirect "forum?forum_id=$forum_id"
    } else {
        ad_returnredirect "subscriptions"
    }
} else {
    ad_returnredirect $return_url
}
