import sys  # 시스템 관련 기능 사용 (예: 명령행 인수 처리, 프로그램 종료)
from PyQt5.QtWidgets import *  # PyQt5의 다양한 위젯(QMainWindow, QWidget, QVBoxLayout 등)을 불러옴
from PyQt5.QtGui import *      # 폰트, 색상, 페인터 등 GUI 관련 그래픽 관련 모듈 불러옴
from PyQt5.QtCore import QDate, Qt  # 날짜, 시간, UI 정렬 방식 등 핵심 상수 및 클래스를 불러옴
from PyQt5 import uic  # 별도로 작성된 .ui 파일(디자인된 UI)을 로드하기 위한 모듈
import cx_Oracle as oci  # Oracle 데이터베이스와 연결하기 위한 라이브러리
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas  # Matplotlib 그래프를 PyQt5에 표시하기 위한 캔버스
from matplotlib.figure import Figure  # Matplotlib에서 그래프의 전체 틀(Figure)을 생성하기 위한 클래스
import matplotlib.font_manager as fm  # Matplotlib에서 사용자 지정 폰트(예: 한글 폰트)를 적용하기 위한 모듈


# ---------------------- 데이터베이스 연결 설정 ----------------------- #
sid = 'XE'           
host = '210.119.14.71' 
port = 1521          
username = 'attendance' 
password = '12345'   


# ---------------------- 출석 그래프 표시 위젯 ------------------------- #
class AttendanceGraph(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent)  # 부모 위젯 초기화
        self.figure = Figure()  # Matplotlib의 Figure 객체 생성 (그래프를 그리기 위한 캔버스의 틀)
        self.canvas = FigureCanvas(self.figure)  # Figure 를 PyQt5 위젯에 표시할 수 있도록 하는 캔버스 생성
        layout = QVBoxLayout(self)  # 이 위젯 내부에 수직 박스 레이아웃을 설정해서 자식 위젯들을 세로로 배치
        layout.addWidget(self.canvas)  # 생성한 캔버스를 레이아웃에 추가

        font_path = "C:/Windows/Fonts/malgun.ttf"
        self.font_prop = self.set_korean_font(font_path)

    def set_korean_font(self, font_path):
        try:
            font = fm.FontProperties(fname=font_path)  # 폰트 파일을 읽어 FontProperties 객체 생성
            return font  # 성공적으로 로드된 폰트 정보를 반환
        except Exception as e:
            print("폰트 로드 오류:", e)  # 에러 메시지 출력
            return None  # 폰트 로딩 실패 시 None 반환

    def update_graph(self, count_data):
        self.figure.clear()  # 기존의 그래프 내용을 모두 클리어(삭제)
        ax = self.figure.add_subplot(111)  # 새로운 서브플롯(축)을 생성 (1행 1열의 유일한 플롯)

        # 그래프에 표시할 레이블과 각 항목의 값 설정
        labels = ['출석', '지각', '결석']
        values = [count_data.get('P', 0), count_data.get('L', 0), count_data.get('A', 0)]
        
        # 막대 그래프 생성 (각 항목의 색상도 지정)
        ax.bar(labels, values, color=['darkblue', 'darkgreen', 'darkred'])

        # x축 눈금을 레이블의 수에 맞게 설정하고 한글 폰트를 적용하여 이름 렌더링
        ax.set_xticks(range(len(labels)))
        ax.set_xticklabels(labels, fontproperties=self.font_prop)

        # 그래프 제목 설정 (한글 폰트 적용)
        ax.set_title('출결 현황', fontproperties=self.font_prop)
        self.canvas.draw()  # 변경된 내용을 캔버스에 다시 그려서 화면에 업데이트


