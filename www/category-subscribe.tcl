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

    Unsubscribe the current user from a given category.

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-10-28
    @cvs-id $Id$

} {
    category_id:integer,notnull,bboard_category_id
}

db_1row category_forum {
    select forum_id from bboard_categories where category_id = :category_id
}

# Not strictly right
ad_require_permission $forum_id bboard_create_message

catch {
    bboard_subscribe_category \
	-category_id $category_id -subscriber_id [ad_verify_and_get_user_id]
}

ad_returnredirect "forum-by-category?forum_id=$forum_id&category_id=$category_id"


