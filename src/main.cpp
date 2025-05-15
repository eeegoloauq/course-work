#include <auroraapp.h>
#include <QtQuick>
#include "MovieManager.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(Aurora::Application::application(argc, argv));
    application->setOrganizationName(QStringLiteral("ru.template"));
    application->setApplicationName(QStringLiteral("study"));

    // Create and register the MovieManager
    QScopedPointer<MovieManager> movieManager(new MovieManager());

    QScopedPointer<QQuickView> view(Aurora::Application::createView());
    
    // Set the MovieManager as a context property
    view->rootContext()->setContextProperty("movieManager", movieManager.data());
    
    view->setSource(Aurora::Application::pathTo(QStringLiteral("qml/study.qml")));
    view->show();

    return application->exec();
}
