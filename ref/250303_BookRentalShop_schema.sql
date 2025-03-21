-- bookrentalshop
drop tablespace bookrentalshop
including contents and datafiles;

create tablespace bookrentalshop
datafile '/u01/app/oracle/oradata/XE/bookrentalshop.dbf' size 100m
autoextend on NEXT 5m;

-- 사용자 추가
-- drop user bookuser cascade;

create user bookuser identified by 12345
default tablespace bookrentalshop
temporary tablespace temp
quota unlimited on bookrentalshop
quota unlimited on users;

-- 권한 설정
grant connect, resource to bookuser;

-- 시퀀스 생성
CREATE SEQUENCE SEQ_BOOKS
  INCREMENT BY 1  -- 숫자가 1씩 증가
  START WITH 60;   -- 1부터 시작
  
CREATE SEQUENCE SEQ_MEMBERS
  INCREMENT BY 1  -- 숫자가 1씩 증가
  START WITH 24;  

CREATE SEQUENCE SEQ_RENTAL
  INCREMENT BY 1  -- 숫자가 1씩 증가
  START WITH 15;  


-- 삭제 
DROP TABLE rentaltbl purge;
DROP TABLE membertbl purge;
DROP TABLE bookstbl purge;
DROP TABLE divtbl purge;

-- 생성
CREATE TABLE divtbl (
  Division char(4) PRIMARY KEY,
  Names varchar2(45) DEFAULT NULL
);

CREATE TABLE bookstbl (
  Idx INTEGER NOT NULL,
  Author varchar2(45) DEFAULT NULL,
  Division char(4) NOT NULL,
  Names varchar2(100) DEFAULT NULL,
  ReleaseDate date DEFAULT NULL,
  ISBN varchar2(200) DEFAULT NULL,
  Price INTEGER DEFAULT NULL,
  PRIMARY KEY (Idx),
  FOREIGN KEY (Division) REFERENCES divtbl (Division)
);

CREATE TABLE membertbl (
  Idx INTEGER NOT NULL,
  Names varchar2(45) NOT NULL,
  Levels char(1) DEFAULT NULL,
  Addr varchar2(100) DEFAULT NULL,
  Mobile varchar2(13) DEFAULT NULL,
  Email varchar2(50) DEFAULT NULL,
  PRIMARY KEY (Idx)
);

CREATE TABLE rentaltbl (
  Idx INTEGER NOT NULL,
  memberIdx INTEGER NOT NULL,
  bookIdx INTEGER NOT NULL,
  rentalDate date DEFAULT NULL,
  returnDate date DEFAULT NULL,
  PRIMARY KEY (Idx),
  FOREIGN KEY (bookIdx) REFERENCES bookstbl (Idx),
  FOREIGN KEY (memberIdx) REFERENCES membertbl (Idx)
);

COMMIT;

