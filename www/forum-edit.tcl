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

    Displays a form for editing a forum.

    @author John Prevost (jmp@arsdigita.com)
    @creation-date 2000-09-07
    @cvs-id $Id$

} {
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    context_bar:onevalue
    forum_id:onevalue
    title:onevalue
    action:onevalue
    submit_label:onevalue
    short_name:onevalue
    charter:onevalue
    moderated_p:onevalue
}

ad_require_permission $forum_id admin

db_1row forum_info {
    select short_name, charter, moderated_p from bboard_forums
      where forum_id = :forum_id
}

set bboard_forum_name [bboard_forum_name]

set context_bar [list "Edit a $bboard_forum_name"]
set title "Edit a $bboard_forum_name"
set action "forum-edit-2"
set submit_label "Save Changes"

set extra_footer "You can also <a href=\"forum-delete?forum_id=$forum_id\">delete this forum</a>."


ad_return_template "forum-entry"
