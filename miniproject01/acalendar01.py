import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import QApplication, QCalendarWidget
from PyQt5.QtGui import QPainter, QFont
from PyQt5.QtCore import QDate
from PyQt5 import QtGui, QtWidgets, uic

import cx_Oracle as oci
sid = 'XE'
host = '210.119.14.71'
port = 1521
username = 'attendance'
password = '12345'


class CustomCalendar(QCalendarWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.symbols = {
            QDate.currentDate(): "🚩",
            QDate(2025, 3, 30): "O",
            QDate(2025, 4, 5): "X"
        }

    def paintCell(self, painter, rect, date):
        super().paintCell(painter, rect, date)

        if date in self.symbols:
            painter.setFont(QFont("Arial", 14))  # 폰트 설정
            painter.drawText(rect, 0x84, self.symbols[date])  # 가운데 정렬하여 표시

class AttendanceApp(QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('./miniproject01/출석관리,통계.ui', self)

        # 기존 UI에서 QCalendarWidget 찾기
        old_calendar = self.findChild(QCalendarWidget, "calendarWidget")  
        if old_calendar:
            # 기존 캘린더를 커스텀 캘린더로 변경
            self.custom_calendar = CustomCalendar(self)
            self.custom_calendar.setGeometry(old_calendar.geometry())
            self.custom_calendar.setObjectName("calendarWidget")
            old_calendar.deleteLater()  # 기존 위젯 제거
            self.layout().addWidget(self.custom_calendar) 

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = AttendanceApp()
    window.show()
    sys.exit(app.exec_())

