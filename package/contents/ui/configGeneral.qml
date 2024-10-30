import QtQuick 2.0
import QtQuick.Controls 2.5 as Controls
import QtQuick.Layouts 1.1 as Layouts
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.plasmoid
import org.kde.kcmutils as KCM
import QtQuick.Controls

KCM.SimpleKCM {
    id: root

    signal configurationChanged

    function saveConfig() {
        var selectedKanjiSets = [];
        for (var i = 0; i < providerColumn.children.length; i++) {
            var checkbox = providerColumn.children[i];
            if (checkbox.checked) {
                selectedKanjiSets.push(checkbox.path);
            }
        }
        
        console.log("Selected Kanji Sets:", selectedKanjiSets);

        Plasmoid.selectedKanjiSets = selectedKanjiSets

        Plasmoid.saveConfig();
        Plasmoid.configChanged()
    }

    // JavaScript array of kanji sets
    property var kanjiSets: [
        { name: "Jōyō Kanji", path: "/v1/kanji/joyo", checked: true},
        { name: "Jinmeiyō Kanji", path: "/v1/kanji/jinmeiyo",checked: true},
        { name: "Heisig Kanji", path: "/v1/kanji/heisig", checked: true},
        { name: "Kyōiku Kanji", path: "/v1/kanji/kyouiku", checked: true },
        { name: "Grade 1 Kyōiku Kanji", path: "/v1/kanji/grade-1", checked: true},
        { name: "Grade 2 Kyōiku Kanji", path: "/v1/kanji/grade-2", checked: false},
        { name: "Grade 3 Kyōiku Kanji", path: "/v1/kanji/grade-3", checked: true},
        { name: "Grade 4 Kyōiku Kanji", path: "/v1/kanji/grade-4", checked: false},
        { name: "Grade 5 Kyōiku Kanji", path: "/v1/kanji/grade-5", checked: true},
        { name: "Grade 6 Kyōiku Kanji", path: "/v1/kanji/grade-6", checked: false},
        { name: "Jōyō Kanji excluding Kyōiku", path: "/v1/kanji/grade-8", checked: false}
    ]

    Kirigami.FormLayout {

         Component.onCompleted: {
            kanjiSets.value = Plasmoid.selectedKanjiSets;
            console.log("caca")
        }


        Layouts.ColumnLayout {
            id: providerColumn
            Kirigami.FormData.label: i18nc("@title:group", "Available Kanji sets:")

            Repeater {
                model: root.kanjiSets

                CheckBox {
                    text: modelData.name
                    checked: modelData.checked
                    property string path: modelData.path
                    onCheckedChanged: root.configurationChanged();
                }
            }
        }
    }
}
