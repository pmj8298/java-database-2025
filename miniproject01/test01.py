import cx_Oracle as oci
from faker import Faker

fake = Faker('ko-KR')

sid = 'XE'
host = '127.0.0.1'
port = 1521
username = 'attendance'
password = '12345'

# conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')

# try:
#     conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
#     cursor = conn.cursor()

#     # 현재 사용자 확인 쿼리 실행
#     cursor.execute("SELECT sys_context('USERENV', 'CURRENT_USER') FROM dual")
#     user = cursor.fetchone()

#     print("데이터베이스 연결 성공! 현재 사용자:", user[0])

#     cursor.close()
#     conn.close()
# except oci.DatabaseError as e:
#     print("데이터베이스 연결 실패:", e)

class AddData:
    def addCdata(self):
        print("addCdata 함수 실행됨")

        isSucceed = False
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        # class_name = fake.pyint(min_value=1, max_value=10)
        # t_no = fake.pyint(min_value=1, max_value=100)

#=========
        class_no_list = []
#=========

        try:
            conn.begin() 

            # 쿼리 작성
            query = '''
                    INSERT INTO ATTENDANCE.CLASS(CLASS_NO, CLASS_NAME, T_NO)
                    VALUES(class_class_no_seq.nextval, :1, :2)
                    '''
            
            # cursor.execute(query, (class_name, t_no))  # class_name을 동적으로 삽입

            # conn.commit()  # DB commit
            # class_no = cursor.lastrowid  # seq_student.currval
            # print("삽입된 데이터 ID:", class_no)
            # isSucceed = True  # 트랜잭션 성공

            data_list = [(fake.pyint(min_value=1, max_value=10), fake.pyint(min_value=1, max_value=100)) for _ in range(10)]

            print("삽입할 데이터 목록:", data_list)  
            cursor.executemany(query, data_list)  

            conn.commit()  
            print("10개 데이터 삽입 완료")
            isSucceed = True
#============
            # cursor.execute("SELECT class_class_no_seq.currval FROM dual")
            # class_no = cursor.fetchone()[0]
            # class_no_list.append(class_no)
            for _ in range(10):  # 10개의 데이터를 삽입했으므로 10번 반복
                cursor.execute('SELECT class_class_no_seq.currval FROM dual')
                class_no = cursor.fetchone()[0]
                class_no_list.append(class_no)
            print("마지막 삽입된 CLASS_NO:", class_no)
            print("삽입된 CLASS_NO들:", class_no_list)
            # return class_no
            return class_no_list
        
#============

        except Exception as e:
            print("오류 발생:", e)
            conn.rollback()  # DB rollback
            isSucceed = False  # 트랜잭션 실패
        finally:
            cursor.close()
            conn.close()

        return isSucceed  # 트랜잭션 여부를 리턴
    

    def addTdata(self, class_no_list):
        print("addTdata 함수 실행됨")

        isSucceed = False
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        try:
            conn.begin() 

            # 쿼리 작성
            query = '''
                    INSERT INTO ATTENDANCE.TEACHER (T_NO, T_ID, T_PW, T_NAME, T_TEL, CLASS_NO) 
                    VALUES(teacher_t_no_seq.nextval, :1, :2, :3, :4, :5)
                    '''

            # data_list = [(fake.user_name(), fake.password(), fake.name(), fake.phone_number(), class_no) for _ in range(10)]
            data_list = [(fake.user_name(), fake.password(), fake.name(), fake.phone_number(), class_no) for class_no in class_no_list]

            print("삽입할 데이터 목록:", data_list)  
            cursor.executemany(query, data_list)  

            conn.commit()  
            print("10개 데이터 삽입 완료")
            isSucceed = True


        except Exception as e:
            print("오류 발생:", e)
            conn.rollback()  # DB rollback
            isSucceed = False  # 트랜잭션 실패
        finally:
            cursor.close()
            conn.close()

        return isSucceed  # 트랜잭션 여부를 리턴
    




if __name__ == "__main__":
    add_data = AddData()  
    # class_no = add_data.addCdata()
    # print("addCdata 실행 후 받은 CLASS_NO:", class_no)

    # result = add_data.addTdata(class_no)
    # print("addTdata 실행 결과:", result)

    class_no_list = add_data.addCdata()  
    print("addCdata 실행 후 받은 CLASS_NO 목록:", class_no_list)

    result = add_data.addTdata(class_no_list)  
    print("addTdata 실행 결과:", result)





