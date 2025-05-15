import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    PageHeader {
        id: header
        title: qsTr("Любимые фильмы")
    }

    SilicaFlickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        
        // PullDownMenu for refresh action
        PullDownMenu {
            MenuItem {
                text: qsTr("Обновить")
                onClicked: loadMoviesToModel()
            }
        }

        SilicaListView {
            id: movieListView
            anchors.fill: parent
            
            // List model for movies
            model: ListModel {
                id: movieListModel
            }
            
            // Delegate for displaying movie items
            delegate: ListItem {
                id: movieItem
                
                contentHeight: Theme.itemSizeMedium
                
                Label {
                    id: titleLabel
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.horizontalPageMargin
                        rightMargin: Theme.horizontalPageMargin
                    }
                    text: model.title
                    color: movieItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    truncationMode: TruncationMode.Fade
                }
                
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("MovieDetailPage.qml"), { movieId: model.id })
                }
            }
            
            // Placeholder when there are no movies
            ViewPlaceholder {
                enabled: movieListView.count === 0
                text: qsTr("Нет фильмов")
                hintText: qsTr("Нажмите кнопку внизу, чтобы добавить фильм")
            }
        }
        
        VerticalScrollDecorator { flickable: movieListView }
    }
    
    // Button to add a new movie
    Button {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge
        }
        text: qsTr("Добавить фильм")
        onClicked: pageStack.push(Qt.resolvedUrl("../dialogs/AddMovieDialog.qml"))
    }
    
    // Function to load movies from MovieManager to the ListModel
    function loadMoviesToModel() {
        movieListModel.clear()
        var movies = movieManager.getMovies()
        for (var i = 0; i < movies.length; i++) {
            movieListModel.append({
                "id": movies[i].id,
                "title": movies[i].title
            })
        }
    }
    
    // Connect to moviesChanged signal to update UI when data changes
    Connections {
        target: movieManager
        onMoviesChanged: {
            loadMoviesToModel()
        }
    }
    
    // Load movies when the page is created
    Component.onCompleted: {
        loadMoviesToModel()
    }
}
