import QtQuick 2.0
import QtQuick.Controls 2.5 as Controls
import QtQuick.Layouts 1.1 as Layouts
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasmoid
import org.kde.kcmutils as KCM
import QtQuick.Controls


    /*
    property var kanjiSets: [
        { id: "joyo_kanji", name: "Jōyō Kanji", path: "/v1/kanji/joyo" },
        { id: "jinmeiyo_kanji", name: "Jinmeiyō Kanji", path: "/v1/kanji/jinmeiyo"},
        { id: "heisig_kanji", name: "Heisig Kanji", path: "/v1/kanji/heisig"},
        { id: "kyouiku_kanji", name: "Kyōiku Kanji", path: "/v1/kanji/kyouiku" },
        { id: "grade_1_kanji", name: "Grade 1 Kyōiku Kanji", path: "/v1/kanji/grade-1"},
        { id: "grade_2_kanji", name: "Grade 2 Kyōiku Kanji", path: "/v1/kanji/grade-2"},
        { id: "grade_3_kanji", name: "Grade 3 Kyōiku Kanji", path: "/v1/kanji/grade-3"},
        { id: "grade_4_kanji", name: "Grade 4 Kyōiku Kanji", path: "/v1/kanji/grade-4"},
        { id: "grade_5_kanji", name: "Grade 5 Kyōiku Kanji", path: "/v1/kanji/grade-5"},
        { id: "grade_6_kanji", name: "Grade 6 Kyōiku Kanji", path: "/v1/kanji/grade-6"},
        { id: "joyo_excluding_kyouiku", name: "Jōyō Kanji excluding Kyōiku", path: "/v1/kanji/grade-8"}
    ]
    */


Kirigami.FormLayout {

    id: root

    signal configurationChanged

    property alias cfg_joyo_kanji: joyo_kanji.checked
    property alias cfg_jinmeiyo_kanji: jinmeiyo_kanji.checked
    property alias cfg_heisig_kanji: heisig_kanji.checked
    property alias cfg_kyouiku_kanji: kyouiku_kanji.checked
    property alias cfg_grade_1_kanji: grade_1_kanji.checked
    property alias cfg_grade_2_kanji: grade_2_kanji.checked
    property alias cfg_grade_3_kanji: grade_3_kanji.checked
    property alias cfg_grade_4_kanji: grade_4_kanji.checked
    property alias cfg_grade_5_kanji: grade_5_kanji.checked
    property alias cfg_grade_6_kanji: grade_6_kanji.checked
    property alias cfg_joyo_excluding_kyouiku: joyo_excluding_kyouiku.checked


    Layouts.ColumnLayout {
        id: providerColumn
        Kirigami.FormData.label: i18nc("@title:group", "Available Kanji sets:")

        /*
        Repeater {
            model: root.kanjiSets

            CheckBox {
                id: modelData.id
                text: modelData.name
                checked: modelData.checked
                property string path: modelData.path
                onCheckedChanged: root.configurationChanged();
            }
        }
        */
        CheckBox {
            id: joyo_kanji
            text: "Jōyō Kanji"
        }
        CheckBox {
            id: jinmeiyo_kanji
            text: "Jinmeiyō Kanji"
        }
        CheckBox {
            id: heisig_kanji
            text: "Heisig Kanji"
        }
        CheckBox {
            id: kyouiku_kanji
            text: "Kyōiku Kanji"
        }
        CheckBox {
            id: grade_1_kanji
            text: "Grade 1 Kyōiku Kanji"
        }
        CheckBox {
            id: grade_2_kanji
            text: "Grade 2 Kyōiku Kanji"
        }
        CheckBox {
            id: grade_3_kanji
            text: "Grade 3 Kyōiku Kanji"
        }
        CheckBox {
            id: grade_4_kanji
            text: "Grade 4 Kyōiku Kanji"
        }
        CheckBox {
            id: grade_5_kanji
            text: "Grade 5 Kyōiku Kanji"
        }
        CheckBox {
            id: grade_6_kanji
            text: "Grade 6 Kyōiku Kanji"
            onCheckedChanged: root.configurationChanged();
        }
        CheckBox {
            id: joyo_excluding_kyouiku
            text: "Jōyō Kanji excluding Kyōiku"
            onCheckedChanged: root.configurationChanged();
        }
    }
}
