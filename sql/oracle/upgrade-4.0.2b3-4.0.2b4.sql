--
--  Copyright (C) 2001, 2002 OpenForce, Inc.
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- packages/bboard/sql/upgrade-4.0.2b3-4.0.2b4.sql
--
-- @author Anukul Kapoor <akk@arsdigita.com>
-- @creation-date 2001-01-15
-- @cvs-id $Id$
--

set feedback off

-- NOTE: this is only temporary until we figure out how
--       packages will register child types to an acs-message
declare
    v_exists	integer;
begin

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'content_revision'
      );
    end if;

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'image'
      );
    end if;

    select decode(count(*),0,0,1) into v_exists 
      from cr_type_children
      where parent_type = 'acs_message_revision'
      and child_type = 'content_revision';

    if v_exists = 0 then
      content_type.register_child_type (
          parent_type => 'acs_message_revision',
          child_type  => 'content_extlink'
      );
    end if;

end;
/
show errors
