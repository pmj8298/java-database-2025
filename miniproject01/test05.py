import cx_Oracle as oci
from faker import Faker
import random

fake = Faker('ko-KR')

sid = 'XE'
host = '210.119.14.71'
port = 1521
username = 'attendance'
password = '12345'

def loadSdata():
    conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
    cursor = conn.cursor()

    query = '''SELECT S_NO, S_ID, S_PW, S_NAME, S_BIRTH, S_TEL, S_ADDR, CLASS_NO 
            FROM ATTENDANCE.STUDENT'''
    cursor.execute(query)

    lst_student = [item for item in cursor]  

    cursor.close()
    conn.close()

    return lst_student


if __name__ == "__main__":
    student_data = loadSdata()
    print("loadSdata 실행 결과:", student_data)


   





