import QtQuick 2.2
import Sailfish.Silica 1.0
import harbour.worldclock.Settings 1.0
import "../components"
import "Vars.js" as GlobVars

Dialog {
    id: settingsPage
    canAccept: true

    property int langNbrToSave: -1

    onAccepted: {
        myset.setValue("sortorder", sorting.currentIndex.toString())
        myset.setValue("sortorder_completeList",
                       citylist_sorting.currentIndex.toString())
        if (localdisplay.checked) {
            myset.setValue("hidelocal", "true")
        } else {
            myset.setValue("hidelocal", "false")
        }
        myset.setValue("city_pickertype", cityPicker.currentIndex.toString(
                           )) // not_allowed_in_store
        // languagenumber is not index, but enum number!
        if (langNbrToSave !== -1)
            myset.setValue("language", langNbrToSave.toString())
        myset.sync()
        mainapp.city_id = "fromsettings"
    }

    objectName: "SettingPage"

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        MySettings {
            id: myset
        }

        clip: true

        ScrollDecorator {}

        Column {
            id: col
            spacing: isPortrait ? Theme.paddingLarge : Theme.paddingMedium
            width: parent.width
            DialogHeader {

                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
            }
            SectionHeader {
                text: qsTr("Settings")
                visible: isPortrait
            }

            ComboBox {
                id: sorting
                width: parent.width
                label: qsTr("Sort order") + ":"
                description: qsTr("Sort order of personal list")
                currentIndex: myset.value("sortorder")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("None") // 0
                    }
                    MenuItem {
                        text: qsTr("TimeZone") // 1
                    }
                    MenuItem {
                        text: qsTr("City") //2
                    }
                }
            }
            ComboBox {
                id: citylist_sorting
                width: parent.width
                label: qsTr("Sort order list") + ":"
                description: qsTr("Sort order of complete citylist")
                currentIndex: myset.value("sortorder_completeList")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Continent/City") // 0
                    }
                    MenuItem {
                        text: qsTr("TimeZone/Continent/City") // 1
                    }
                    MenuItem {
                        text: qsTr("City") // 2
                    }
                    MenuItem {
                        text: qsTr("Country") // 3
                    }
                }
            }

            TextSwitch {
                id: localdisplay
                width: parent.width
                text: qsTr("Hide if current")
                description: qsTr("Hide localtime if city is present and current")
                checked: myset.value("hidelocal") === "true"
            }
            Column {
                width: parent.width
                spacing: 0

                ComboBox {
                    id: language
                    width: settingsPage.width
                    label: qsTr("Language:")
                    description: qsTr("Change of language will be active after restarting the application.")
                    currentIndex: toCurrentIndex(myset.value("language"))
                    menu: ContextMenu {
                        // make sure it has the order in Vars.js
                        MenuItem {
                            text: "English/English"
                        } // 0
                        MenuItem {
                            text: "Arabic/العربية"
                        } // 1
                        MenuItem {
                            text: "Chinese/中文"
                        } // 2
                        MenuItem {
                            text: "Dutch/Nederlands"
                        } // 3
                        MenuItem {
                            text: "Estonian/Eesti keel"
                        } // 4
                        MenuItem {
                            text: "Flemish (Dutch Belgium)/Vlaams"
                        } // 5
                        MenuItem {
                            text: "French/Français"
                        } // 6
                        MenuItem {
                            text: "German/Deutsch"
                        } // 7
                        MenuItem {
                            text: "Greek/ελληνικά"
                        } // 8
                        MenuItem {
                            text: "Hungarian/Magyar"
                        } // 9
                        MenuItem {
                            text: "Italian/Italiano"
                        } // 10
                        MenuItem {
                            text: "Polish/Polski"
                        } // 11
                        MenuItem {
                            text: "Russian/Русский"
                        } // 12
                        MenuItem {
                            text: "Slovenian/Slovenski"
                        } // 13
                        MenuItem {
                            text: "Spanish/Español"
                        } // 14
                        MenuItem {
                            text: "Swedish/Svensk"
                        } // 15
                    }
                    // The next two converter functions decouple the alphabetical language list
                    // index from the internal settings index, which cannot be changed for legacy reasons
                    function toCurrentIndex(value) {
                        switch (parseInt(value)) {
                        case Languages.SYSTEM_DEFAULT:
                            return GlobVars.system_default
                        case Languages.EN:
                            // English
                            return GlobVars.english
                        case Languages.SV:
                            // Swedish
                            return GlobVars.swedish
                        case Languages.FI:
                            // Finnish
                            return GlobVars.finnish
                        case Languages.DE:
                            // German
                            return GlobVars.german
                        case Languages.CA:
                            // Catalan
                            return GlobVars.catalan
                        case Languages.CS:
                            // Czech
                            return GlobVars.czech
                        case Languages.DA:
                            // Danish
                            return GlobVars.danish
                        case Languages.NL:
                            // Dutch
                            return GlobVars.dutch
                        case Languages.ET:
                            // Estonian
                            return GlobVars.estonian
                        case Languages.NL_BE:
                            // Flemish
                            return GlobVars.flemish
                        case Languages.SL_SI:
                            // Slovenian
                            return GlobVars.slovenian
                        case Languages.ES:
                            // Spanish
                            return GlobVars.spanish
                        case Languages.FR_FR:
                            // French
                            return GlobVars.french
                        case Languages.RU:
                            // Russian
                            return GlobVars.russian
                        case Languages.EL:
                            // Greek
                            return GlobVars.greek
                        case Languages.AR:
                            // Arabic
                            return GlobVars.arabic
                        case Languages.TR_TR:
                            // Turkish
                            return GlobVars.turkish
                        case Languages.PL_PL:
                            // Polish
                            return GlobVars.polish
                        case Languages.HU_HU:
                            // Hungarian
                            return GlobVars.hungarian
                        case Languages.IT:
                            // Italian
                            return GlobVars.italian
                        case Languages.ZH_CN:
                            // Chinese
                            return GlobVars.chinese
                        default:
                            return GlobVars.english
                        }
                    }

                    function toSettingsIndex(value) {
                        switch (value) {
                        case GlobVars.system_default:
                            return Languages.SYSTEM_DEFAULT
                        case GlobVars.english:
                            return Languages.EN // English
                        case GlobVars.swedish:
                            return Languages.SV // Swedish
                        case GlobVars.spanish:
                            return Languages.ES // Spanish
                        case GlobVars.finnish:
                            return Languages.FI // Finnish
                        case GlobVars.german:
                            return Languages.DE // German
                        case GlobVars.catalan:
                            return Languages.CA // Catalan
                        case GlobVars.czech:
                            return Languages.CS // Czech
                        case GlobVars.dutch:
                            return Languages.NL // Dutch
                        case GlobVars.flemish:
                            return Languages.NL_BE // Flemish
                        case GlobVars.danish:
                            return Languages.DA // Danish
                        case GlobVars.estonian:
                            return Languages.ET // Estonian
                        case GlobVars.slovenian:
                            return Languages.SL_SI // Slovenian
                        case GlobVars.french:
                            return Languages.FR_FR // French
                        case GlobVars.turkish:
                            return Languages.TR_TR // Turkish
                        case GlobVars.russian:
                            return Languages.RU // Russian
                        case GlobVars.greek:
                            return Languages.EL // Greek
                        case GlobVars.arabic:
                            return Languages.AR // Arabic
                        case GlobVars.polish:
                            return Languages.PL_PL // Polish
                        case GlobVars.hungarian:
                            return Languages.HU_HU // Hungarian
                        case GlobVars.italian:
                            return Languages.IT // Italian
                        case GlobVars.chinese:
                            return Languages.ZH_CN // Chinese
                        default:
                            return Languages.EN // English
                        }
                    }

                    onCurrentIndexChanged: {
                        langNbrToSave = toSettingsIndex(language.currentIndex)
                    }
                }

                // not_allowed_in_store
                ComboBox {
                    id: cityPicker
                    width: parent.width
                    label: qsTr("Worldclock pick screen") + ":"
                    description: qsTr("Choose screentype used for selecting a worldclock")
                    currentIndex: myset.value("city_pickertype")
                    menu: ContextMenu {
                        MenuItem {
                            text: qsTr("Custom") // 0
                        }
                        MenuItem {
                            text: qsTr("Sailfish") // 1
                        }
                    }
                }
            }
        }
    }
}
