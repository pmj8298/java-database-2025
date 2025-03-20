# Oracle Student 연동 앱
# CRUD 데이터베이스 DML(SELECT,INSERT,UPDATE,DELETE)
## CREATE(INSERT), REQUEST(SELECT), UPDATE,(UPDATE) DELETE(DELETE)
import sys 
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5 import QtGui, QtWidgets, uic

# Oracle 모듈
import cx_Oracle as oci

# DB 연결 설정
sid = 'XE'
host = '127.0.0.1'
port = 1521
username = 'madang'
password = 'madang'

class MainWindow(QMainWindow):
    def __init__(self): 
        super(MainWindow, self).__init__()
        self.initUI()
        self.loadData()

    def initUI(self):
        uic.loadUi('./toyproject/studentdb.ui', self)
        self.setWindowTitle('학생정보맵')
        self.setWindowIcon(QIcon('./image/databases.png'))

        # 버튼 이벤트 추가
        self.btn_add.clicked.connect(self.btnAddClick)
        self.btn_mod.clicked.connect(self.btnMpdClick)
        self.btn_del.clicked.connect(self.btnDelClick)
        self.show()

    def btnAddClick(self):
        # print('추가 버튼 클릭')
        std_name    = self.input_std_name.text() # 아래에 있는 std_name과 다른 변수임
        stg_mobile  = self.input_std_mobile.text()
        std_regyear = self.input_std_regyear.text()
        print(std_name,stg_mobile,std_regyear)

        # 입력 검증 필수(Validation Check)
        if std_name == '' or std_regyear == '':
            QMessageBox.warning(self, '경고','학생이름 또는 입학년도는 필수입니다!')
            return # 함수를 탈출
        else:
            print('DB 입력 진행!')
            values = (std_name,stg_mobile,std_regyear) # 변수 값 3개를 튜플변수 담고
            self.addData(values) # 튜플을 파라미터로 전달

    def btnMpdClick(self):
        print('수정 버튼 클릭')
    def btnDelClick(self):
        print('삭제 버튼 클릭')

    def makeTable(self, lst_student):
        self.tblStudent.setColumnCount(4)
        self.tblStudent.setRowCount(len(lst_student)) # 커서에 들어있는 데이터 길이만큼 row 생성
        self.tblStudent.setHorizontalHeaderLabels(['학생번호','학생이름','핸드폰','입학년도'])

        # 전달받은 cursor 를 반복문으로 테이블위젯에 뿌리는 작업
        for i, (std_id, std_name, stg_mobile, std_regyear) in enumerate(lst_student):
            self.tblStudent.setItem(i,0,QTableWidgetItem(str(std_id))) # oracle number 타입은 뿌릴때 str()로 형변환 필요
            self.tblStudent.setItem(i,1,QTableWidgetItem(std_name))
            self.tblStudent.setItem(i,2,QTableWidgetItem(stg_mobile))
            self.tblStudent.setItem(i,3,QTableWidgetItem(str(std_regyear)))

    # R(SELECT)
    def loadData(self):
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        query = '''SELECT std_id, std_name
                    , stg_mobile, std_regyear 
                    FROM students'''
        cursor.execute(query)

        #for i, item in enumerate(cursor, start=1):
            # print(item) 
        # for i, (std_id, std_name, stg_mobile, std_regyear) in enumerate(cursor, start=1):
        #     print(std_id, std_name, stg_mobile, std_regyear)
        # self.makeTable(cursor)
        lst_student = []  # 리스트 생성
        for _, item in enumerate(cursor):
            lst_student.append(item)

        self.makeTable(lst_student) # 새로 생성한 리스트를 파라미터로 전달

        cursor.close()
        conn.close()

    # C(INSERT)
    def addData(self, tuples):
        conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
        cursor = conn.cursor()

        try:
            conn.begin() # BEGIN TRANSACTION 트랜잭션 시작

            # 쿼리작성
            query = '''
                    INSERT INTO MADANG.STUDENTS(std_id, std_name, stg_mobile, std_regyear)
                    VALUES(seq_student.nextval, :v_std_name, :v_stg_mobile, :v_std_regyear)
                    '''
            cursor.execute(query, tuples) # query에 들어가는 동적변수 3개는 뒤의 tuples 순서대로 매핑시켜줌

            conn.commit() # DB commit 동일 기능
            last_id = cursor.lastrowid # seq_student.currval
            print(last_id)
            # return True # DB 입력성공!
        except Exception as e:
            print(e)
            conn.rollback() # DB rollback 동일 기능
        finally:
            cursor.close()
            conn.close()


if __name__ == '__main__':
    app = QApplication(sys.argv) 
    win = MainWindow() 
    app.exec_()
