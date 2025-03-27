import cx_Oracle as oci
from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker('ko-KR')

sid = 'XE'
host = '210.119.14.71'
port = 1521
username = 'attendance'
password = '12345'
                                                                                                                                                                                       
def generate_date_of_birth():
    year = random.choice([2020, 2021, 2022])
    month = random.randint(1, 12)
    day = random.randint(1, 28)
    return f"{year}-{month:02d}-{day:02d}"

def random_time(current_date):
    status = random.choice(['P', 'L', 'A'])

    if status == 'P':
        time = current_date.replace(hour=random.randint(7, 8), minute=random.randint(0, 59))
    elif status == 'L':
        time = current_date.replace(hour=random.randint(9, 12), minute=random.randint(0, 59))
    else:
        time = current_date.replace(hour=random.randint(13, 23), minute=random.randint(0, 59))

    return time, status

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
                VALUES(ATTENDANCE.class_class_no_seq.nextval, :1, NULL)
            '''

            data_list = [(f"{i}반",) for i in range(1, 11)]

            cursor.executemany(query, data_list)
            conn.commit()

            print("CLASS 테이블에 데이터 삽입 완료")

            cursor.execute('SELECT class_no FROM ATTENDANCE.CLASS ORDER BY class_no')
            class_no_list = [row[0] for row in cursor.fetchall()]

            print("삽입된 CLASS_NO 목록:", class_no_list)

        except Exception as e:
            print("addCdata 오류 발생:", e)
            conn.rollback()
        finally:
            cursor.close()
            conn.close()

        return class_no_list

    def addTdata(self, class_no_list):
        print("addTdata 함수 실행됨")

        isSucceed = False
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        try:
            conn.begin()

            query = '''
                INSERT INTO ATTENDANCE.TEACHER (T_NO, T_ID, T_PW, T_NAME, T_TEL, CLASS_NO) 
                VALUES(ATTENDANCE.teacher_t_no_seq.nextval, :1, :2, :3, :4, :5)
            '''

            data_list = [(fake.user_name(), fake.password(), fake.name(), fake.phone_number(), class_no) for class_no in class_no_list]

            cursor.executemany(query, data_list)
            conn.commit()

            print("TEACHER 테이블에 데이터 삽입 완료")

            cursor.execute('SELECT T_NO, CLASS_NO FROM ATTENDANCE.TEACHER')
            teacher_no_list = cursor.fetchall()

            print("삽입된 TEACHER 목록:", teacher_no_list)

            update_query = '''
                UPDATE ATTENDANCE.CLASS 
                SET T_NO = :1 
                WHERE CLASS_NO = :2 AND T_NO IS NULL
            '''
            cursor.executemany(update_query, teacher_no_list)
            conn.commit()

            print("CLASS 테이블의 T_NO 업데이트 완료")

            isSucceed = True

        except Exception as e:
            print("addTdata 오류 발생:", e)
            conn.rollback()
        finally:
            cursor.close()
            conn.close()

        return isSucceed

    def addSdata(self, class_no_list):
        print("addSdata 함수 실행됨")

        isSucceed = False
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        try:
            conn.begin()

            query = '''
                INSERT INTO ATTENDANCE.STUDENT (S_NO, S_ID, S_PW, S_NAME, S_BIRTH, S_TEL, S_ADDR, CLASS_NO) 
                VALUES(ATTENDANCE.student_s_no_seq.nextval, :1, :2, :3, TO_DATE(:4, 'YYYY-MM-DD'), :5, :6, :7)
            '''

            student_data = [
                (str(fake.random_number(digits=6)), fake.password(), fake.name(), generate_date_of_birth(), fake.phone_number(), fake.address(), class_no)
                for class_no in class_no_list for _ in range(random.randint(25, 30))
            ]

            cursor.executemany(query, student_data)
            conn.commit()

            print(f"STUDENT 테이블에 {len(student_data)}개 데이터 삽입 완료")

            isSucceed = True

        except Exception as e:
            print("addSdata 오류 발생:", e)
            conn.rollback()
        finally:
            cursor.close()
            conn.close()

        return isSucceed

    def addAdata(self, class_no_list):
        print("addAdata 함수 실행됨")

        isSucceed = False
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        try:
            conn.begin()

            cursor.execute("SELECT S_NO, CLASS_NO FROM ATTENDANCE.STUDENT")
            student_list = cursor.fetchall()

            cursor.execute("SELECT T_NO, CLASS_NO FROM ATTENDANCE.TEACHER")
            teacher_dict = {row[1]: row[0] for row in cursor.fetchall()}  

            attendance_data = []

            start_date = datetime(2025, 2, 1)  
            end_date = datetime(2025, 2, 28)  

            current_date = start_date
            while current_date <= end_date:
                if current_date.weekday() < 5:
                    for s_no, class_no in student_list:
                        if class_no in teacher_dict:  
                            atd_time, status = random_time(current_date) 

                            attendance_data.append((s_no, current_date.strftime('%Y-%m-%d'), atd_time.strftime('%Y-%m-%d %H:%M:%S'), teacher_dict[class_no], status))

                current_date += timedelta(days=1) 

            query = '''
                INSERT INTO ATTENDANCE.ATD (ATD_no, S_NO, ATD_DATE, ATD_TIME, T_NO, STATUS) 
                VALUES(ATTENDANCE.atd_no_seq.nextval, :1, TO_DATE(:2, 'YYYY-MM-DD'), TO_DATE(:3, 'YYYY-MM-DD HH24:MI:SS'), :4, :5)
            '''

            cursor.executemany(query, attendance_data)
            conn.commit()

            print(f"ATD 테이블에 {len(attendance_data)}개 출석 데이터 삽입 완료 (2월 한 달간, 월~금만 기록)")

            isSucceed = True

        except Exception as e:
            print("addAdata 오류 발생:", e)
            conn.rollback()
        finally:
            cursor.close()
            conn.close()

        return isSucceed




if __name__ == "__main__":
    add_data = AddData()

    class_no_list = add_data.addCdata()
    if class_no_list:
        add_data.addTdata(class_no_list)
        add_data.addSdata(class_no_list)
        add_data.addAdata(class_no_list)
    else:
        print("CLASS 테이블 데이터 삽입 실패")