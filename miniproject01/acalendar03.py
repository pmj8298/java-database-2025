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
        self.setVerticalHeaderFormat(QCalendarWidget.NoVerticalHeader)
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
            # 출석 상태에 따라 색상 지정
            symbol = self.symbols[date]
            color_map = {'O': "blue", '△': "green", 'X': "red"}
            painter.setPen(QColor(color_map.get(symbol, "black")))  # 기본은 검은색

            # 폰트 크기 및 정렬 설정
            painter.setFont(QFont("Arial", 20, QFont.Bold))
            painter.drawText(rect, Qt.AlignCenter, symbol)  # 정중앙 배치


class AttendanceApp(QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('./miniproject01/출석관리,통계.ui', self)  # UI 파일 로드

        # 기존 UI에서 QCalendarWidget 찾기
        old_calendar = self.findChild(QCalendarWidget, "calendarWidget")
        if old_calendar:
            # 기존 QCalendarWidget을 CustomCalendar로 변경
            self.custom_calendar = CustomCalendar(self)
            self.custom_calendar.setGeometry(old_calendar.geometry())  # 위치 유지
            self.custom_calendar.setObjectName("calendarWidget")

            # 기존 달력 삭제 후 새 달력 추가
            layout = old_calendar.parentWidget().layout()  # 부모 레이아웃 가져오기
            if layout:
                layout.replaceWidget(old_calendar, self.custom_calendar)  # 위젯 교체
            old_calendar.deleteLater()  # 기존 달력 제거

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = AttendanceApp()
    window.show()
    sys.exit(app.exec_())
