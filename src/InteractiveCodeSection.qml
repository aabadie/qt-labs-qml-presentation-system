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
                    
                    demoCodeContainer.visible = true
                    
                    demoObject = Qt.createQmlObject('import QtQuick 2.0; Item {anchors.fill: parent;'+
                                                    interactiveCodeRoot.text + '}'
                                                    , demoCodeContainer, "demoCodeItem");
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
                    demoCodeContainer.visible = false
                    
                    demoCodeContainer.x = 0
                    demoCodeContainer.y = interactiveCodeRoot.y
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
        id: demoCodeContainer
        
        width: parent.width
        height: parent.height - 15 - controlButtonsContainer.height - 10
        
        visible: false
        
        x: 0
        y: interactiveCodeRoot.y
        
        MouseArea {
            id: demoContainerDragArea
            
            anchors.fill: parent
            
            hoverEnabled: true
            
            drag.target: demoCodeContainer
            
            states: [
                State {
                    name: "entered"
                    when: demoContainerDragArea.containsMouse
                    PropertyChanges {
                        target: demoCodeContainerBG
                        color: "Tan"
                    }
                }
            ]
        }
        
        Rectangle {
            id: demoCodeContainerBG
            
            opacity: 0.8
            anchors.fill: parent
            
            border.color: "black"
            border.width: 1
            
            radius: 10
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
