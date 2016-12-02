#ifndef ARGUMENT_H
#define ARGUMENT_H

#include <QObject>

class Argument : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
public:
    Argument();
    Argument(QString type, QString name = "");
    void setType(QString type);
    void setName(QString name);
    QString type();
    QString name();
signals:
    void typeChanged();
    void nameChanged();
private:
    QString _type;
    QString _name;
};

#endif // ARGUMENT_H
