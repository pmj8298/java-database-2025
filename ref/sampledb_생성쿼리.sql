-- 테이블 스페이스 조회
SELECT * FROM dba_data_files;

drop tablespace sampledb
including contents and datafiles ;

CREATE TABLESPACE sampledb DATAFILE '/u01/app/oracle/oradata/XE/sampledb.dbf' SIZE 100M
autoextend ON NEXT 5M;

drop user sampleuser cascade;

create user sampleuser identified by 12345
default tablespace sampledb
temporary tablespace temp
quota unlimited on sampledb
quota unlimited on users;

grant connect , resource to sampleuser;

COMMIT;
