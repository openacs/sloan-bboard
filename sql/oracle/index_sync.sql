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