import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick.Controls
import QMLTermWidget

ShellRoot {
    id: root

    // Notification Variables
    property var active_page: "Desktop"
    property var notif_image: ""
    property var notif_name: "user"
    property var notif_summary: "text"
    property var notif_body: ""

    // Settings Variables
    property int a_margins: settingsModel.get(0).properties.get(1).current_value
    property int border_width: settingsModel.get(0).properties.get(0).current_value
    property int notif_font_size: settingsModel.get(1).properties.get(0).current_value
    property int console_font_size: settingsModel.get(2).properties.get(0).current_value

    ListModel {
        id: notificationModel
    }

    ListModel {
        id: settingsModel

        ListElement {            
            name: "general"
            properties: [
                ListElement {
                name: "border_width"
                current_value: 5
                max_value: 10
                min_value: 1
                },
                ListElement {
                name: "margins"
                current_value: 5
                max_value: 10
                min_value: 1
                },
            ]
        }

        ListElement {            
            name: "notifications"
            properties: [
                ListElement {
                name: "font_size"
                current_value: 5
                max_value: 10
                min_value: 1
                },
            ]
        }

        ListElement {            
            name: "console"
            properties: [
                ListElement {
                name: "console_font_size"
                current_value: 5
                max_value: 10
                min_value: 1
                },
            ]
        }  
    }

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n =>{
            n.tracked = true
            notificationModel.insert(0, {
                appName: n.appName,
                appImage: n.image,
                summary: n.summary,
                body: n.body,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            })

        }
    }

    // Settings Page

    PanelWindow { 
        id: settings_page
        property var name: "Settings"

        visible: (active_page == name) ? true : false
        color: "transparent"

        anchors {
            top: true
            bottom: true
            right: true
            left: true
        }

        margins {
            left: a_margins
            right: a_margins
            bottom: a_margins
        }

        Rectangle { 
            anchors.fill: parent
            color: "black"
            border.color: "white"
            border.width: border_width

            Rectangle {
                anchors.fill: parent
                anchors.margins: a_margins + 5
                color: "transparent"

                // Settings Column
                ColumnLayout {
                    spacing: 5
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Repeater {
                        model: settingsModel

                        delegate: Rectangle {

                            id: entry
                            required property int index

                            property var h: 100
                            property int num
                            property bool dropped: false

                            Layout.fillWidth: true

                            implicitHeight: entry.h

                            color: "transparent"

                            border.color: "white"

                            border.width: border_width

                            Component.onCompleted: {
                                num = settingsModel.get(index).properties.count;
                            }

                            Button {
                                implicitWidth: parent.width
                                implicitHeight: 100
                                background: Rectangle{
                                    color: "transparent"
                                }

                                onClicked: {
                                    dropped = !dropped
                                }

                            }

                            Image {
                                x: 35
                                scale: 4
                                y: 45
                                source: (dropped == true) ? "assets/downy.png" : "assets/uppy.png"
                            }


                            Text {
                                x: 85
                                color: "white"
                                text: settingsModel.get(index).name
                                font.pixelSize: 64
                                font.family: "Fixedsys Excelsior"
                                y: 20
                            }

                            Rectangle {
                                color: "transparent"
                                anchors.fill: parent
                                anchors.topMargin: 100
                                
                                ColumnLayout { 

                                    spacing: 0
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: a_margins * 10

                                    Repeater {
                                        
                                        model: (dropped == true) ? num : 0
                                        delegate: Rectangle { 
                                            id: rec
                                            required property int index
                                            color: "transparent"
                                            border.color: "white"
                                            border.width: border_width
                                            Layout.fillWidth: true
                                            implicitHeight: 100
                                            Component.onCompleted: {
                                                entry.h += 110
                                            }

                                            Component.onDestruction: entry.h -= 110

                                            Text {
                                                text: settingsModel.get(entry.index).properties.get(index).name
                                                color: "white"
                                                x: 1275
                                                anchors.verticalCenter: parent.verticalCenter
                                                font.family: "Fixedsys Excelsior"

                                                font.pixelSize: 48 
                                            }

                                            Rectangle {
                                                color: "transparent"
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.margins: a_margins * 2
                                                implicitWidth: 250
                                                implicitHeight: parent.height
                                                border.color: "yellow"
                                                border.width: border_width
                                                Text {
                                                    text: settingsModel.get(entry.index).properties.get(index).current_value + "/" + settingsModel.get(entry.index).properties.get(index).max_value
                                                    color: "yellow"
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    anchors.horizontalCenter: parent.horizontalCenter
                                                    font.family: "Fixedsys Excelsior"

                                                    font.pixelSize: 48
                                                }
                                            }

                                            Rectangle {
                                                id: value_buttons
                                                property int current_value: settingsModel.get(entry.index).properties.get(index).current_value
                                                property int min_value: settingsModel.get(entry.index).properties.get(index).min_value
                                                property int max_value: settingsModel.get(entry.index).properties.get(index).max_value
                
                                                color: "transparent"
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.leftMargin: 1050
                                                implicitWidth: 215
                                                implicitHeight: parent.height

                                                border.color: "white"
                                                border.width: border_width

                                                Rectangle {
                                                    color: "transparent"
                                                    anchors.top: parent.top
                                                    anchors.bottom: parent.bottom
                                                    anchors.left: parent.left
                                                    anchors.margins: a_margins * 2
                                                    implicitWidth: parent.height - 10
                                                    implicitHeight: parent.height

                                                    border.color: "lime"
                                                    border.width: border_width

                                                    Button {
                                                        anchors.fill: parent
                                                        background: Rectangle {
                                                            color: "transparent"
                                                        }
                                                        onClicked: {
                                                            (value_buttons.current_value != value_buttons.max_value) ? settingsModel.get(entry.index).properties.setProperty(index, "current_value", (value_buttons.current_value + 1)) : ""
                                                        }
                                                    }
                                                    Image {
                                                        source: "assets/up.png"
                                                        scale: 4
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                    }
                                                }

                                                Rectangle {
                                                    color: "transparent"
                                                    anchors.top: parent.top
                                                    anchors.bottom: parent.bottom
                                                    anchors.right: parent.right
                                                    anchors.margins: a_margins * 2
                                                    implicitWidth: parent.height - 10
                                                    implicitHeight: parent.height

                                                    border.color: "lime"
                                                    border.width: border_width
                                                    Button {
                                                        anchors.fill: parent
                                                        background: Rectangle {
                                                            color: "transparent"
                                                        }
                                                        onClicked: {
                                                            (value_buttons.current_value != value_buttons.min_value) ? settingsModel.get(entry.index).properties.setProperty(index, "current_value", (value_buttons.current_value - 1)) : ""
                                                        }
                                                    }

                                                    Image {
                                                        source: "assets/down.png"
                                                        scale: 4
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                    }
                                                }


                                            }
                                            


                                            Rectangle {
                                                id: thingy
                                                property int current_value: settingsModel.get(entry.index).properties.get(index).current_value
                                                

                                                color: "transparent"
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.margins: a_margins * 2
                                                anchors.leftMargin: 280
                                                implicitWidth: 750
                                                implicitHeight: parent.height

                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.bottomMargin: 20
                                                    spacing: 5

                                                    Repeater {
                                                        model: settingsModel.get(entry.index).properties.get(index).max_value

                                                        delegate: Rectangle {
                                                            required property int index 

                                                            color: (thingy.current_value <= (index)) ? "transparent" : "lime"
                                                            
                                                            height: parent.height
                                                            Layout.fillWidth: true
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    // Console Page
    PanelWindow { 
        id: console_page
        property var name: "Console"

        ListModel {
            id: commands
            ListElement {
                name: "ping"
                description: "Pings the server[s]"
            }
            ListElement {
                name: "pacman -S []"
                description: "Install package[s]"
            }
            ListElement {
                name: "quickshell kill"
                description: "Kill quickshell"
            }
            ListElement {
                name: "notify-send"
                description: "Test notifications"
            }
            ListElement {
                name: "history"
                description: "Show command history"
            }
            ListElement {
                name: "bla"
                description: "bla"
            }
        }

        focusable: true
        aboveWindows: true

        visible: (active_page == name) ? true : false
        color: "transparent"

        anchors {
            top: true
            bottom: true
            right: true
            left: true
        }

        margins {
            left: a_margins
            right: a_margins
            bottom: a_margins
        }

        Rectangle { 
            
            anchors.fill: parent
            color: "black"
            border.color: "white"
            border.width: border_width
            
            // Right Side
            Rectangle { 
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width / 3.05
                color: "black"
                border.width: border_width
                border.color: "white"
                anchors.margins: a_margins * 2

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top

                    Repeater {
                        model: commands

                        delegate: Rectangle {
                            required property int index

                            color: "transparent"
                            implicitWidth: parent.width
                            implicitHeight: 75
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 25
                                font.pixelSize: 32
                                font.family: "Fixedsys Excelsior"
                                color: "white"
                                text: commands.get(index).name
                                

                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 25
                                font.pixelSize: 32
                                font.family: "Fixedsys Excelsior"
                                color: "white"
                                text: commands.get(index).description

                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right

                                implicitHeight: 5

                            }
                        }
                    }
                }
            }
            
            // Left Side
            Rectangle { 
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width / 1.5
                color: "transparent"
                anchors.margins: a_margins * 2
                border.color: "white"
                border.width: border_width

                // Top Side
                Rectangle { 
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 150
                    color: "transparent"
                    border.color: "white"
                    border.width: border_width
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 25
                        font.pixelSize: 128
                        font.family: "Fixedsys Excelsior"
                        color: "white"
                        text: "CONSOLE:"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 25
                        font.pixelSize: 128
                        font.family: "Fixedsys Excelsior"
                        color: "white"
                        text: "user"
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 100
                    color: "transparent"
                    border.color: "white"
                    border.width: border_width

                    TextField {
                        id: field
                        focus: true
                        anchors.fill: parent
                        anchors.leftMargin: 5
                        placeholderText: ""
                        color: "white"
                        font.pixelSize: 32
                        font.family: "Fixedsys Excelsior"
                        Component.onCompleted: field.forceActiveFocus();

                        onAccepted: {
                            mainsession.sendText(text + "\n");
                            text = ""
                        }

                        background: Rectangle {
                            color: "transparent"
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.bottomMargin: 100
                    anchors.topMargin: 150
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    color: "transparent"

                    QMLTermWidget {
                    id: terminal
                    anchors.fill: parent
                    font.family: "Fixedsys Excelsior"
                    font.pointSize: 3 * settingsModel.get(2).properties.get(0).current_value
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
        }
    }

    // Notifications Page

    PanelWindow { 
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
            left: a_margins
            right: a_margins
            bottom: a_margins
        }

        
        Rectangle { 
            anchors.fill: parent
            color: "black"
            // Left Side
            Rectangle { 
                color: "transparent"
                border.color: "white"
                border.width: border_width
                anchors.top: parent.top 
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                implicitWidth: parent.width / 2 - 2.5

                // Top
                Rectangle { 
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        implicitHeight: 115
                        border.color: "white"
                        border.width: border_width
                        color: "transparent"

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            implicitWidth: 5
                            anchors.leftMargin: 505
                        }

                        Button {
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            implicitWidth: 505
                            background: Rectangle {
                                color: "transparent"
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: 110
                                    color: "red"
                                    text: "Clear All"
                                    font.family: "Fixedsys Excelsior"
                                    font.pixelSize: notif_font_size * 16
                                }

                                Image {
                                    source: "assets/x.png"
                                    scale: 4
                                    x: 45
                                    
                                    anchors.verticalCenter: parent.verticalCenter

                                }
                            }

                            onClicked: {
                                notificationModel.clear()
                            }
                        }
                    }

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right

                    color: "transparent"

                    anchors.leftMargin: 5
                    anchors.rightMargin: 6
                    anchors.topMargin: 100

                    

                    Column {
                        spacing: 5
                        anchors.fill: parent
                        anchors.topMargin: 15
                        
                        Repeater {
                            model: notificationModel
                            delegate: Rectangle {
                                id: entry
                                
                                required property var modelData
                                required property int index

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
                                        notificationModel.remove(index, 1)
                                    }
                                }
                                

                                Text { 
                                    x: 64
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.appName
                                    font.family: "Fixedsys Excelsior"
                                    font.pixelSize: notif_font_size * 13
                                    color: "lime"

                                }

                                Text { 
                                    x: 516
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.summary
                                    font.family: "Fixedsys Excelsior"
                                    font.pixelSize: notif_font_size * 8
                                    color: (seen == false) ? "white" : "gray"
                                }

                                Text { 
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 20
                                    text: modelData.time
                                    font.family: "Fixedsys Excelsior"
                                    font.pixelSize: notif_font_size * 12
                                    color: (seen == false) ? "cyan" : "gray"
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
            // Right Side
            Rectangle { 
                color: "transparent"
                border.color: "white"
                border.width: border_width
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

                    Text { 
                        anchors.verticalCenter: parent.verticalCenter
                        x: 130
                        text: notif_name
                        font.family: "Fixedsys Excelsior"
                        font.pixelSize: notif_font_size * 21
                        color: "yellow"
                    }

                    Image {
                        source: (notif_image) ? notif_image : "assets/null.png"
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

                    Text { 
                        anchors.verticalCenter: parent.verticalCenter
                        x: 15
                        text: notif_summary
                        font.family: "Fixedsys Excelsior"
                        font.pixelSize: notif_font_size * 16
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

                    Text { 
                        width: parent.width
                        wrapMode: Text.WordWrap
                        y: 15
                        x: 15
                        text: notif_body
                        font.family: "Fixedsys Excelsior"
                        font.pixelSize: notif_font_size * 12
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
        implicitWidth: 5
    }

    PanelWindow{
        color: "white"
        anchors {
            top: true
            bottom: true
            left: true
        }
        implicitWidth: 5
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
        implicitHeight: 5
    }

    // Top Bar
    PanelWindow{
        color: "black"
        anchors {
            top: true
            right: true
            left: true
        }

        margins {
            top: a_margins
            bottom: a_margins
            right: a_margins
            left: a_margins
        }

        implicitHeight: 120

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "white"
            border.width: border_width

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
                    
                    Button { 
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
                            border.width: border_width
                        }

                        onClicked: {
                            active_page = name
                        }
                    }


                    Button { 
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
                            border.width: border_width
                        }

                        onClicked: {
                            active_page = name
                        }
                    }

                    Button { 
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
                            border.width: border_width
                        }

                        onClicked: {
                            active_page = name
                        }
                    }

                    Button { 
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
                            border.width: border_width
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


