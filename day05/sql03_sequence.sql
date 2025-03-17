/*
 * 시퀀스, 자동 증가되는 값
 * */
-- 시퀀스 사용하지않는 주문 테이블
CREATE TABLE ORDER_NOSEQ(
	ORDER_IDX NUMBER        PRIMARY KEY,
	ORDER_NM  VARCHAR2(20)  NOT NULL,
	ORDER_PRD VARCHAR2(100) NOT NULL,
	QTY       NUMBER        DEFAULT 1	
);

-- 시퀀스 사용하는 주문 테이블
CREATE TABLE ORDER_SEQ(
	ORDER_IDX NUMBER        PRIMARY KEY,
	ORDER_NM  VARCHAR2(20)  NOT NULL,
	ORDER_PRD VARCHAR2(100) NOT NULL,
	QTY       NUMBER        DEFAULT 1	
);

COMMIT;

-- 시퀀스 생성
CREATE SEQUENCE S_order
INCREMENT BY 1
START WITH 1;

-- 시퀀스 없는 ORDER_NOSEQ
INSERT INTO ORDER_NOSEQ VALUES(1,'홍길동','망고',20);
INSERT INTO ORDER_NOSEQ VALUES(2,'홍길동','망고',10);
INSERT INTO ORDER_NOSEQ VALUES(3,'홍길순','블루베리',2);

-- 시퀀스 쓰면 OEDER_SEQ
INSERT INTO ORDER_SEQ VALUES(S_order.NEXTVAL,'홍길동','애플망고',10);
INSERT INTO ORDER_SEQ VALUES(S_order.NEXTVAL,'홍길동','망고',20);

COMMIT;

SELECT * FROM ORDER_SEQ;

-- 시퀀스 개체의 현재번호가 얼마인지 확인
SELECT S_order.CURRVAL FROM DUAL;

-- 시퀀스 삭제
--DROP SEQUENCE S_order;

COMMIT;
