import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    objectName: "defaultCover"

    CoverTemplate {
        objectName: "applicationCover"
        primaryText: qsTr("Любимые фильмы")
        secondaryText: {
            var movies = movieManager.getMovies();
            return qsTr("Всего фильмов: ") + movies.length;
        }
        icon {
            source: Qt.resolvedUrl("../icons/study.svg")
            sourceSize { width: icon.width; height: icon.height }
        }
    }

    // Connect to moviesChanged signal to update UI when data changes
    Connections {
        target: movieManager
        onMoviesChanged: {
            // Force update by re-querying the movies
            var movies = movieManager.getMovies();
            // The cover will update automatically thanks to the binding
        }
    }

    // Reference to the cover page itself
    id: coverPage
}

