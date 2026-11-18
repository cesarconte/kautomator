/****************************************************************************
** Meta object code from reading C++ file 'workflowrepository.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.12.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/gui/workflowrepository.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'workflowrepository.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN18WorkflowRepositoryE_t {};
} // unnamed namespace

template <> constexpr inline auto WorkflowRepository::qt_create_metaobjectdata<qt_meta_tag_ZN18WorkflowRepositoryE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "WorkflowRepository",
        "workflowsChanged",
        "",
        "filteredWorkflowsChanged",
        "currentCategoryChanged",
        "searchQueryChanged",
        "selectedWorkflowIdChanged"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'workflowsChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'filteredWorkflowsChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'currentCategoryChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'searchQueryChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'selectedWorkflowIdChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<WorkflowRepository, qt_meta_tag_ZN18WorkflowRepositoryE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject WorkflowRepository::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN18WorkflowRepositoryE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN18WorkflowRepositoryE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN18WorkflowRepositoryE_t>.metaTypes,
    nullptr
} };

void WorkflowRepository::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<WorkflowRepository *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->workflowsChanged(); break;
        case 1: _t->filteredWorkflowsChanged(); break;
        case 2: _t->currentCategoryChanged(); break;
        case 3: _t->searchQueryChanged(); break;
        case 4: _t->selectedWorkflowIdChanged(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (WorkflowRepository::*)()>(_a, &WorkflowRepository::workflowsChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (WorkflowRepository::*)()>(_a, &WorkflowRepository::filteredWorkflowsChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (WorkflowRepository::*)()>(_a, &WorkflowRepository::currentCategoryChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (WorkflowRepository::*)()>(_a, &WorkflowRepository::searchQueryChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (WorkflowRepository::*)()>(_a, &WorkflowRepository::selectedWorkflowIdChanged, 4))
            return;
    }
}

const QMetaObject *WorkflowRepository::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *WorkflowRepository::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN18WorkflowRepositoryE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int WorkflowRepository::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 5;
    }
    return _id;
}

// SIGNAL 0
void WorkflowRepository::workflowsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void WorkflowRepository::filteredWorkflowsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void WorkflowRepository::currentCategoryChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void WorkflowRepository::searchQueryChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void WorkflowRepository::selectedWorkflowIdChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}
QT_WARNING_POP
