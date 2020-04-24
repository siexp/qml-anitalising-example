import QtQuick 2.14
import QtQuick.Window 2.14
import QtGraphicalEffects 1.0

Window {
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    title: qsTr("qml-anitalising-example")

    // JS-Canvas example
    Rectangle{
        width: 100
        height: 100
        color: "black"

        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            color: "white"

            text: qsTr("Click me")
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                noSmoothing.start(3000)
                smoothing.start(3000)
            }
            onDoubleClicked: {
                noSmoothing.stop()
                smoothing.stop()
            }
        }
    }

    Item {
        id: noSmoothing
        x: 100
        y: 300

        width: 123
        height: 123
        scale: 2

        function start(timeout) {
            canvasWithoutSmoothing.angleEnd = 0
            canvasTimerWithoutSmoothing.timeout = timeout
            canvasTimerWithoutSmoothing.now = timeout
            canvasTimerWithoutSmoothing.restart()
        }

        function stop() {
            canvasTimerWithoutSmoothing.stop()
        }

        Rectangle {
            anchors {
                fill: parent
                margins: 3
            }
            radius: width / 2
            color: "#0000AA"

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                color: "white"

                text: qsTr("No smoothing")
            }
        }

        Canvas {
            id: canvasWithoutSmoothing
            anchors.fill: parent
            rotation: -90
            antialiasing: true

//            renderTarget: Canvas.FramebufferObject
//            renderStrategy: Canvas.Cooperative

            property double angleEnd: 0

            onPaint: {
                var ctx = getContext('2d')

                const x = width / 2
                const y = height / 2
                const radius = x - 7
                const arcStart = 0
                const arcEnd = Math.PI * (angleEnd / 180)

                ctx.beginPath()
                ctx.arc(x, x, radius, 0, 2 * Math.PI, false)
                ctx.lineWidth = 11
                ctx.strokeStyle = "#00AA00"
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(x, y, radius, arcStart, arcEnd, false)
                ctx.lineWidth = 11
                ctx.strokeStyle = '#AA0000'
                ctx.stroke();
            }

            onAngleEndChanged: {
                canvasWithoutSmoothing.requestPaint()
            }
        }

        Timer {
            id: canvasTimerWithoutSmoothing
            interval: 10
            repeat: now > 0

            property var timeout: 0
            property var now: 0

            onTriggered: {
                now -= interval

                let timePercent = (now * 100) / timeout
                canvasWithoutSmoothing.angleEnd = 360 - ((timePercent / 100) * 360)
            }
        }
    }

    Item {
        id: smoothing
        x: 400
        y: 300

        width: 123
        height: 123
        scale: 2

        function start(timeout) {
            canvasTimerWithSmoothing.timeout = timeout
            canvasTimerWithSmoothing.now = timeout
            canvasTimerWithSmoothing.restart()
        }

        function stop() {
            canvasTimerWithSmoothing.stop()
        }

        Rectangle {
            anchors {
                fill: parent
                margins: 3
            }
            radius: width / 2
            color: "#0000AA"

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                color: "white"

                text: qsTr("Smoothing")
            }
        }

        Canvas {
            id: canvasWithSmoothing
            anchors.fill: parent
            rotation: -90
            antialiasing: true

            // these two properties allows to draw on canvas smoothly
            renderTarget: Canvas.FramebufferObject
            renderStrategy: Canvas.Cooperative

            property double angleEnd: 0

            onPaint: {
                var ctx = getContext('2d')

                const x = width / 2
                const y = height / 2
                const radius = x - 7
                const arcStart = 0
                const arcEnd = Math.PI * (angleEnd / 180)

                ctx.beginPath()
                ctx.arc(x, x, radius, 0, 2 * Math.PI, false)
                ctx.lineWidth = 11
                ctx.strokeStyle = "#00AA00"
                ctx.stroke()

                ctx.beginPath()
                ctx.arc(x, y, radius, arcStart, arcEnd, false)
                ctx.lineWidth = 11
                ctx.strokeStyle = '#AA0000'
                ctx.stroke();
            }

            onAngleEndChanged: {
                canvasWithSmoothing.requestPaint()
            }
        }

        Timer {
            id: canvasTimerWithSmoothing
            interval: 10
            repeat: now > 0

            property var timeout: 0
            property var now: 0

            onTriggered: {
                now -= interval

                let timePercent = (now * 100) / timeout
                canvasWithSmoothing.angleEnd = 360 - ((timePercent / 100) * 360)
            }
        }
    }

    // Image example
    Image {
        id: _noAA_noMipmap

        x: 700
        y: 100
        width: 300
        height: 300
        rotation: 27
        source: "qrc:/ff.png"
    }

    Image {
        id: _AA_Mipmap

        x: 1000
        y: 100
        width: 300
        height: 300
        rotation: 27

        // you need both for real smoothing
        antialiasing: true
        mipmap: true

        source: "qrc:/ff.png"
    }
}
