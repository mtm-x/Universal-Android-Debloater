import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.Material

Window {
    width: 640
    height: 580
    visible: true
    title: qsTr("Droid Debloat")
    color: "#232323"

    maximumWidth: 640
    maximumHeight: 580
    minimumWidth: 640
    minimumHeight: 580

    property string pkg_clicked: ""

    Rectangle {
        id: mainPage
        width: parent.width
        height: parent.height
        color: "#232323"

        Text {
            id: welcome_main
            text: "Welcome To"
            font.family: "Product Sans"
            font.pixelSize: 26
            font.bold: true
            color: "white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: parent.height / 5.3
        }
        Text {
            text: "Android Debloater !"
            font.family: "Product Sans"
            font.pixelSize: 36
            font.bold: true
            color: "white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: parent.height / 3.7
        }
        Button {
            id: next_but
            text: "Next"
            font.family: "Product Sans"
            width: 100
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 2

            background: Rectangle {
                radius: 6
                color: customButton.down ? "#1E88E5" : (customButton.hovered ? "#42A5F5" : "#2196F3")
                border.color: "#fff"
                border.width: 2
            }
            font.pixelSize: 16


            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    mainPage.visible = false
                    deviceCheck.visible = true
                    // cppBackend.handleButtonClick();

                }
            }
        }
    }

    Rectangle {
        id: deviceCheck
        width: parent.width
        height: parent.height
        visible: false
        color: "#232323"

        Label{
            id : connnectDevice
            font.family: "Product Sans"
            font.pixelSize: 16
            font.bold: true
            color: "white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin:parent.height / 3.5
        }

        Text {
            id : checkinggg
            text: "Check for connected device"
            font.family: "Product Sans"
            font.pixelSize: 26
            font.bold: true
            color: "white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: parent.height / 5.3
        }

        BusyIndicator {
            id: busyIndicator
            anchors.top: parent.top
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: parent.height / 3.5
        }

        Button {
            text: "Check"
            font.family: "Product Sans"
            width: 100
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 2

            background: Rectangle {
                radius: 6
                color: customButton.down ? "#1E88E5" : (customButton.hovered ? "#42A5F5" : "#2196F3")
                border.color: "#fff"
                border.width: 2
            }
            font.pixelSize: 16

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    checkinggg.text = "Checking for connected device..."
                    busyIndicator.visible = true
                    checkDeviceTimer.start()

                }
            }
        }

        Timer {
            id: checkDeviceTimer
            interval: 2000
            running: false
            onTriggered: {
                busyIndicator.visible = false
                var device = cppBackend.checkDevice()
                if (device === "No devices connected."){
                    connnectDevice.text = "No devices connected."
                }
                else{
                    connectedDevice.text = "Connected device : " + device
                    deviceCheck.visible = false
                    searchPage.visible = true
                    packageModel.clear();
                    var packages = cppBackend.loadPackages()
                    for (var i = 0; i < packages.length; i++) {
                        packageModel.append({ "packageName": packages[i] });
                    }
                }
            }
        }
    }

    Rectangle{
        id : searchPage
        width: parent.width
        height: parent.height
        visible: false
        color: "#232323"

        Text {
            text: "Which Application you would like to uninstall"
            font.family: "Product Sans"
            font.pixelSize: 20
            font.bold: true
            color: "white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin:parent.height / 20

        }

        Label{
            id : connectedDevice
            font.family: "Product Sans"
            font.pixelSize: 16
            font.bold: true
            visible: true
            color: "white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin:parent.height / 4
        }

        TextField {
            id: appName
            placeholderText : "Search"
            placeholderTextColor: "#888"
            width: parent.width / 2
            height: 40
            font.family: "Product Sans"
            font.pixelSize: 16
            color: "#000"
            background: Rectangle {
                color: "#fff"
                radius: 6
                border.color: "#ccc"
                border.width: 1
            }
            onPressed: appName.placeholderText=""
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 6
            anchors.topMargin: parent.height / 6.5

        }

        Button{
            id: customButton
            text: "Search"
            width: 100
            height: 50
            font.family: "Product Sans"
            font.pixelSize: 16
            background: Rectangle {
                radius: 6
                color: customButton.down ? "#1E88E5" : (customButton.hovered ? "#42A5F5" : "#2196F3")
                border.color: "#fff"
                border.width: 2
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    packageModel.clear();

                           var packages = cppBackend.appName(appName.text);
                           for (var i = 0; i < packages.length; i++) {
                               packageModel.append({ "packageName": packages[i] });
                           }


                }
            }
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: parent.width / 1.4
            anchors.topMargin: parent.height / 6.8
        }

        ScrollView{

            id : scroll
            width: 600
            height: 400
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 210
            anchors.bottom : parent.bottom
            anchors.bottomMargin: 80

            ScrollBar.vertical: ScrollBar {
                    parent: scroll
                    x: scroll.mirrored ? 0 : scroll.width - width
                    y: scroll.topPadding
                    height: scroll.availableHeight
                    active: scroll.ScrollBar.horizontal.active
                }

            ListView {
                id: packageListView
                anchors.fill: scroll

                model: ListModel {
                    id: packageModel
                }

                delegate: Item {
                    width: scroll.width
                    height: 40

                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "#2E2E2E"
                        border.color: "#AAAAAA"

                        Text {
                            text: model.packageName
                            font.family: "Product Sans"
                            color: "white"
                            anchors.centerIn: parent
                        }

                    }
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            pkg_clicked = model.packageName
                            searchPage.visible = false
                            uninstallPage.visible = true
                            pkgName.text = "Selected Package: "+pkg_clicked
                        }
                    }
                }
            }
        }
    }


    Rectangle{
        id: uninstallPage
        width: parent.width
        height: parent.height
        visible: false
        color: "#232323"


        Text {
            id : pkgName
            font.family: "Product Sans"
            font.pixelSize: 16
            font.bold: true
            color: "white"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: parent.height / 4
        }

        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 3
            spacing: 10
            Button {
                text: "Uninsttall"
                font.family: "Product Sans"
                width: 150
                height: 60

                background: Rectangle {
                    radius: 6
                    color: customButton.down ? "#1E88E5" : (customButton.hovered ? "#42A5F5" : "#2196F3")
                    border.color: "#fff"
                    border.width: 2
                }
                font.pixelSize: 16

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        pkgName.text = cppBackend.appUninstall(pkg_clicked)

                    }
                }
            }

            Button {
                text: "Back"
                font.family: "Product Sans"
                width: 150
                height: 60

                background: Rectangle {
                    radius: 6
                    color: customButton.down ? "#1E88E5" : (customButton.hovered ? "#42A5F5" : "#2196F3")
                    border.color: "#fff"
                    border.width: 2
                }
                font.pixelSize: 16

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        uninstallPage.visible = false
                        searchPage.visible = true
                        appName.text = ""
                        packageModel.clear();
                        var packages = debloater.load_pkgs("");
                        for (var i = 0; i < packages.length; i++) {
                            packageModel.append({ "packageName": packages[i] });
                        }
                    }
                }
            }
        }

    }
}
