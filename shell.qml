import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick.Controls
import QMLTermWidget
ShellRoot {
    id: root

    property var track: true

    property var active_page: "Desktop"

    property var notif_image: ""
    
    property var notif_name: "user"

    property var notif_summary: "text"

    property var notif_body: ""

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true


        onNotification: n =>{
            n.tracked = true
            console.log(Config.notifications.tracked)

        }
    }


    PanelWindow { // Notifications Page
        id: console_page
        property var name: "Console"

        visible: (active_page == name) ? true : false
        color: "transparent"

        anchors {
            top: true
            bottom: true
            right: true
            left: true
        }

        margins {
            left: 5
            right: 5
            bottom: 5
        }

        Rectangle { 
            anchors.fill: parent
            color: "black"
            border.color: "white"
            border.width: 5

            QMLTermWidget {
                id: terminal
                anchors.fill: parent
                font.family: "Monospace"
                font.pointSize: 12
                colorScheme: "cool-retro-term"
                session: QMLTermSession{
                    id: mainsession
                    initialWorkingDirectory: "$HOME"
                    onMatchFound: {
                        console.log("found at: %1 %2 %3 %4".arg(startColumn).arg(startLine).arg(endColumn).arg(endLine));
                    }
                    onNoMatchFound: {
                        console.log("not found");
                    }
                }
                onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
                onTerminalSizeChanged: console.log(terminalSize);
                Component.onCompleted: mainsession.startShellProgram();
            }
        }
    }

    PanelWindow { // Notifications Page
        id: notifications_page
        property var name: "Notifications"

        

        visible: (active_page == name) ? true : false
        color: "transparent"

        anchors {
            top: true
            bottom: true
            right: true
            left: true
        }

        margins {
            left: 5
            right: 5
            bottom: 5
        }

        
        Rectangle { 
            anchors.fill: parent
            color: "black"
            Rectangle { // Left Side
                color: "transparent"
                border.color: "white"
                border.width: 5
                anchors.top: parent.top 
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                implicitWidth: parent.width / 2 - 2.5

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right

                    color: "transparent"

                    anchors.leftMargin: 5
                    anchors.rightMargin: 6

                    Column {
                        spacing: 5
                        anchors.fill: parent
                        anchors.topMargin: 5
                        
                        Repeater {
                            model: server.trackedNotifications
                            delegate: Rectangle {
                                id: entry
                                
                                required property var modelData
                                property bool seen: false

                                color: "transparent"
                                width: parent.width
                                height: 50

                                Button {
                                    anchors.fill: parent
                                    background: Rectangle {
                                        color: "transparent"
                                    }

                                    onClicked: {
                                        seen = true
                                        notif_image = modelData.appImage
                                        notif_name = modelData.appName
                                        notif_summary = modelData.summary
                                        notif_body = modelData.body
                                    }
                                }

                                Button {
                                    width: 50
                                    height: 50
                                    anchors.verticalCenter: parent.verticalCenter
                                    background: Rectangle {
                                        Image {
                                            source: "assets/x.png"
                                            width: 50
                                            height: 50
                                        }
                                    }

                                    onClicked: {
                                        modelData.dismiss()
                                    }
                                }
                                

                                Text { // user text
                                    x: 64
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.appName
                                    font.family: "Fixedsys Excelsior"
                                    font.pixelSize: 54
                                    color: "lime"

                                }

                                Text { // summary text
                                    x: 516
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.summary
                                    font.family: "Fixedsys Excelsior"
                                    font.pixelSize: 32
                                    color: (seen == false) ? "white" : "gray"
                                }


                                Rectangle {
                                    color: (seen == false) ? "white" : "gray"
                                    implicitWidth: 5
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.leftMargin: 500
                                }

                                Rectangle {
                                    color: (seen == false) ? "white" : "gray"
                                    implicitHeight: 5
                                    anchors.top: parent.top
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.topMargin: 50
                                }


                            }

                            

                        }
                    
                    }

                }

                

            }
        }

            Rectangle { // Right Side
                color: "transparent"
                border.color: "white"
                border.width: 5
                anchors.top: parent.top 
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                implicitWidth: parent.width / 2 - 2.5
                anchors.leftMargin: 10

                
                Rectangle {
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.left: parent.left 
                    anchors.right: parent.right
                    anchors.leftMargin: 5
                    anchors.topMargin: 5
                    height: 110

                    Text { // app name text
                        anchors.verticalCenter: parent.verticalCenter
                        x: 130
                        text: notif_name
                        font.family: "Fixedsys Excelsior"
                        font.pixelSize: 86
                        color: "yellow"
                    }


                    Image {
                        source: (notif_image) ? notif_image : "assets/empty.png"
                        width: 110
                        height: 110
                        
                        anchors.verticalCenter: parent.verticalCenter

                    }

                }

                Rectangle {
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.left: parent.left 
                    anchors.right: parent.right
                    anchors.leftMargin: 5
                    anchors.topMargin: 110
                    height: 110

                    Text { // summary text
                        anchors.verticalCenter: parent.verticalCenter
                        x: 15
                        text: notif_summary
                        font.family: "Fixedsys Excelsior"
                        font.pixelSize: 64
                        color: "white"
                        
                    }

                    

                }

                Rectangle {
                    color: "transparent"
                    anchors.top: parent.top
                    anchors.left: parent.left 
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 5
                    anchors.topMargin: 210

                    Text { // body text
                        width: parent.width
                        wrapMode: Text.WordWrap
                        y: 15
                        x: 15
                        text: notif_body
                        font.family: "Fixedsys Excelsior"
                        font.pixelSize: 48
                        color: "white"
                        
                    }

                    

                }
                


                Rectangle {
                    color: "white"
                    anchors.topMargin: 110
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 5
                    
                }

                Rectangle {
                    color: "white"
                    anchors.topMargin: 220
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 5
                    
                }

            }
        }

    // Borders
    PanelWindow{
        color: "white"
        anchors {
            top: true
            bottom: true
            right: true
        }
        width: 5
    }

    PanelWindow{
        color: "white"
        anchors {
            top: true
            bottom: true
            left: true
        }
        width: 5
    }

    PanelWindow{
        color: "white"
        anchors {
            top: true
            right: true
            left: true
        }
        implicitHeight: 5
    }

    PanelWindow{
        color: "white"
        anchors {
            bottom: true
            right: true
            left: true
        }
        height: 5
    }

    // Top Bar
    PanelWindow{
        color: "transparent"
        anchors {
            top: true
            right: true
            left: true
        }

        margins {
            top: 5
            bottom: 5
            right: 5
            left: 5
        }

        implicitHeight: 120

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "white"
            border.width: 5

            Rectangle {
                color: "transparent"
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                anchors.topMargin: 10
                anchors.bottomMargin: 10

                RowLayout {
                    spacing: 5
                    width: parent.width
                    height: parent.height
                    
                    Button { // Desktop Button
                        id: desktop_button
                        property var name: "Desktop"

                        implicitHeight: 100
                        Layout.fillWidth: true

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: parent.name
                            font.family: "Fixedsys Excelsior"
                            font.pixelSize: 64
                            color: (active_page == parent.name) ? "cyan" : "yellow"
                        }
                        
                        
                        background: Rectangle {
                            color: "transparent"
                            border.color: (active_page == parent.name) ? "cyan" : "yellow"
                            border.width: 5
                        }

                        onClicked: {
                            active_page = name
                        }
                    }

                    Button { // Notifications Button
                        id: notifications_button
                        property var name: "Notifications"

                        implicitHeight: 100
                        Layout.fillWidth: true

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: parent.name
                            font.family: "Fixedsys Excelsior"
                            font.pixelSize: 64
                            color: (active_page == parent.name) ? "cyan" : "yellow"
                        }
                        
                        
                        background: Rectangle {
                            color: "transparent"
                            border.color: (active_page == parent.name) ? "cyan" : "yellow"
                            border.width: 5
                        }

                        onClicked: {
                            active_page = name
                        }
                    }

                    Button { // Console Button
                        id: console_button
                        property var name: "Console"

                        implicitHeight: 100
                        Layout.fillWidth: true

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: parent.name
                            font.family: "Fixedsys Excelsior"
                            font.pixelSize: 64
                            color: (active_page == parent.name) ? "cyan" : "yellow"
                        }
                        
                        
                        background: Rectangle {
                            color: "transparent"
                            border.color: (active_page == parent.name) ? "cyan" : "yellow"
                            border.width: 5
                        }

                        onClicked: {
                            active_page = name
                        }
                    }

                    Button { // Viewer Button
                        id: viewer_button
                        property var name: "Viewer"

                        implicitHeight: 100
                        Layout.fillWidth: true

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: parent.name
                            font.family: "Fixedsys Excelsior"
                            font.pixelSize: 64
                            color: (active_page == parent.name) ? "cyan" : "yellow"
                        }
                        
                        
                        background: Rectangle {
                            color: "transparent"
                            border.color: (active_page == parent.name) ? "cyan" : "yellow"
                            border.width: 5
                        }

                        onClicked: {
                            active_page = name
                        }
                    }

                    Button { // Settings Button
                        id: settings_button
                        property var name: "Settings"

                        implicitHeight: 100
                        Layout.fillWidth: true

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: parent.name
                            font.family: "Fixedsys Excelsior"
                            font.pixelSize: 64
                            color: (active_page == parent.name) ? "cyan" : "yellow"
                        }
                        
                        
                        background: Rectangle {
                            color: "transparent"
                            border.color: (active_page == parent.name) ? "cyan" : "yellow"
                            border.width: 5
                        }

                        onClicked: {
                            active_page = name
                        }
                    }




                    }
                }

            }
            
        }
    }



