## PyQt5 첫 앱 개발
import sys 
from PyQt5.QtWidgets import *

# PyQt 의 모든 컨트롤은 Widget(위젯)이라고 부름
class DevWindow(QMainWindow): # 클래스 선언언
    def __init__(self): # 클래스 초기화 스페셜 메서드
        super().__init__() # 부모클래스 QMainWindow도 초기화화

app = QApplication(sys.argv) # 어플리케이션 인스턴스 생성
win = DevWindow() # PyQt로 만들어진 클래스 인스턴스 생성
win.show() # 윈도우 바탕화면에 띄워라
app.exec_() # 애플리케이션이 x버튼을 물러서 종료되기 전까지 실행하라
