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

    Delete a category

    @author John Prevost <jmp@arsdigita.com>
    @creation-date 2000-12-01
    @cvs-id $Id$

} {
    category_id:integer,notnull,bboard_category_id
}

ad_require_permission $category_id bboard_delete_category

db_1row forum_id {
    select forum_id from bboard_categories where category_id = :category_id
}

db_exec_plsql delete_category {
    begin
        bboard_category.delete (:category_id);
    end;
}

ad_returnredirect "forum?forum_id=$forum_id"
