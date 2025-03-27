import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import QDate, Qt
from PyQt5 import QtWidgets, uic
import cx_Oracle as oci

# DB 접속 정보
sid = 'XE'
host = '210.119.14.71'
port = 1521
username = 'attendance'
password = '12345'


class CustomCalendar(QCalendarWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.symbols = {} 
        self.setVerticalHeaderFormat(QCalendarWidget.NoVerticalHeader)  # 주 번호 숨기기
        self.load_attendance_data() 

    def load_attendance_data(self):
        try:
            conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
            cursor = conn.cursor()

            query = '''
                SELECT ATD_DATE, STATUS 
                FROM ATTENDANCE.ATD 
                WHERE S_NO = 1 
                AND EXTRACT(MONTH FROM ATD_DATE) = 2
            '''
            cursor.execute(query)
            rows = cursor.fetchall()

            # 출석 상태를 달력 기호로 변환
            status_map = {'P': 'O', 'L': '△', 'A': 'X'}
            for date, status in rows:
                qdate = QDate(date.year, date.month, date.day)
                self.symbols[qdate] = status_map.get(status, "")

        except Exception as e:
            print("데이터베이스 오류:", e)
        finally:
            cursor.close()
            conn.close()

    def paintCell(self, painter, rect, date):
        super().paintCell(painter, rect, date)

        if date in self.symbols:
            painter.setFont(QFont("Arial", 20))
            painter.drawText(rect, Qt.AlignCenter, self.symbols[date])


class AttendanceApp(QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('./miniproject01/출석관리,통계.ui', self)


        old_calendar = self.findChild(QCalendarWidget, "calendarWidget")
        if old_calendar:
            self.custom_calendar = CustomCalendar(self)
            self.custom_calendar.setGeometry(old_calendar.geometry()) 
            self.custom_calendar.setObjectName("calendarWidget")

            layout = old_calendar.parentWidget().layout() 
            if layout:
                layout.replaceWidget(old_calendar, self.custom_calendar)
            old_calendar.deleteLater()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = AttendanceApp()
    window.show()
    sys.exit(app.exec_())
