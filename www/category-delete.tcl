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

    Displays a confirmation of "do you really want to delete this category?"

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-12-01
    @cvs-id $Id$

} {
    category_id:integer,notnull,bboard_category_id
} -properties {
    context_bar:onevalue
    category_id:onevalue
    category_name:onevalue
    message_count:onevalue
}

ad_require_permission $category_id bboard_delete_category

db_1row forum_short_name_id {
    select f.short_name as forum_name, f.forum_id
        from bboard_forums f, bboard_categories c
        where c.category_id = :category_id
          and c.forum_id = f.forum_id
}

db_1row category_short_name {
    select short_name as category_name
        from bboard_categories
        where category_id = :category_id
}

db_1row category_message_count {
    select count(*) as message_count
        from bboard_category_message_map
        where category_id = :category_id
}

set context_bar [list [list "forum?[export_url_vars forum_id]" $forum_name] \
                      {"Delete Category"}]
