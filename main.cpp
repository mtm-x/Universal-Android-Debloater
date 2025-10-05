#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "backend.h"
#include <QQmlContext>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    int fontId = QFontDatabase::addApplicationFont(":/fonts/ProductSansRegular.ttf");

    Backend backend;
    // Expose the 'backend' object to QML under the name "cppBackend"
    engine.rootContext()->setContextProperty("cppBackend", &backend);



    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("DroidDebloatCpp", "Main");

    return app.exec();
}
