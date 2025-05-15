# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = ru.template.study

CONFIG += \
    auroraapp

# Отключаем подписывание пакетов для разработки
CONFIG += no_signing_warning
CONFIG += no_rpm_sign

PKGCONFIG += \

SOURCES += \
    src/main.cpp \
    src/MovieManager.cpp \

HEADERS += \
    src/MovieManager.h \

DISTFILES += \
    images/leva.jpg \
    images/placeholder.png \
    images/profile.jpg \
    rpm/ru.template.study.spec \
    qml/study.qml \
    qml/cover/DefaultCoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/MovieDetailPage.qml \
    qml/dialogs/AddMovieDialog.qml \
    qml/pages/assets/HiddenText.qml \
    ru.template.study.desktop

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.study.ts \
    translations/ru.template.study-ru.ts \

# Add resources file to the project
RESOURCES += resources.qrc

QT += core quick
