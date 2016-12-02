#include "interfacemember.h"

InterfaceMember::InterfaceMember() {}

InterfaceMember::InterfaceMember(QString name, QString kind, QString type, QString access,
                                 QList<QObject*> inputArguments, QList<QObject*> outputArguments) {
    _name = name;
    _kind = kind;
    _type = type;
    _access = access;
    _inputArguments = inputArguments;
    _outputArguments = outputArguments;
}

void InterfaceMember::setName(QString name) {
    _name = name;
    emit nameChanged();
}

void InterfaceMember::setKind(QString kind) {
    _kind = kind;
    emit kindChanged();
}

void InterfaceMember::setType(QString type) {
    _type = type;
    emit typeChanged();
}

void InterfaceMember::setAccess(QString access) {
    _access = access;
    emit accessChanged();
}

void InterfaceMember::setInputArguments(QList<QObject*> inputArguments) {
    _inputArguments = inputArguments;
    emit inputArgumentsChanged();
}

void InterfaceMember::setOutputArguments(QList<QObject*> outputArguments) {
    _outputArguments = outputArguments;
    emit outputArgumentsChanged();
}

QString InterfaceMember::name() {
    return _name;
}

QString InterfaceMember::kind() {
    return _kind;
}

QString InterfaceMember::type() {
    return _type;
}

QString InterfaceMember::access() {
    return _access;
}

QList<QObject*> InterfaceMember::inputArguments() {
    return _inputArguments;
}

QList<QObject*> InterfaceMember::outputArguments() {
    return _outputArguments;
}

