# Oracle Student 연동 앱
import sys 
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5 import QtGui, QtWidgets, uic

class MainWindow(QMainWindow):
    def __init__(self): 
        super(MainWindow, self).__init__()
        self.initUI()

    def initUI(self):
        uic.loadUi('./toyproject/studentdb1.ui', self)
        self.show()
if __name__ == '__main__':
    app = QApplication(sys.argv) 
    win = MainWindow() 
    app.exec_()
