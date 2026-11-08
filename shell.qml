import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick.Controls
import QMLTermWidget
import "scripts/colours.js" as Colours


ShellRoot {
    id: root

    property var track: true

    property var active_page: "Desktop"

    property var notif_image: ""
    
    property var notif_name: "user"

    property var notif_summary: "text"

    property var notif_body: ""

    Item {

    }
    ListModel {
        id: settingsModel
        
        ListElement {            
            properties: [
                ListElement {
                name: "test_property1"
                current_value: 2
                max_value: 5
                min_value: 0
                },
                ListElement {
                name: "test_property2"
                current_value: 1
                max_value: 3
                min_value: 1
                },
                ListElement {
                name: "test_property3"
                current_value: 8
                max_value: 10
                min_value: 0
                }
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
            console.log(Config.notifications.tracked)

        }
    }

    PanelWindow { // Viewer Page
        id: viewer_page
        property var name: "Viewer"

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

            Text {
                color: "white"
                font.pixelSize: 64
                text: "WORK IN PROGRESS"
                font.family: "Fixedsys Excelsior"

                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
        }
    }


    PanelWindow { // Settings Page
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
            left: 5
            right: 5
            bottom: 5
        }

        Rectangle { 
            
            anchors.fill: parent
            color: "black"
            border.color: "white"
            border.width: 5

            Rectangle {
                anchors.fill: parent
                anchors.margins: 10
                color: "transparent"

                ColumnLayout {
                    spacing: 5
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Repeater {
                        model: settingsModel

                        delegate: Rectangle { // Category

                            id: entry
                            required property int index

                            property var h: 100
                            property var num: 0
                            property bool dropped: false

                            Layout.fillWidth: true

                            implicitHeight: entry.h

                            color: "transparent"

                            border.color: "white"

                            border.width: 5

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


                            Text {
                                x: 75
                                color: "white"
                                text: "coordinates"
                                font.pixelSize: 64
                                font.family: "Fixedsys Excelsior"
                                y: 20
                            }

                            Rectangle {
                                id: audio
                                color: "transparent"
                                anchors.fill: parent
                                anchors.topMargin: 100

                                
                                ColumnLayout { 

                                    spacing: 0
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: 50

                                    Repeater {
                                        
                                        model: (dropped == true) ? num : 0
                                        delegate: Rectangle { // Individual Properties
                                            id: rec
                                            required property int index
                                            color: "transparent"
                                            border.color: "white"
                                            border.width: 5
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

                                                font.pixelSize: 64 
                                            }

                                            Rectangle {
                                                color: "transparent"
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.left: parent.left
                                                anchors.margins: 10
                                                implicitWidth: 250
                                                implicitHeight: parent.height
                                                border.color: "yellow"
                                                border.width: 5
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
                                                border.width: 5

                                                Rectangle {
                                                    color: "transparent"
                                                    anchors.top: parent.top
                                                    anchors.bottom: parent.bottom
                                                    anchors.left: parent.left
                                                    anchors.margins: 10
                                                    implicitWidth: parent.height - 10
                                                    implicitHeight: parent.height

                                                    border.color: "lime"
                                                    border.width: 5

                                                    Button {
                                                        anchors.fill: parent
                                                        background: Rectangle {
                                                            color: "transparent"
                                                        }
                                                        onClicked: {
                                                            
                                                            (value_buttons.current_value != value_buttons.max_value) ? settingsModel.get(entry.index).properties.setProperty(index, "current_value", (value_buttons.current_value + 1)) : ""
                                                            
                                                            console.log(settingsModel.get(entry.index).properties.get(index).current_value)

                                                        }
                                                    }
                                                    Text {
                                                        text: "+"
                                                        color: "lime"
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                        font.family: "Fixedsys Excelsior"

                                                        font.pixelSize: 48
                                                    }
                                                }

                                                Rectangle {
                                                    color: "transparent"
                                                    anchors.top: parent.top
                                                    anchors.bottom: parent.bottom
                                                    anchors.right: parent.right
                                                    anchors.margins: 10
                                                    implicitWidth: parent.height - 10
                                                    implicitHeight: parent.height

                                                    border.color: "lime"
                                                    border.width: 5
                                                    Button {
                                                        anchors.fill: parent
                                                        background: Rectangle {
                                                            color: "transparent"
                                                        }
                                                        onClicked: {
                                                            (value_buttons.current_value != value_buttons.min_value) ? settingsModel.get(entry.index).properties.setProperty(index, "current_value", (value_buttons.current_value - 1)) : ""

                                                            // settingsModel.get(entry.index).properties.setProperty(index, "current_value", (value_buttons.current_value - 1))
                                                            console.log(settingsModel.get(entry.index).properties.get(index).min_value)
                                                            console.log(settingsModel.get(entry.index).properties.get(index).current_value)

                                                        }
                                                    }

                                                    Text {
                                                        text: "-"
                                                        color: "lime"
                                                        anchors.verticalCenter: parent.verticalCenter
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                        font.family: "Fixedsys Excelsior"

                                                        font.pixelSize: 48
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
                                                anchors.margins: 10
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
                                                            property int max: settingsModel.get(entry.index).properties.get(rec.index).max_value // max value

                                                            //property int max: settingsModel.get(entry.index).properties.get(index).max_value
                                                            color: (thingy.current_value <= (index)) ? "transparent" : Colours.colour("rgb(255,0,0)", "rgb(0,255,0)", max - 1, index)
                                                            
                                                            height: parent.height
                                                            Layout.fillWidth: true

                                                            Component.onCompleted: {
                                                                console.log("max" + max + "index" + rec.index)
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
    }



    PanelWindow { // Console Page
        id: console_page
        property var name: "Console"

        ListModel {
            id: commands
            ListElement {
                name: "sv.ping"
                description: "Pings the server[s]"
            }
            ListElement {
                name: "sv.target 'name'"
                description: "Set compass target"
            }
            ListElement {
                name: "sv.target reset"
                description: "Reset compass"
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
            left: 5
            right: 5
            bottom: 5
        }

        Rectangle { 
            
            anchors.fill: parent
            color: "black"
            border.color: "white"
            border.width: 5
            
            Rectangle { // Right Side
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width / 3.05
                color: "black"
                border.width: 5
                border.color: "white"
                anchors.margins: 10

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
            
            Rectangle { // Left Side
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width / 1.5
                color: "transparent"
                anchors.margins: 10
                border.color: "white"
                border.width: 5

                Rectangle { // Top
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 150
                    color: "transparent"
                    border.color: "white"
                    border.width: 5
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
                        text: "rah"

                    }

                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 100
                    color: "transparent"
                    border.color: "white"
                    border.width: 5

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
                            console.log(text)
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
        color: "black"
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



