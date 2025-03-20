# Oracle 콘솔 연동 예제
# 모듈설치
# pip install cx_Oracle
import cx_Oracle as oci

# DB 연결 설정변수 선언
sid = 'XE'
host = '127.0.0.1' # localhoat와 동일
# DB서버가 외부에 있다면 -> 호스트가 포함된 도메인 주소나 ip를 넣어야됨
port = 1521
username = 'madang'
password = 'madang'

# DB 연결 시작
conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
cursor = conn.cursor() # DB 커서와 동일한 역할을 하는 개체

query = 'SELECT* FROM students' # 파이썬에서 쿼리호출 시에는 ; 쓰지 않기
cursor.execute(query)

# 불러온 데이터처리
for i, item in enumerate(cursor, start=1):
    print(item)

cursor.close()
conn.close()
# DB는 연결하면 마지막에 close()로 닫아줘야함, 파일도 오픈하면 마지막에 닫아줘야함
# cx_Oracle.DatabaseError: DPI-1047: Cannot locate a 64-bit Oracle Client library: "The specified module could not be found". 
# See https://cx-oracle.readthedocs.io/en/latest/user_guide/installation.html for help