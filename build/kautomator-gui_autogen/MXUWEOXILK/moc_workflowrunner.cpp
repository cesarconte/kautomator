/****************************************************************************
** Meta object code from reading C++ file 'workflowrunner.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.12.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/gui/workflowrunner.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'workflowrunner.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.12.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN14WorkflowRunnerE_t {};
} // unnamed namespace

template <> constexpr inline auto WorkflowRunner::qt_create_metaobjectdata<qt_meta_tag_ZN14WorkflowRunnerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "WorkflowRunner",
        "executionStarted",
        "",
        "id",
        "title",
        "command",
        "executionFinished",
        "exitCode",
        "output",
        "error",
        "fileSelectionRequested"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'executionStarted'
        QtMocHelpers::SignalData<void(const QString &, const QString &, const QString &)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 3 }, { QMetaType::QString, 4 }, { QMetaType::QString, 5 },
        }}),
        // Signal 'executionFinished'
        QtMocHelpers::SignalData<void(const QString &, const QString &, int, const QString &, const QString &)>(6, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 3 }, { QMetaType::QString, 4 }, { QMetaType::Int, 7 }, { QMetaType::QString, 8 },
            { QMetaType::QString, 9 },
        }}),
        // Signal 'fileSelectionRequested'
        QtMocHelpers::SignalData<void(const QString &, const QString &)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 3 }, { QMetaType::QString, 4 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<WorkflowRunner, qt_meta_tag_ZN14WorkflowRunnerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject WorkflowRunner::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14WorkflowRunnerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14WorkflowRunnerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14WorkflowRunnerE_t>.metaTypes,
    nullptr
} };

void WorkflowRunner::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<WorkflowRunner *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->executionStarted((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[3]))); break;
        case 1: _t->executionFinished((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<int>>(_a[3])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[4])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[5]))); break;
        case 2: _t->fileSelectionRequested((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (WorkflowRunner::*)(const QString & , const QString & , const QString & )>(_a, &WorkflowRunner::executionStarted, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (WorkflowRunner::*)(const QString & , const QString & , int , const QString & , const QString & )>(_a, &WorkflowRunner::executionFinished, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (WorkflowRunner::*)(const QString & , const QString & )>(_a, &WorkflowRunner::fileSelectionRequested, 2))
            return;
    }
}

const QMetaObject *WorkflowRunner::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *WorkflowRunner::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14WorkflowRunnerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int WorkflowRunner::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 3)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 3;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 3)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 3;
    }
    return _id;
}

// SIGNAL 0
void WorkflowRunner::executionStarted(const QString & _t1, const QString & _t2, const QString & _t3)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1, _t2, _t3);
}

// SIGNAL 1
void WorkflowRunner::executionFinished(const QString & _t1, const QString & _t2, int _t3, const QString & _t4, const QString & _t5)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1, _t2, _t3, _t4, _t5);
}

// SIGNAL 2
void WorkflowRunner::fileSelectionRequested(const QString & _t1, const QString & _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1, _t2);
}
QT_WARNING_POP
