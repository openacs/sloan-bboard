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

    Edit a category

    @author John Prevost <jprevost@arsdigita.com>
    @creation-date 2000-09-07
    @cvs-id $Id$

    @param category_id The ID of the category to update
    @param short_name  The short name of the forum
    @param forum_id    The forum ID the category is in (to redirect back to)

} {
    category_id:integer,notnull,bboard_category_id
    short_name:notnull,trim
    forum_id:integer,notnull,bboard_forum_id
}

ad_require_permission $category_id bboard_write_category

db_transaction {
    bboard_category_set -category_id $category_id -short_name $short_name
}
# on error ...

ad_returnredirect "forum?[export_url_vars forum_id]"
