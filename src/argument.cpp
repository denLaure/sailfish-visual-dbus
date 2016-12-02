#include "argument.h"

Argument::Argument() {}

Argument::Argument(QString type, QString name) {
    _type = type;
    _name = name;
}

void Argument::setType(QString type) {
    _type = type;
    emit typeChanged();
}

void Argument::setName(QString name) {
    _name = name;
    emit nameChanged();
}

QString Argument::type() {
    return _type;
}

QString Argument::name() {
    return _name;
}

