// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0

Rectangle {
    id: interactiveCodeRoot
    
    x: parent.width / 2
    width: parent.width / 2
    height: parent.height
    
    
    property alias text : textEditItem.text
    property real fontSize: parent.baseFontSize / 2
    
    property Item demoObject

    gradient: Gradient {
        GradientStop { position: 0; color: "white" }
        GradientStop { position: 1; color: "darkGray" }
    }

    color: "lightGray"
    border.color: "darkGray"
    border.width: 2
    radius: 10
    
    Flickable {
        id: textItem
   
        width: parent.width - 20
        height: parent.height - 70
        
        anchors.margins: 20
        
        anchors.top: parent.top
        anchors.left: parent.left
        
        contentWidth: textEditItem.paintedWidth
        contentHeight: textEditItem.paintedHeight
        clip: true
   
        function ensureVisible(r)
        {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }
   
        TextEdit {
            id: textEditItem
            

            width: textItem.width
            height: textItem.height
            
            selectByMouse: true
            
            font.family: "courier"
            font.pixelSize: interactiveCodeRoot.fontSize
            
            focus: true
            wrapMode: TextEdit.Wrap
            onCursorRectangleChanged: textItem.ensureVisible(cursorRectangle)
        }
    }
    
    Item {
        id: controlButtonsContainer
        
        height: 40
        width: 170
        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: textItem.bottom
        
        Rectangle {
            id: runButton
            
            height: parent.height
            width: 80
            
            anchors.left: parent.left
            anchors.top: parent.top
            
            color: "blue"
            smooth: true
            radius: 5
            
            Text {text: "Run"; anchors.centerIn: parent}
            
            MouseArea {
                id: runButtonArea
                
                anchors.fill: parent
                
                hoverEnabled: true
                
                onClicked: {
                    if (demoObject !== null)
                        demoObject.destroy()
                    
                    demoHeaderContainer.visible = true
                    demoCodeContainer.visible = true
                    
                    demoObject = Qt.createQmlObject('import QtQuick 2.0; Item {anchors.fill: parent;'+
                                                    interactiveCodeRoot.text + '}'
                                                    , demoCodeContainer, "demoCodeItem");
                    
//                    if (demoObject === null) {
//                        demoCodeErrorText.visible = true
//                    }
                    
                }
                
                states: [
                    State {
                        name: "entered"
                        when: runButtonArea.containsMouse
                        PropertyChanges {
                            target: runButton
                            color: "lightblue"
                        }
                    }
                ]
            }
        }
        
        Rectangle {
            id: stopButton
            
            height: parent.height
            width: 80
            
            anchors.right: parent.right
            anchors.top: parent.top
            
            color: "blue"
            smooth: true
            radius: 5
            
            Text {text: "Stop"; anchors.centerIn: parent}
            
            MouseArea {
                id: closeButtonArea
                
                anchors.fill: parent
                
                hoverEnabled: true
                
                onClicked: {
                    if (demoObject !== null)
                        demoObject.destroy()
//                    demoCodeErrorText.visible = false
                    demoHeaderContainer.visible = false
                    demoCodeContainer.visible = false
                    demoHeaderContainer.x = 0
                    demoHeaderContainer.y = interactiveCodeRoot.y
                }
                
                states: [
                    State {
                        name: "entered"
                        when: closeButtonArea.containsMouse
                        PropertyChanges {
                            target: stopButton
                            color: "lightblue"
                        }
                    }
                ]
            }
        }        
    }
        
    Item {
        id: demoHeaderContainer
        
        height: 15
        width: parent.width
        
        visible: false
        
        Gradient {
            id: normalHeaderGradient
            GradientStop { position: 0; color: "white"      }
            GradientStop { position: 0.5; color: "darkGray" }
            GradientStop { position: 1; color: "white"      }
        }
        
        Gradient {
            id: hoverHeaderGradient
            GradientStop { position: 0; color: "darkgrey" }
            GradientStop { position: 0.5; color: "white"  }
            GradientStop { position: 1; color: "darkgrey" }
        }
        
        Rectangle {
            id: demoHeader
            
            height: parent.height
            width: parent.width - 15
            
            anchors.top: parent.top
            anchors.left: parent.left
            
            gradient: normalHeaderGradient
            
            Text {
                text: "Demo"
                anchors.centerIn: parent
            }
            
            MouseArea {
                id: demoContainerDragArea
                
                anchors.fill: parent
                
                hoverEnabled: true
                
                drag.target: demoHeaderContainer
                
                states: [
                    State {
                        name: "entered"
                        when: demoContainerDragArea.containsMouse
                        PropertyChanges {
                            target: demoHeader
                            gradient: hoverHeaderGradient
                        }
                    }
                ]
            }
        }
        
        Rectangle {
            id: demoCloseButton
            
            height: parent.height
            width: 15

            anchors.top: parent.top
            anchors.right: parent.right
            
            gradient: Gradient {
                GradientStop { position: 0;   color: "white" }
                GradientStop { position: 0.5; color: "darkGray" }
                GradientStop { position: 1;   color: "white" }
            }
            
            Rectangle {
                id: demoCloseButtonBg
                
                anchors.fill: parent
                
                radius: parent.width / 2
                
                color: "white"
                
                border.color: "black"
                border.width: 1
            }
            
            Text {
                text: "X"
                
                font.pointSize: 10
                anchors.centerIn: parent
            }
            
            MouseArea {
                id: demoCloseArea
                
                anchors.fill: parent
                
                hoverEnabled: true
                
                onClicked: {
                    if (demoObject !== null)
                        demoObject.destroy()
                    demoHeaderContainer.visible = false
                    demoCodeContainer.visible = false
//                    demoCodeErrorText.visible = false
                    
                    demoHeaderContainer.x = 0
                    demoHeaderContainer.y = interactiveCodeRoot.y
                }
                
                states: [
                    State {
                        name: "entered"
                        when: demoCloseArea.containsMouse
                        PropertyChanges {
                            target: demoCloseButtonBg
                            color: "pink"
                        }
                    }
                ]
            }
        }
        
        Rectangle {
            anchors.fill: parent
            
            color:"transparent"
            
            border.color: "black"
            border.width: 1
        }
    }
    
    Item {
        id: demoCodeContainer
        
        width: parent.width
        height: parent.height - 15 - controlButtonsContainer.height - 10
        
        visible: false
        
        anchors.top: demoHeaderContainer.bottom
        anchors.left: demoHeaderContainer.left
        
        Rectangle {
            opacity: 0.8
            anchors.fill: parent
            
            border.color: "black"
            border.width: 1
        }
        
        
        Text {
            id: demoCodeErrorText
            
            anchors.centerIn: parent
            
            text: "Erreur de chargement !"
            
            visible: (demoObject === null)
            
            font.pointSize: 30
        }
        
    }
}
