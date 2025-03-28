import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import QDate, Qt
from PyQt5 import uic
import cx_Oracle as oci
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
import matplotlib.font_manager as fm


sid = 'XE'
host = '210.119.14.71'
port = 1521
username = 'attendance'
password = '12345'


class AttendanceGraph(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.figure = Figure()
        self.canvas = FigureCanvas(self.figure)
        layout = QVBoxLayout(self)
        layout.addWidget(self.canvas)

        font_path = "C:/Windows/Fonts/malgun.ttf"
        self.font_prop = self.set_korean_font(font_path)

    def set_korean_font(self, font_path):
        try:
            font = fm.FontProperties(fname=font_path)
            return font
        except Exception as e:
            print("폰트 로드 오류:", e)
            return None

    def update_graph(self, count_data):
        self.figure.clear()
        ax = self.figure.add_subplot(111)

        labels = ['출석', '지각', '결석']
        values = [count_data.get('P', 0), count_data.get('L', 0), count_data.get('A', 0)]
        
        ax.bar(labels, values, color=['darkblue', 'darkgreen', 'darkred'])

        ax.set_xticks(range(len(labels))) 
        ax.set_xticklabels(labels, fontproperties=self.font_prop)

        ax.set_title('출결 현황', fontproperties=self.font_prop)
        self.canvas.draw()


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
                qdate = QDate(date.year, date.month, date.day)
                symbol = status_map.get(status, "")

                self.symbols[qdate] = (symbol, time)

                if status in count_data:
                    count_data[status] += 1

            print("출결 데이터 로드 완료:", count_data)

            self.parent.update_attendance_labels(count_data)
            self.parent.graph_widget.update_graph(count_data)

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

            # 기호 색상 설정
            painter.setPen(QColor(color_map.get(symbol, "black")))

            # 기호 표시
            font = QFont("Arial", 12, QFont.Bold)
            painter.setFont(font)
            painter.drawText(rect.adjusted(rect.width() // 3, 0, 0, 0), Qt.AlignLeft, symbol)

            # # 시간 표시
            # painter.setFont(QFont("Arial", 6))
            # painter.drawText(rect.adjusted(0, rect.height() // 2, 0, 0), Qt.AlignCenter, time)

            if symbol != 'X':  
                painter.setFont(QFont("Arial", 6)) 
                painter.drawText(rect.adjusted(0, rect.height() // 2, 0, 0), Qt.AlignCenter, time)


class AttendanceApp(QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('./miniproject01/출석관리,통계2.ui', self)

        self.graph_widget = AttendanceGraph(self)

        vertical_layout = self.findChild(QVBoxLayout, "verticalLayout")
        if vertical_layout:
            vertical_layout.addWidget(self.graph_widget)
            vertical_layout.addStretch(1)

        self.graph_widget.setMinimumHeight(50)
        self.graph_widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)

        old_calendar = self.findChild(QCalendarWidget, "calendarWidget")
        if old_calendar:
            self.custom_calendar = CustomCalendar(self)
            self.custom_calendar.setGeometry(old_calendar.geometry())
            self.custom_calendar.setObjectName("calendarWidget")
            layout = old_calendar.parentWidget().layout()
            if layout:
                layout.replaceWidget(old_calendar, self.custom_calendar)
            old_calendar.deleteLater()

        text_browser = self.findChild(QTextBrowser, "textBrowser")
        if text_browser:
            container = QWidget(text_browser)
            text_browser.setViewport(container)
            container_layout = QVBoxLayout(container)
            container_layout.addWidget(self.graph_widget)

    def update_attendance_labels(self, count_data):
        print(f"출결 카운트 업데이트: {count_data}")
        if hasattr(self, 'graph_widget') and self.graph_widget:
            self.graph_widget.update_graph(count_data)
        else:
            print("graph_widget이 초기화되지 않았습니다.")


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = AttendanceApp()
    window.show()
    sys.exit(app.exec_())
