import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import QDate, Qt
from PyQt5 import uic
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
        self.parent = parent
        self.load_attendance_data()

    def load_attendance_data(self):
        try:
            conn = oci.connect(f'{username}/{password}@{host}:{port}/{sid}')
            cursor = conn.cursor()

            query = '''
                SELECT ATD_DATE, STATUS, TO_CHAR(ATD_TIME, 'HH24:MI') 
                FROM ATTENDANCE.ATD 
                WHERE S_NO = 1 
                AND EXTRACT(MONTH FROM ATD_DATE) = 2
            '''
            cursor.execute(query)
            rows = cursor.fetchall()

            status_map = {'P': 'O', 'L': '△', 'A': 'X'}

            count_data = {'P': 0, 'L': 0, 'A': 0}

            self.symbols.clear()

            for date, status, time in rows:
                print(f"DB에서 가져온 값: {date}, {status}, {time}")

                qdate = QDate(date.year, date.month, date.day)
                symbol = status_map.get(status, "")

                self.symbols[qdate] = (symbol, time)

                if status in count_data:
                    count_data[status] += 1
                    print(f"카운팅 중: {status} → {count_data[status]}")
                else:
                    print(f"[ERROR] 알 수 없는 상태: {status}")

            self.parent.update_attendance_labels(count_data)

        except Exception as e:
            print("데이터베이스 오류:", e)

        finally:
            cursor.close()
            conn.close()

    def paintCell(self, painter, rect, date):
        super().paintCell(painter, rect, date)

        if date in self.symbols:
            symbol, time = self.symbols[date]
            color_map = {'O': "blue", '△': "green", 'X': "red"}

            painter.setPen(QColor(color_map.get(symbol, "black")))

            font = QFont("Arial", 12, QFont.Bold)
            painter.setFont(font)
            painter.drawText(rect.adjusted(rect.width() // 3, 0, 0, 0), Qt.AlignLeft, symbol)

            painter.setFont(QFont("Arial", 6))
            painter.drawText(rect.adjusted(0, rect.height() // 2, 0, 0), Qt.AlignCenter, time)


class AttendanceApp(QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('./miniproject01/출석관리,통계2.ui', self)

        # 달력 위젯
        old_calendar = self.findChild(QCalendarWidget, "calendarWidget")
        if old_calendar:
            self.custom_calendar = CustomCalendar(self)
            self.custom_calendar.setGeometry(old_calendar.geometry())
            self.custom_calendar.setObjectName("calendarWidget")
            layout = old_calendar.parentWidget().layout()
            if layout:
                layout.replaceWidget(old_calendar, self.custom_calendar)
            old_calendar.deleteLater()

    #     # QLabel 위젯
    #     self.present_label = self.findChild(QLabel, "출석")
    #     self.late_label = self.findChild(QLabel, "지각")
    #     self.early_leave_label = self.findChild(QLabel, "조퇴")
    #     self.outing_label = self.findChild(QLabel, "외출")
    #     self.absent_label = self.findChild(QLabel, "결석")
        
    #     self.attendance_table = self.findChild(QTableWidget, "tableWidget_2")
    #     if self.attendance_table:
    #         self.initialize_table()

    # def initialize_table(self):
    #     self.attendance_table.setHorizontalHeaderLabels(["출결 현황", "개수"])
    #     self.attendance_table.setRowCount(5)
    #     self.attendance_table.setItem(0, 0, QTableWidgetItem("출석"))
    #     self.attendance_table.setItem(1, 0, QTableWidgetItem("지각"))
    #     self.attendance_table.setItem(2, 0, QTableWidgetItem("조퇴"))
    #     self.attendance_table.setItem(3, 0, QTableWidgetItem("외출"))
    #     self.attendance_table.setItem(4, 0, QTableWidgetItem("결석"))

    # def update_attendance_table(self, count_data):
    #     if self.attendance_table:
    #         self.attendance_table.setItem(0, 1, QTableWidgetItem(str(count_data.get('P', 0))))
    #         self.attendance_table.setItem(1, 1, QTableWidgetItem(str(count_data.get('L', 0))))
    #         self.attendance_table.setItem(2, 1, QTableWidgetItem(str(count_data.get('E', 0))))
    #         self.attendance_table.setItem(3, 1, QTableWidgetItem(str(count_data.get('O', 0))))
    #         self.attendance_table.setItem(4, 1, QTableWidgetItem(str(count_data.get('A', 0))))
    # def update_attendance_labels(self, count_data):
    #     if self.present_label:
    #         self.present_label.setText(str(count_data.get('P', 0)))
    #     if self.late_label:
    #         self.late_label.setText(str(count_data.get('L', 0)))
    #     if self.early_leave_label:
    #         self.early_leave_label.setText(str(count_data.get('E', 0)))
    #     if self.outing_label:
    #         self.outing_label.setText(str(count_data.get('O', 0)))
    #     if self.absent_label:
    #         self.absent_label.setText(str(count_data.get('A', 0)))

    #     if self.attendance_table:
    #         self.attendance_table.setItem(0, 1, QTableWidgetItem(str(count_data.get('P', 0))))
    #         self.attendance_table.setItem(1, 1, QTableWidgetItem(str(count_data.get('L', 0))))
    #         self.attendance_table.setItem(2, 1, QTableWidgetItem(str(count_data.get('E', 0))))
    #         self.attendance_table.setItem(3, 1, QTableWidgetItem(str(count_data.get('O', 0))))
    #         self.attendance_table.setItem(4, 1, QTableWidgetItem(str(count_data.get('A', 0))))




if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = AttendanceApp()
    window.show()
    sys.exit(app.exec_())