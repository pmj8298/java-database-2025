## 토이프로젝트
PYTHON GUI - ORACLE 연동 프로그램

### GUI 프레임워크
- GUI 프레임워크 종류
    1. TKINTER 
        - 파이썬에 내장된 GUI 라이브러리, 중소형 프로그램 사용, 간단하게 사용가능, 예쁘지가 않아 단점임
    2. PyQt /PySide 
        - C/C++에서 사용하는 GUI 프레임워크 Qt를 Pyhton에 사용하게 만든 라이브러리, 현재 6버전 출시, 유료
        - PyQt 의 상용라이선스 문제로 PySide 등장. PyQt 에서 PySide 로 변경하는데 번거로움이 존재
        - TKINTER 보다 난도가 있지만 아주 예쁨, QtDesigner 툴로 포토샵처럼 GUI 를 디자인 가능
        - Python GUI 중에서 가장 많이 사용중
    3. Kivy
        - OpenGL(게임엔진용 3D 그래픽엔진) 으로 구현되는 GUI 프레임워크
        - 안드로이드, IOS 등 모바일용으로도 개발 가능
        - 최신에 나온 기술이라 아직 불안정함
    4. wxPython
        - Kivy 처럼 멀티플랫폼 GUI 프레임워크
        - 무지 어려움

### PyQt5 GUI 사용
    - PyQt5 설치
        -  콘솔 > pip install PyQt5
    - QtDesigner 설치
        - https://build-system.fman.io/qt-designer-download 다운로드 후 설치

        <img src="" width="700">


#### PyQt5 개발
1. PyQt 모듈 사용 윈앱 만들기
2. 윈도우 기본설정
3. PyQt 위젯 사용법(레이블, 버튼, ...)
4. 시그널(이벤트) 처리방법
5. QtDesigner로 화면디자인, PyQt와 연동
    <img src="../image/db002.png" width="700">