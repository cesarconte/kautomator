/****************************************************************************
** Meta object code from reading C++ file 'automatorbackend.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.12.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/gui/automatorbackend.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'automatorbackend.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN16AutomatorBackendE_t {};
} // unnamed namespace

template <> constexpr inline auto AutomatorBackend::qt_create_metaobjectdata<qt_meta_tag_ZN16AutomatorBackendE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "AutomatorBackend",
        "workflowsChanged",
        "",
        "filteredWorkflowsChanged",
        "currentCategoryChanged",
        "searchQueryChanged",
        "viewModeChanged",
        "selectedWorkflowIdChanged",
        "aiStateChanged",
        "daemonStateChanged",
        "fileSelectionRequested",
        "workflowId",
        "title",
        "runWorkflow",
        "id",
        "fileUrl",
        "workflowNeedsFile",
        "createNewWorkflow",
        "updateWorkflow",
        "subtitle",
        "category",
        "color",
        "command",
        "deleteWorkflow",
        "duplicateWorkflow",
        "exportWorkflow",
        "describeChange",
        "prompt",
        "toggleDaemon",
        "runAllFolderRulesNow",
        "openRulesFileInEditor",
        "openSystemKeyboardShortcuts",
        "workflows",
        "QVariantList",
        "filteredWorkflows",
        "currentCategory",
        "searchQuery",
        "viewMode",
        "selectedWorkflowId",
        "selectedWorkflow",
        "QVariantMap",
        "allShortcutsCount",
        "shareSheetCount",
        "quickActionsCount",
        "menuBarCount",
        "automationCount",
        "aiCardHeadline",
        "aiCardQuote",
        "aiCardSubtext",
        "aiBusy",
        "daemonActive"
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
        // Signal 'viewModeChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'selectedWorkflowIdChanged'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'aiStateChanged'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'daemonStateChanged'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'fileSelectionRequested'
        QtMocHelpers::SignalData<void(const QString &, const QString &)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 11 }, { QMetaType::QString, 12 },
        }}),
        // Method 'runWorkflow'
        QtMocHelpers::MethodData<void(const QString &, const QString &)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::QString, 15 },
        }}),
        // Method 'runWorkflow'
        QtMocHelpers::MethodData<void(const QString &)>(13, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'workflowNeedsFile'
        QtMocHelpers::MethodData<bool(const QString &) const>(16, 2, QMC::AccessPublic, QMetaType::Bool, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'createNewWorkflow'
        QtMocHelpers::MethodData<void()>(17, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'updateWorkflow'
        QtMocHelpers::MethodData<void(const QString &, const QString &, const QString &, const QString &, const QString &, const QString &)>(18, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::QString, 12 }, { QMetaType::QString, 19 }, { QMetaType::QString, 20 },
            { QMetaType::QString, 21 }, { QMetaType::QString, 22 },
        }}),
        // Method 'deleteWorkflow'
        QtMocHelpers::MethodData<void(const QString &)>(23, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'duplicateWorkflow'
        QtMocHelpers::MethodData<void(const QString &)>(24, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'exportWorkflow'
        QtMocHelpers::MethodData<void(const QString &)>(25, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'describeChange'
        QtMocHelpers::MethodData<void(const QString &)>(26, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 27 },
        }}),
        // Method 'toggleDaemon'
        QtMocHelpers::MethodData<void()>(28, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'runAllFolderRulesNow'
        QtMocHelpers::MethodData<void()>(29, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'openRulesFileInEditor'
        QtMocHelpers::MethodData<void()>(30, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'openSystemKeyboardShortcuts'
        QtMocHelpers::MethodData<void()>(31, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'workflows'
        QtMocHelpers::PropertyData<QVariantList>(32, 0x80000000 | 33, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'filteredWorkflows'
        QtMocHelpers::PropertyData<QVariantList>(34, 0x80000000 | 33, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 1),
        // property 'currentCategory'
        QtMocHelpers::PropertyData<QString>(35, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 2),
        // property 'searchQuery'
        QtMocHelpers::PropertyData<QString>(36, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 3),
        // property 'viewMode'
        QtMocHelpers::PropertyData<QString>(37, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 4),
        // property 'selectedWorkflowId'
        QtMocHelpers::PropertyData<QString>(38, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'selectedWorkflow'
        QtMocHelpers::PropertyData<QVariantMap>(39, 0x80000000 | 40, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 5),
        // property 'allShortcutsCount'
        QtMocHelpers::PropertyData<int>(41, QMetaType::Int, QMC::DefaultPropertyFlags, 0),
        // property 'shareSheetCount'
        QtMocHelpers::PropertyData<int>(42, QMetaType::Int, QMC::DefaultPropertyFlags, 0),
        // property 'quickActionsCount'
        QtMocHelpers::PropertyData<int>(43, QMetaType::Int, QMC::DefaultPropertyFlags, 0),
        // property 'menuBarCount'
        QtMocHelpers::PropertyData<int>(44, QMetaType::Int, QMC::DefaultPropertyFlags, 0),
        // property 'automationCount'
        QtMocHelpers::PropertyData<int>(45, QMetaType::Int, QMC::DefaultPropertyFlags, 0),
        // property 'aiCardHeadline'
        QtMocHelpers::PropertyData<QString>(46, QMetaType::QString, QMC::DefaultPropertyFlags, 6),
        // property 'aiCardQuote'
        QtMocHelpers::PropertyData<QString>(47, QMetaType::QString, QMC::DefaultPropertyFlags, 6),
        // property 'aiCardSubtext'
        QtMocHelpers::PropertyData<QString>(48, QMetaType::QString, QMC::DefaultPropertyFlags, 6),
        // property 'aiBusy'
        QtMocHelpers::PropertyData<bool>(49, QMetaType::Bool, QMC::DefaultPropertyFlags, 6),
        // property 'daemonActive'
        QtMocHelpers::PropertyData<bool>(50, QMetaType::Bool, QMC::DefaultPropertyFlags, 7),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<AutomatorBackend, qt_meta_tag_ZN16AutomatorBackendE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject AutomatorBackend::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16AutomatorBackendE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16AutomatorBackendE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN16AutomatorBackendE_t>.metaTypes,
    nullptr
} };

void AutomatorBackend::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<AutomatorBackend *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->workflowsChanged(); break;
        case 1: _t->filteredWorkflowsChanged(); break;
        case 2: _t->currentCategoryChanged(); break;
        case 3: _t->searchQueryChanged(); break;
        case 4: _t->viewModeChanged(); break;
        case 5: _t->selectedWorkflowIdChanged(); break;
        case 6: _t->aiStateChanged(); break;
        case 7: _t->daemonStateChanged(); break;
        case 8: _t->fileSelectionRequested((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 9: _t->runWorkflow((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 10: _t->runWorkflow((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 11: { bool _r = _t->workflowNeedsFile((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast<bool*>(_a[0]) = std::move(_r); }  break;
        case 12: _t->createNewWorkflow(); break;
        case 13: _t->updateWorkflow((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[3])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[4])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[5])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[6]))); break;
        case 14: _t->deleteWorkflow((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 15: _t->duplicateWorkflow((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 16: _t->exportWorkflow((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 17: _t->describeChange((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 18: _t->toggleDaemon(); break;
        case 19: _t->runAllFolderRulesNow(); break;
        case 20: _t->openRulesFileInEditor(); break;
        case 21: _t->openSystemKeyboardShortcuts(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)()>(_a, &AutomatorBackend::workflowsChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)()>(_a, &AutomatorBackend::filteredWorkflowsChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)()>(_a, &AutomatorBackend::currentCategoryChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)()>(_a, &AutomatorBackend::searchQueryChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)()>(_a, &AutomatorBackend::viewModeChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)()>(_a, &AutomatorBackend::selectedWorkflowIdChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)()>(_a, &AutomatorBackend::aiStateChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)()>(_a, &AutomatorBackend::daemonStateChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (AutomatorBackend::*)(const QString & , const QString & )>(_a, &AutomatorBackend::fileSelectionRequested, 8))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QVariantList*>(_v) = _t->workflows(); break;
        case 1: *reinterpret_cast<QVariantList*>(_v) = _t->filteredWorkflows(); break;
        case 2: *reinterpret_cast<QString*>(_v) = _t->currentCategory(); break;
        case 3: *reinterpret_cast<QString*>(_v) = _t->searchQuery(); break;
        case 4: *reinterpret_cast<QString*>(_v) = _t->viewMode(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->selectedWorkflowId(); break;
        case 6: *reinterpret_cast<QVariantMap*>(_v) = _t->selectedWorkflow(); break;
        case 7: *reinterpret_cast<int*>(_v) = _t->allShortcutsCount(); break;
        case 8: *reinterpret_cast<int*>(_v) = _t->shareSheetCount(); break;
        case 9: *reinterpret_cast<int*>(_v) = _t->quickActionsCount(); break;
        case 10: *reinterpret_cast<int*>(_v) = _t->menuBarCount(); break;
        case 11: *reinterpret_cast<int*>(_v) = _t->automationCount(); break;
        case 12: *reinterpret_cast<QString*>(_v) = _t->aiCardHeadline(); break;
        case 13: *reinterpret_cast<QString*>(_v) = _t->aiCardQuote(); break;
        case 14: *reinterpret_cast<QString*>(_v) = _t->aiCardSubtext(); break;
        case 15: *reinterpret_cast<bool*>(_v) = _t->aiBusy(); break;
        case 16: *reinterpret_cast<bool*>(_v) = _t->daemonActive(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 2: _t->setCurrentCategory(*reinterpret_cast<QString*>(_v)); break;
        case 3: _t->setSearchQuery(*reinterpret_cast<QString*>(_v)); break;
        case 4: _t->setViewMode(*reinterpret_cast<QString*>(_v)); break;
        case 5: _t->setSelectedWorkflowId(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *AutomatorBackend::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *AutomatorBackend::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16AutomatorBackendE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int AutomatorBackend::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 22)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 22;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 22)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 22;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 17;
    }
    return _id;
}

// SIGNAL 0
void AutomatorBackend::workflowsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void AutomatorBackend::filteredWorkflowsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void AutomatorBackend::currentCategoryChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void AutomatorBackend::searchQueryChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void AutomatorBackend::viewModeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void AutomatorBackend::selectedWorkflowIdChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void AutomatorBackend::aiStateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void AutomatorBackend::daemonStateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void AutomatorBackend::fileSelectionRequested(const QString & _t1, const QString & _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1, _t2);
}
QT_WARNING_POP
