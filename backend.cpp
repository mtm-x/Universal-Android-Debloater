#include <QObject>
#include <QString>
#include <QDebug>
#include <cstdio>
#include <QStringList>
#include "backend.h"

QString processCommand ( const char* command){
    QString result = "";
    char buffer[MAX_BUFFER_SIZE];

    FILE* pipe = popen(command, "r");

    if (!pipe) {
        qDebug() << "Error opening pipe.";
        return "error";
    }

    while (fgets(buffer,MAX_BUFFER_SIZE,pipe)){
        result+=buffer;
    }

    pclose(pipe);

    return result;
}

Backend::Backend(QObject *parent)
    : QObject{parent}
{
}

QString Backend::checkDevice()

{
    QString deviceId = "";
    qDebug() << "checking device";
    QString result = processCommand("adb devices");
    qDebug() << result ;
    QStringList lines = result.split('\n', Qt::SkipEmptyParts);

    if (lines.size() < 2) {
        qDebug() << "No devices found or unexpected output format.";
        qDebug() << lines.size();
        deviceId = "No devices connected.";
        return deviceId;
    }

    QString deviceLine = lines.at(1).trimmed();
    QStringList parts = deviceLine.split('\t', Qt::SkipEmptyParts);

    if (parts.size() >= 1) {

        deviceId = parts.at(0).trimmed();
        qDebug() << "Extracted Device ID:" << deviceId;
    }

    else {
        qDebug() << "Could not parse device ID from line:" << deviceLine;

    }

    return deviceId;
}

QStringList Backend::loadPackages(){

    qDebug() << "Retriving packages";

    QString result = processCommand("adb shell pm list packages");
    pkgName = result.split('\n', Qt::SkipEmptyParts);

    for (QString &currentString : pkgName) {
        currentString.replace("package:", "", Qt::CaseSensitive);
        currentString = currentString.trimmed();
    }

    qDebug() << pkgName;
    return pkgName;

}

QStringList Backend::appName (QString ApplicationName){

    QStringList pkgname_search;
    pkgname_search = pkgName.filter(ApplicationName, Qt::CaseInsensitive);
    return pkgname_search;
}

QString Backend::appUninstall(QString ApplicationName){

    QString process;
    QString command;

    command = QString("adb shell pm uninstall --user 0 %1").arg(ApplicationName);

    QByteArray commandBytes = command.toLocal8Bit();
    const char *cCommand = commandBytes.constData();

    process = processCommand(cCommand);
    qDebug() << process ;

    if ( process == "Success\n") return "Uninstalled Successfully";
    else return "Failed";

}

