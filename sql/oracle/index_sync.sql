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

-- Resync the interMedia index every hour.

DECLARE
  v_job number;
BEGIN 
  dbms_job.submit(v_job, 
                  'ctx_ddl.sync_index(''cr_rev_content_index'');', 
                  interval => 'sysdate + 1/24');
END;
/
show errors