# ---------------------- 사용자 지정 달력 위젯 ------------------------- #
class CustomCalendar(QCalendarWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.symbols = {}  # 각 날짜에 해당하는 출석 심볼과 시간을 저장할 딕셔너리
        self.setVerticalHeaderFormat(QCalendarWidget.NoVerticalHeader)  # 달력의 좌측 날짜(세로 헤더) 비활성화
        self.parent = parent  # 부모 위젯(최상위 윈도우)을 저장 (데이터 업데이트용)
        self.load_attendance_data()  # 애플리케이션 시작 시 출석 데이터를 데이터베이스에서 로드

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
            rows = cursor.fetchall()  # 쿼리 결과 전체를 가져옴

            # 데이터베이스의 STATUS 값에 따른 화면에 표시할 심볼 매핑
            status_map = {'P': 'O', 'L': '△', 'A': 'X'}
            # 각 상태별 카운트를 저장하기 위한 딕셔너리 초기화
            count_data = {'P': 0, 'L': 0, 'A': 0}

            self.symbols.clear()  # 기존 저장되어 있던 심볼 정보 초기화

            # 조회된 각 행에 대해 처리 (날짜, 출석 상태, 시간)
            for date, status, time in rows:
                qdate = QDate(date.year, date.month, date.day)  # 조회된 날짜를 QDate 객체로 변환
                symbol = status_map.get(status, "")  # 상태 값에 해당하는 심볼 추출

                self.symbols[qdate] = (symbol, time)  # 해당 날짜에 심볼과 시간을 저장

                if status in count_data:
                    count_data[status] += 1  # 상태 별 카운트 증가

            print("출결 데이터 로드 완료:", count_data)

            # 부모 위젯(AttendanceApp)에 데이터를 전달해 UI 업데이트 실행
            self.parent.update_attendance_labels(count_data)
            self.parent.graph_widget.update_graph(count_data)

        except Exception as e:
            print("데이터베이스 오류:", e)  # 데이터베이스 연결/쿼리 실행 중 발생한 오류 출력

        finally:
            cursor.close() 
            conn.close()

    def paintCell(self, painter, rect, date):
        super().paintCell(painter, rect, date)

        if date in self.symbols:
            symbol, time = self.symbols[date]  # 저장된 심볼과 시간 정보를 추출
            color_map = {'O': "blue", '△': "green", 'X': "red"}

            # 심볼 표시를 위한 색상 설정
            painter.setPen(QColor(color_map.get(symbol, "black")))

            # 큰 폰트로 심볼 표시 (폰트 크기 12, 굵게)
            font = QFont("Arial", 12, QFont.Bold)
            painter.setFont(font)
            # 셀의 일정 부분에 심볼을 좌측에 표시 (위치 조정 후 문자를 그림)
            painter.drawText(rect.adjusted(rect.width() // 3, 0, 0, 0), Qt.AlignLeft, symbol)

            # 작은 폰트로 시간을 표시 (폰트 크기 6)
            painter.setFont(QFont("Arial", 6))
            # 셀 중앙 아래쪽에 시간을 표시 (위치 조정 후 중앙 정렬)
            painter.drawText(rect.adjusted(0, rect.height() // 2, 0, 0), Qt.AlignCenter, time)


# ---------------------- 메인 애플리케이션 윈도우 ------------------------- #
class AttendanceApp(QMainWindow):
    def __init__(self):
        super().__init__()
        # 기존에 Qt Designer 등으로 제작된 UI 파일(출석관리,통계2.ui)을 로드하여 구성함
        uic.loadUi('./miniproject01/출석관리,통계2.ui', self)

        # 출석 그래프 위젯 생성 후 메인 윈도우의 자식으로 등록
        self.graph_widget = AttendanceGraph(self)

        # UI에 미리 배치된 수직 레이아웃(verticalLayout)을 찾아서 그래프 위젯을 추가
        vertical_layout = self.findChild(QVBoxLayout, "verticalLayout")
        if vertical_layout:
            vertical_layout.addWidget(self.graph_widget)
            vertical_layout.addStretch(1)  # 레이아웃 끝에 여백을 추가해서 UI 정리

        # 그래프 위젯의 최소 높이 및 크기 정책 설정 (창 크기 변화에 따라 자동 조정)
        self.graph_widget.setMinimumHeight(50)
        self.graph_widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)

        # 기존 UI에 배치된 QCalendarWidget을 찾아 이를 사용자 지정 달력으로 교체
        old_calendar = self.findChild(QCalendarWidget, "calendarWidget")
        if old_calendar:
            self.custom_calendar = CustomCalendar(self)  # 사용자 지정 달력 생성 (출석 데이터가 반영)
            # 기존 달력과 동일한 위치 및 크기를 적용
            self.custom_calendar.setGeometry(old_calendar.geometry())
            self.custom_calendar.setObjectName("calendarWidget")
            # 기존 달력이 포함된 부모 위젯의 레이아웃을 찾아서 위젯 교체
            layout = old_calendar.parentWidget().layout()
            if layout:
                layout.replaceWidget(old_calendar, self.custom_calendar)
            old_calendar.deleteLater()  # 기존 달력 삭제

        # 추가로 UI에 배치된 QTextBrowser를 찾아서 내부에 그래프 위젯을 다시 붙이기도 함
        text_browser = self.findChild(QTextBrowser, "textBrowser")
        if text_browser:
            container = QWidget(text_browser)  # 텍스트 브라우저에 포함시킬 컨테이너 위젯 생성
            text_browser.setViewport(container)
            container_layout = QVBoxLayout(container)
            container_layout.addWidget(self.graph_widget)

    def update_attendance_labels(self, count_data):
        """
        외부에서 출석 데이터(count_data)를 전달받아 콘솔에 출력하고,
        그래프 위젯을 업데이트하는 역할을 담당합니다.
        """
        print(f"출결 카운트 업데이트: {count_data}")
        if hasattr(self, 'graph_widget') and self.graph_widget:
            # 출석 데이터에 따라 그래프를 갱신
            self.graph_widget.update_graph(count_data)
        else:
            print("graph_widget이 초기화되지 않았습니다.")


# ---------------------- 애플리케이션 실행부 (메인 함수) ------------------------- #
if __name__ == "__main__":
    app = QApplication(sys.argv)  # QApplication 객체 생성 (모든 PyQt5 애플리케이션의 기본)
    window = AttendanceApp()      # 메인 윈도우(AttendanceApp 인스턴스) 생성
    window.show()                 # 윈도우를 화면에 표시
    sys.exit(app.exec_())         # 애플리케이션 이벤트 루프 실행 및 종료 시 시스템 종료 처리
