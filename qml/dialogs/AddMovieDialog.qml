import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: addMovieDialog
    
    // Accept only if title is not empty
    canAccept: titleField.text.trim() !== ""
    
    DialogHeader {
        id: dialogHeader
        title: qsTr("Добавить фильм")
        acceptText: qsTr("Добавить")
        cancelText: qsTr("Отмена")
    }
    
    Column {
        anchors {
            top: dialogHeader.bottom
            left: parent.left
            right: parent.right
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
        }
        spacing: Theme.paddingLarge
        
        Label {
            text: qsTr("Название фильма:")
            color: Theme.highlightColor
        }
        
        TextField {
            id: titleField
            width: parent.width
            placeholderText: qsTr("Введите название")
            label: qsTr("Название")
            // Trim input text to remove leading/trailing spaces
            inputMethodHints: Qt.ImhNoPredictiveText
            EnterKey.enabled: text.trim().length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-accept"
            EnterKey.onClicked: addMovieDialog.accept()
        }
    }
    
    onAccepted: {
        // Add the movie and close the dialog
        movieManager.addMovie(titleField.text.trim())
    }
} 