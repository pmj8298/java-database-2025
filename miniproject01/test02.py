import cx_Oracle as oci
from faker import Faker
import random

fake = Faker('ko-KR')

sid = 'XE'
host = '127.0.0.1'
port = 1521
username = 'attendance'
password = '12345'

def generate_date_of_birth(year: int):
    month = random.randint(1, 12)  
    day = random.randint(1, 28)    
    return f"{year}-{month:02d}-{day:02d}"

class AddData:
    def addCdata(self):
        print("addCdata 함수 실행됨")

        isSucceed = False
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        class_no_list = []

        try:
            conn.begin() 

            query = '''
                    INSERT INTO ATTENDANCE.CLASS(CLASS_NO, CLASS_NAME, T_NO)
                    VALUES(class_class_no_seq.nextval, :1, :2)
                    '''
            
            # data_list = [(fake.pyint(min_value=1, max_value=10), fake.pyint(min_value=1, max_value=100)) for _ in range(10)]
            data_list = [(fake.pyint(min_value=1, max_value=10), fake.pyint(min_value=1, max_value=100))]

            print("삽입할 데이터 목록:", data_list)  
            cursor.executemany(query, data_list)  

            conn.commit()  
            print("10개 데이터 삽입 완료")
            isSucceed = True

            cursor.execute('SELECT class_class_no_seq.currval FROM dual')
            for _ in range(10): 
                class_no = cursor.fetchone()
                if class_no: 
                    class_no_list.append(class_no[0])

            print("삽입된 CLASS_NO들:", class_no_list)
            return class_no_list  

        except Exception as e:
            print("오류 발생:", e)
            conn.rollback()  # DB rollback
            isSucceed = False
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

            query = '''
                    INSERT INTO ATTENDANCE.TEACHER (T_NO, T_ID, T_PW, T_NAME, T_TEL, CLASS_NO) 
                    VALUES(teacher_t_no_seq.nextval, :1, :2, :3, :4, :5)
                    '''

            data_list = [(fake.user_name(), fake.password(), fake.name(), fake.phone_number(), class_no) for class_no in class_no_list]

            print("삽입할 데이터 목록:", data_list)  
            cursor.executemany(query, data_list)  

            conn.commit()  
            print("10개 데이터 삽입 완료")
            isSucceed = True

        except Exception as e:
            print("오류 발생:", e)
            conn.rollback()  # DB rollback
            isSucceed = False
        finally:
            cursor.close()
            conn.close()

        return isSucceed  # 트랜잭션 여부를 리턴

    def addSdata(self, class_no_list):
        print("addSdata 함수 실행됨")

        isSucceed = False
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        try:
            conn.begin()

            query = '''
                    INSERT INTO ATTENDANCE.STUDENT (S_NO, S_ID, S_PW, S_NAME, S_BIRTH, S_TEL, S_ADDR, CLASS_NO) 
                    VALUES(student_s_no_seq.nextval, :1, :2, :3, TO_DATE(:4, 'YYYY-MM-DD'), :5, :6, :7)
                    '''
            birth_year = 2022
            
            student_data = []
            for class_no in class_no_list:
                for _ in range(30):  
                    student_data.append((
                        str(fake.random_number(digits=6)),  
                        fake.password(),                    
                        fake.name(),                        
                        generate_date_of_birth(birth_year), 
                        fake.phone_number(),                
                        fake.address(),                     
                        class_no                            
                    ))

            print("삽입할 학생 데이터 목록:", student_data)
            cursor.executemany(query, student_data)  

            conn.commit()  
            print("학생 데이터 30개 삽입 완료 (각 반에 30명씩 배정)")
            isSucceed = True

        except Exception as e:
            print("오류 발생:", e)
            conn.rollback()  
            isSucceed = False
        finally:
            cursor.close()
            conn.close()

        return isSucceed  # 트랜잭션 여부를 리턴


if __name__ == "__main__":
    add_data = AddData()  

    class_no_list = add_data.addCdata()  
    print("addCdata 실행 후 받은 CLASS_NO 목록:", class_no_list)

    if class_no_list:
        result = add_data.addTdata(class_no_list)  
        print("addTdata 실행 결과:", result)

        result = add_data.addSdata(class_no_list)  
        print("addSdata 실행 결과:", result)
    else:
        print("class_no_list가 비어 있음.")





