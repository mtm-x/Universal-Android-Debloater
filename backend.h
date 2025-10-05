#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#define MAX_BUFFER_SIZE 128

class Backend : public QObject {

    Q_OBJECT // Must be included for QObject features (signals, slots, Q_INVOKABLE)

private:
    QStringList pkgName;

public:
    explicit Backend(QObject *parent = nullptr);

public slots:
    // Both methods are now correctly declared as slots/invokable
    QString checkDevice();
    QStringList loadPackages();
    QStringList appName(QString ApplicationName);
    QString appUninstall(QString ApplicationName);

};

#endif // BACKEND_H
