import QtQuick 2.12
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.3

Item {
    id: root
    property alias title: label.text
    property string text: ""
    property alias validator: textField.validator

    width: label.width + textField.width
    height: label.height

    // Emited when edition if finished with enter/return key or when TextField loses focus
    signal editingFinished()

    // This avoid connection interactions while user input is on
    onTextChanged: {
        if(textField.focus) {
            return
        }

        textField.text = text
    }

    TextMetrics {
        id: textMetrics
        font: textField.font
        text: validator.top
    }

    Label {
        id: label
        color: Material.accent
    }

    TextField {
        id: textField

        anchors.left: label.right
        anchors.baseline: label.baseline
        anchors.leftMargin: 5
        selectByMouse: true
        // Change input box style
        rightPadding: leftPadding
        topPadding: 0
        bottomPadding: 0
        horizontalAlignment: TextInput.AlignRight
        property var inputWidth: validator === undefined ? contentWidth : textMetrics.width
        background.implicitWidth: inputWidth + 2*leftPadding
        background.implicitHeight: contentHeight*1.1
        background.y: contentHeight

        // editingFinished() is only emitted when TextField has focus
        // That's why we are using accepted()
        onAccepted: {
            focus = false
            root.parent.forceActiveFocus()
            // It's necessary to update the input variable
            root.text = textField.text
            root.editingFinished()
        }

        onActiveFocusChanged: {
            // TODO: We should update the user about wrong inputs here
            // This allow us to correct not valid inputs to the last valid value
            if(!acceptableInput) {
                textField.text = root.text
            } else {
                root.text = textField.text
            }

            if (activeFocus) {
                selectAll()
            } else {
                deselect()
                root.editingFinished()
            }
        }
    }
}
