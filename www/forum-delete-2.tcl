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
    Presents confirmation screen for deleting a forum.

    @author Anukul Kapoor (akk@arsdigita.com)
    @creation-date 2000-30-11
    @cvs-id $Id$
} {
    forum_id:integer,notnull,bboard_forum_id
} -properties {
    forum_id:onevalue
    short_name:onevalue
    charter:onevalue
}

set user_id [ad_verify_and_get_user_id]

ad_require_permission $forum_id admin

# postgresql can't do all this in a transaction

if {[db_type] == "postgresql"} {
    db_dml messages_delete ""
    bboard_garbage_collect
    db_exec_plsql categories_delete ""
    db_dml permissions_delete ""
    db_exec_plsql forum_delete ""
} else { 
    db_transaction {
	db_dml messages_delete ""
	bboard_garbage_collect
	db_exec_plsql categories_delete ""
	db_dml permissions_delete ""
	db_exec_plsql forum_delete ""
    }
}

ad_returnredirect ""
