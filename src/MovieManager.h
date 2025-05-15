#ifndef MOVIEMANAGER_H
#define MOVIEMANAGER_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QList>
#include <QString>

class MovieManager : public QObject
{
    Q_OBJECT

public:
    explicit MovieManager(QObject *parent = nullptr);
    ~MovieManager();

    Q_INVOKABLE void loadMovies();
    Q_INVOKABLE void saveMovies();
    Q_INVOKABLE void addMovie(const QString &title);
    Q_INVOKABLE void updateMovie(const QString &id, const QVariantMap &movieData);
    Q_INVOKABLE void deleteMovie(const QString &id);
    Q_INVOKABLE QVariantList getMovies();
    Q_INVOKABLE QVariantMap getMovieById(const QString &id);

signals:
    void moviesChanged();

private:
    QString generateUniqueId();
    QString getMoviesFilePath();
    QList<QVariantMap> m_movies;
};

#endif // MOVIEMANAGER_H 