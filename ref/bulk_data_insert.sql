drop table sample_t purge;
create table sample_t 
(id1 number, id2 number, name varchar2(10),  
date1 varchar2(8), date2 varchar2(8), date3 date, 
phone varchar2(13), price number, qty number, 
test1 number,  test2 varchar2(5), test3 varchar2(4)
)
nologging;


DECLARE
TYPE tbl_ins IS TABLE OF sample_t%ROWTYPE INDEX BY BINARY_INTEGER;
w_ins tbl_ins;
BEGIN
FOR i IN 1..1000000 LOOP 
   w_ins(i).id1   := i;
   w_ins(i).id2   := i||ceil(dbms_random.value(1, 10000000));
   w_ins(i).name  := dbms_random.string('x',5);
   w_ins(i).date1 := round(dbms_random.value(2010,2021))||to_char(round(dbms_random.value(1,12)), 'FM09')||to_char( round(dbms_random.value(1,28)), 'FM09');
   w_ins(i).date2 := '2021'||to_char(round(dbms_random.value(1,12)) , 'FM09')||to_char(round(dbms_random.value(1,28)), 'FM09');
   w_ins(i).date3 := to_date(round(dbms_random.value(2010,2021))||'-'||round(dbms_random.value(1,12))||'-'||round(dbms_random.value(1,28))||' '||round(dbms_random.value(1, 23))||':'||round(dbms_random.value(0, 59))||':'||round(dbms_random.value(0, 59)), 'YYYY-MM-DD HH24:MI:SS');
   w_ins(i).phone := '010-'||ceil(dbms_random.value(1000, 9999))||'-'||ceil(dbms_random.value(1000, 9999));
   w_ins(i).price := ceil(dbms_random.value(1, 10))*1000;
   w_ins(i).qty   := ceil(dbms_random.value(1, 10));
   w_ins(i).test1 := 1234;
   w_ins(i).test2 := 'SQLP';
   w_ins(i).test3 := 'A'||ceil(dbms_random.value(100, 999));
END LOOP;
FORALL i in 1..1000000 INSERT INTO sample_t VALUES w_ins(i);
   COMMIT;
END;
/

SELECT count(*) FROM sample_t;

--TRUNCATE TABLE sample_t;

COMMIT;