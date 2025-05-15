import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: movieDetailPage
    allowedOrientations: Orientation.All
    
    // Movie ID property passed when navigating to this page
    property string movieId
    // Current movie data
    property var currentMovie: ({})
    
    // Function to resolve image path properly
    function resolveImagePath(path) {
        // If no path is set, return empty string to hide the image
        if (!path || path === "") return ""
        
        // Make sure we have a string
        path = String(path);
        
        // If it's just a filename without path separators, first try to load from resources
        if (path.indexOf("/") === -1 && path.indexOf("\\") === -1) {
            return "qrc:///images/" + path
        }
        
        // For external files, use file:// prefix if not already present
        return path.indexOf("file://") === 0 ? path : "file://" + path
    }
    
    PageHeader {
        id: header
        title: currentMovie ? currentMovie.title : qsTr("Детали фильма")
    }
    
    // Confirmation dialog for deletions
    Component {
        id: deleteConfirmDialog
        
        Dialog {
            id: deleteDialog
            
            DialogHeader {
                title: qsTr("Удалить фильм")
                acceptText: qsTr("Удалить")
                cancelText: qsTr("Отмена")
            }
            
            Label {
                anchors {
                    top: parent.top
                    topMargin: header.height + Theme.paddingLarge
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }
                text: qsTr("Вы действительно хотите удалить фильм \"%1\"?").arg(currentMovie.title)
                wrapMode: Text.Wrap
                color: Theme.highlightColor
            }
            
            onAccepted: {
                deleteCurrentMovie()
            }
        }
    }
    
    SilicaFlickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentHeight: detailsColumn.height + Theme.paddingLarge * 2
        
        Column {
            id: detailsColumn
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }
            spacing: Theme.paddingLarge
            
            // Image is only visible when a path is provided
            Item {
                id: imageContainer
                width: parent.width
                // Height is collapsed when no image
                height: posterImage.status === Image.Ready ? posterImage.height : 0
                
                Image {
                    id: posterImage
                    width: parent.width
                    height: width * 1.5 // Typical movie poster aspect ratio
                    fillMode: Image.PreserveAspectFit
                    source: resolveImagePath(currentMovie ? currentMovie.posterPath : "")
                    visible: status === Image.Ready
                    
                    // Add loading and error states
                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.log("Error loading image: " + source)
                            visible = false
                        }
                    }
                }
            }
            
            // Instructions for the user
            Label {
                width: parent.width
                text: qsTr("Примечание: для изображения из ресурсов приложения введите только имя файла (например, leva.jpg)")
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                wrapMode: Text.Wrap
            }
            
            TextField {
                id: titleField
                width: parent.width
                label: qsTr("Название")
                placeholderText: qsTr("Название фильма")
                text: currentMovie ? currentMovie.title : ""
            }
            
            TextField {
                id: yearField
                width: parent.width
                label: qsTr("Год")
                placeholderText: qsTr("Год выпуска")
                text: currentMovie ? currentMovie.year : ""
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator {
                    bottom: 1900
                    top: 2100
                }
                // Force only numeric input
                onTextChanged: {
                    if (text.match(/\D/)) {
                        var cursorPosition = cursorPosition;
                        text = text.replace(/\D/g, '');
                        cursorPosition = cursorPosition;
                    }
                }
            }
            
            TextField {
                id: countryField
                width: parent.width
                label: qsTr("Страна")
                placeholderText: qsTr("Страна производства")
                text: currentMovie ? currentMovie.country : ""
            }
            
            TextField {
                id: genreField
                width: parent.width
                label: qsTr("Жанр")
                placeholderText: qsTr("Жанр фильма")
                text: currentMovie ? currentMovie.genre : ""
            }
            
            TextArea {
                id: descriptionField
                width: parent.width
                label: qsTr("Описание")
                placeholderText: qsTr("Описание фильма...")
                text: currentMovie ? currentMovie.description : ""
            }
            
            TextField {
                id: posterPathField
                width: parent.width
                label: qsTr("Путь к изображению")
                placeholderText: qsTr("Например: leva.jpg")
                text: currentMovie ? currentMovie.posterPath : ""
                onTextChanged: {
                    // Preview the image on text change (optional - keep commented if not wanted)
                    // posterImage.source = resolveImagePath(text)
                }
            }
            
            Button {
                text: qsTr("Сохранить изменения")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: saveChanges()
            }
            
            Button {
                text: qsTr("Удалить фильм")
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.errorColor
                onClicked: pageStack.push(deleteConfirmDialog)
            }
        }
        
        VerticalScrollDecorator {}
    }
    
    // Function to load movie details
    function loadMovieDetails() {
        var movie = movieManager.getMovieById(movieId)
        if (Object.keys(movie).length > 0) {
            currentMovie = movie
        } else {
            // Handle case where movie is not found
            pageStack.pop()
        }
    }
    
    // Function to save changes
    function saveChanges() {
        var movieData = {
            title: titleField.text.trim(),
            posterPath: posterPathField.text.trim(),
            description: descriptionField.text.trim(),
            year: yearField.text.trim(),
            country: countryField.text.trim(),
            genre: genreField.text.trim()
        }
        
        movieManager.updateMovie(movieId, movieData)
        // Notify user of success
        pageStack.pop()
    }
    
    // Function to delete the current movie
    function deleteCurrentMovie() {
        movieManager.deleteMovie(movieId)
        pageStack.pop()
    }
    
    // Load movie details when page is created
    Component.onCompleted: {
        loadMovieDetails()
    }
} 