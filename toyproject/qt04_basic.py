## PyQt5 첫 앱 개발
import sys 
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *

class DevWindow(QMainWindow): 
    def __init__(self): 
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle('My First App')
        self.setWindowIcon(QIcon('./image/databases.png'))
        self.resize(600,350)

        self.lbl1 = QLabel('버튼클릭', self)
        # self.lbl1.move(10,10)
        # self.lbl1.resize(250,30)

        self.btn1 = QPushButton('Click', self)
        # self.btn1.move(10,40)
        self.btn1.clicked.connect(self.btn1click)

        self.hbox = QHBoxLayout() # 가로로 구성하는 레이아웃
        self.hbox.addStretch(1) # 여유 공백백
        self.hbox.addWidget(self.lbl1)
        self.hbox.addWidget(self.btn1)
        self.hbox.addStretch(1)

        self.vbox = QVBoxLayout() # 세로로 구성하는 레이아웃

        self.setLayout(self.hbox) # 윈도우에 레이아웃 추가

        qr = self.frameGeometry()
        cp = QDesktopWidget().availableGeometry().center()
        qr.moveCenter(cp)
        self.move(qr.topLeft())

        self.show()

    def btn1click(self):
        QMessageBox.about(self,'알림','버튼을 클릭했습니다.')

if __name__ == '__main__':
    app = QApplication(sys.argv) 
    win = DevWindow() 
    app.exec_() 


# =================
# import sys
# from PyQt5.QtWidgets import *
# from PyQt5.QtGui import *

# class DevWindow(QMainWindow): 
#     def __init__(self): 
#         super().__init__()
#         self.initUI()

#     def initUI(self):
#         self.setWindowTitle('My First App')
#         self.setWindowIcon(QIcon('./image/databases.png'))
#         self.resize(600, 350)

#         # 중앙 위젯 생성
#         central_widget = QWidget()
#         self.setCentralWidget(central_widget)

#         self.lbl1 = QLabel('버튼 클릭', self)

#         self.btn1 = QPushButton('Click', self)
#         self.btn1.clicked.connect(self.btn1click)

#         self.hbox = QHBoxLayout()  # 가로 레이아웃
#         self.hbox.addStretch(1)
#         self.hbox.addWidget(self.lbl1)
#         self.hbox.addWidget(self.btn1)
#         self.hbox.addStretch(1)

#         self.vbox = QVBoxLayout()  # 세로 레이아웃
#         self.vbox.addStretch(1)
#         self.vbox.addLayout(self.hbox)
#         self.vbox.addStretch(1)

#         # 중앙 위젯에 레이아웃 적용
#         central_widget.setLayout(self.vbox)

#         # 화면 중앙 배치
#         self.center()

#         self.show()

#     def center(self):
#         qr = self.frameGeometry()
#         cp = QDesktopWidget().availableGeometry().center()
#         qr.moveCenter(cp)
#         self.move(qr.topLeft())

#     def btn1click(self):
#         QMessageBox.about(self, '알림', '버튼을 클릭했습니다.')

# if __name__ == '__main__':
#     app = QApplication(sys.argv)
#     win = DevWindow()
#     sys.exit(app.exec_())
