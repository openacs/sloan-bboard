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

    Displays a list of forums on the site

    @author John Prevost (jmp@arsdigita.com)
    @creation-date 2000-08-29
    @cvs-id $Id$
} {
} -properties {
  context_bar:onevalue
  package_id:onevalue
  user_id:onevalue
  forums:multirow
}

set package_id [ad_conn package_id]

set context_bar [list Bboards]

set user_id [ad_verify_and_get_user_id]

set admin_p [ad_permission_p $package_id admin]

db_multirow forums forums_select {
    select forum_id, short_name, moderated_p, charter 
      from bboard_forums f
      where bboard_id = :package_id
        and acs_permission.permission_p(forum_id,:user_id,'bboard_read_forum') = 't'
    order by short_name
}

set bboard_forum_name [bboard_forum_name]
set bboard_forum_name_plural [bboard_forum_name_plural]

ad_return_template
