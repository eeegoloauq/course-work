import QtQuick 2.0
import Sailfish.Silica 1.0

ApplicationWindow {
    objectName: "applicationWindow"
    initialPage: Qt.resolvedUrl("pages/MainPage.qml")
    cover: Qt.resolvedUrl("cover/DefaultCoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
    
    Component.onCompleted: {
        // Load movies when application starts
        movieManager.loadMovies();
    }
    
    Component.onDestruction: {
        // Save movies when application exits
        console.log("Application closing, saving movies data...");
        movieManager.saveMovies();
    }
    
    // Save data when app goes to background
    onApplicationActiveChanged: {
        if (!applicationActive) {
            console.log("Application going to background, saving movies data...");
            movieManager.saveMovies();
        }
    }
}