#include "MovieManager.h"
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QStandardPaths>
#include <QDateTime>
#include <QDebug>

MovieManager::MovieManager(QObject *parent) : QObject(parent)
{
    loadMovies();
}

MovieManager::~MovieManager()
{
    qDebug() << "MovieManager destructor called, saving movies...";
    saveMovies();
}

void MovieManager::loadMovies()
{
    m_movies.clear();
    
    QString filePath = getMoviesFilePath();
    QFile file(filePath);
    
    if (!file.exists()) {
        qDebug() << "Movies file doesn't exist yet:" << filePath;
        emit moviesChanged();
        return;
    }
    
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open movies file:" << file.errorString();
        emit moviesChanged();
        return;
    }
    
    QByteArray jsonData = file.readAll();
    file.close();
    
    QJsonDocument document = QJsonDocument::fromJson(jsonData);
    if (document.isNull() || !document.isArray()) {
        qWarning() << "Invalid JSON format in movies file";
        emit moviesChanged();
        return;
    }
    
    QJsonArray moviesArray = document.array();
    for (const QJsonValue &value : moviesArray) {
        if (value.isObject()) {
            QJsonObject obj = value.toObject();
            QVariantMap movie;
            
            movie["id"] = obj["id"].toString();
            movie["title"] = obj["title"].toString();
            movie["posterPath"] = obj["posterPath"].toString();
            movie["description"] = obj["description"].toString();
            movie["year"] = obj["year"].toString();
            movie["country"] = obj["country"].toString();
            movie["genre"] = obj["genre"].toString();
            
            m_movies.append(movie);
        }
    }
    
    qDebug() << "Successfully loaded" << m_movies.size() << "movies from file";
    emit moviesChanged();
}

void MovieManager::saveMovies()
{
    QString filePath = getMoviesFilePath();
    QFile file(filePath);
    
    // Ensure the directory exists
    QDir dir;
    QString dirPath = QFileInfo(filePath).path();
    if (!dir.exists(dirPath)) {
        qDebug() << "Creating directory for movies file:" << dirPath;
        if (!dir.mkpath(dirPath)) {
            qWarning() << "Failed to create directory for movies file:" << dirPath;
            return;
        }
    }
    
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "Failed to open movies file for writing:" << file.errorString();
        return;
    }
    
    QJsonArray moviesArray;
    
    for (const QVariantMap &movie : m_movies) {
        QJsonObject obj;
        obj["id"] = movie["id"].toString();
        obj["title"] = movie["title"].toString();
        obj["posterPath"] = movie["posterPath"].toString();
        obj["description"] = movie["description"].toString();
        obj["year"] = movie["year"].toString();
        obj["country"] = movie["country"].toString();
        obj["genre"] = movie["genre"].toString();
        
        moviesArray.append(obj);
    }
    
    QJsonDocument document(moviesArray);
    QByteArray jsonData = document.toJson();
    
    qint64 bytesWritten = file.write(jsonData);
    if (bytesWritten != jsonData.size()) {
        qWarning() << "Failed to write all data to movies file:" << bytesWritten << "of" << jsonData.size() << "bytes written";
    } else {
        qDebug() << "Successfully saved" << m_movies.size() << "movies to file:" << filePath;
    }
    
    // Make sure data is written to disk
    file.flush();
    file.close();
}

void MovieManager::addMovie(const QString &title)
{
    QVariantMap movie;
    movie["id"] = generateUniqueId();
    movie["title"] = title;
    movie["posterPath"] = "";
    movie["description"] = "";
    movie["year"] = "";
    movie["country"] = "";
    movie["genre"] = "";
    
    m_movies.append(movie);
    saveMovies();
    emit moviesChanged();
}

void MovieManager::updateMovie(const QString &id, const QVariantMap &movieData)
{
    for (int i = 0; i < m_movies.size(); ++i) {
        if (m_movies[i]["id"].toString() == id) {
            // Create a local copy of movieData that we can modify
            QVariantMap updatedMovie = movieData;
            // Preserve the ID
            updatedMovie["id"] = id;
            m_movies[i] = updatedMovie;
            saveMovies();
            emit moviesChanged();
            return;
        }
    }
    
    qWarning() << "Movie with ID" << id << "not found for update";
}

void MovieManager::deleteMovie(const QString &id)
{
    for (int i = 0; i < m_movies.size(); ++i) {
        if (m_movies[i]["id"].toString() == id) {
            m_movies.removeAt(i);
            saveMovies();
            emit moviesChanged();
            return;
        }
    }
    
    qWarning() << "Movie with ID" << id << "not found for deletion";
}

QVariantList MovieManager::getMovies()
{
    QVariantList result;
    for (const QVariantMap &movie : m_movies) {
        result.append(movie);
    }
    return result;
}

QVariantMap MovieManager::getMovieById(const QString &id)
{
    for (const QVariantMap &movie : m_movies) {
        if (movie["id"].toString() == id) {
            return movie;
        }
    }
    
    return QVariantMap(); // Empty map if not found
}

QString MovieManager::generateUniqueId()
{
    // Simple timestamp-based ID generator
    return QString::number(QDateTime::currentMSecsSinceEpoch());
}

QString MovieManager::getMoviesFilePath()
{
    QString dataLocation = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    return dataLocation + "/movies.json";
} 