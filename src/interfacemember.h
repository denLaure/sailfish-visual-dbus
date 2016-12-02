#ifndef INTERFACEMEMBER_H
#define INTERFACEMEMBER_H

#include <QObject>
#include "argument.h"

/*!
 * Class, which stores information about interface member, including it's name, kind (is it method, signal or property),
 * type and access, if it's a property, input and output arguments
 */
class InterfaceMember : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString kind READ kind WRITE setKind NOTIFY kindChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString access READ access WRITE setAccess NOTIFY accessChanged)
    Q_PROPERTY(QList<QObject*> inputArguments READ inputArguments WRITE setInputArguments NOTIFY inputArgumentsChanged)
    Q_PROPERTY(QList<QObject*> outputArguments READ outputArguments WRITE setOutputArguments NOTIFY outputArgumentsChanged)
public:
    InterfaceMember();
    InterfaceMember(QString name, QString kind, QString type = "", QString access = "",
                    QList<QObject*> inputArguments = QList<QObject*>(),
                    QList<QObject*> outputArguments = QList<QObject*>());
    void setName(QString name);
    void setKind(QString kind);
    void setType(QString type);
    void setAccess(QString access);
    void setInputArguments(QList<QObject*> inputArguments);
    void setOutputArguments(QList<QObject*> outputArguments);
    QString name();
    QString kind();
    QString type();
    QString access();
    QList<QObject*> inputArguments();
    QList<QObject*> outputArguments();
signals:
    void nameChanged();
    void kindChanged();
    void typeChanged();
    void accessChanged();
    void inputArgumentsChanged();
    void outputArgumentsChanged();
private:
    QString _name;
    QString _kind;
    QString _type;
    QString _access;
    QList<QObject*> _inputArguments;
    QList<QObject*> _outputArguments;
};

#endif // INTERFACEMEMBER_H
