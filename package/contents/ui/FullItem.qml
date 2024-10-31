import QtQuick
import org.kde.plasma.components as PlasmaComponents
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

RowLayout {
    height: 100
    width: 200

    QtObject {
        id: apiHandler

        property var available_kanji: []

        function createKanjiSets() {
            return [
                {name: "Jōyō Kanji", path: "/v1/kanji/joyo", checked: plasmoid.configuration.joyo_kanji},
                {name: "Jinmeiyō Kanji", path: "/v1/kanji/jinmeiyo", checked: plasmoid.configuration.jinmeiyo_kanji},
                {name: "Heisig Kanji", path: "/v1/kanji/heisig", checked: plasmoid.configuration.heisig_kanji},
                {name: "Kyōiku Kanji", path: "/v1/kanji/kyouiku", checked: plasmoid.configuration.kyouiku_kanji},
                {name: "Grade 1 Kyōiku Kanji", path: "/v1/kanji/grade-1", checked: plasmoid.configuration.grade_1_kanji},
                {name: "Grade 2 Kyōiku Kanji", path: "/v1/kanji/grade-2", checked: plasmoid.configuration.grade_2_kanji},
                {name: "Grade 3 Kyōiku Kanji", path: "/v1/kanji/grade-3", checked: plasmoid.configuration.grade_3_kanji},
                {name: "Grade 4 Kyōiku Kanji", path: "/v1/kanji/grade-4", checked: plasmoid.configuration.grade_4_kanji},
                {name: "Grade 5 Kyōiku Kanji", path: "/v1/kanji/grade-5", checked: plasmoid.configuration.grade_5_kanji},
                {name: "Grade 6 Kyōiku Kanji", path: "/v1/kanji/grade-6", checked: plasmoid.configuration.grade_6_kanji},
                {name: "Jōyō Kanji excluding Kyōiku", path: "/v1/kanji/grade-8", checked: plasmoid.configuration.joyo_excluding_kyouiku}
            ];
        }

        function fetchAvailableKanji() {
            let kanjiSets = createKanjiSets();
            let fetchPromises = [];
            for (var i = 0; i < kanjiSets.length; i++) {
                if (kanjiSets[i].checked) {
                    fetchPromises.push(fetchKanjiFromSetUrl(kanjiSets[i].path));
                }
            }
            return Promise.all(fetchPromises).then(results => {
                available_kanji = results.filter(kanji => kanji !== undefined);
            });
        }

        function fetchKanjiFromSetUrl(setUrl) {
            return new Promise((resolve, reject) => {
                let xhr = new XMLHttpRequest();
                xhr.open("GET", "https://kanjiapi.dev" + setUrl, true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === XMLHttpRequest.DONE) {
                        if (xhr.status === 200) {
                            resolve(JSON.parse(xhr.responseText));
                        } else {
                            console.log("Error fetching kanji set:", xhr.status, xhr.statusText);
                            resolve(undefined); // Resolve with undefined on error
                        }
                    }
                };
                xhr.send();
            });
        }

        function fetchKanjiInfos(kanji, successCallback, errorCallback) {
            let xhr = new XMLHttpRequest();
            xhr.open("GET", "https://kanjiapi.dev/v1/kanji/" + kanji, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        successCallback(JSON.parse(xhr.responseText));
                    } else {
                        errorCallback(xhr.status, xhr.statusText);
                    }
                }
            };
            xhr.send();
        }

        function setRandomKanjiInfos() {
            if (available_kanji.length > 0) {
                let randomKanjiSet = available_kanji[Math.floor(Math.random() * available_kanji.length)];
                let randomKanji = randomKanjiSet[Math.floor(Math.random() * randomKanjiSet.length)];

                fetchKanjiInfos(
                    randomKanji,
                    function(response) {
                        let kanjiData = response;
                        kanjiLabel.text = kanjiData.kanji;
                        toolTip.mainText = 
                          "Meaning: " + kanjiData.meanings.join(", ") +
                          "\nKun Reading: " + kanjiData.kun_readings.join(", ") +
                          "\nOn Reading: " + kanjiData.on_readings.join(",")
                                              },
                    function(status, statusText) {
                        console.error("Error:", status, statusText);
                        kanjiLabel.text = "Error loading kanji";
                    }
                );
            } else {
                kanjiLabel.text = "No available kanji to display.";
                toolTip.mainText = ""
            }
        }
    }

    Label {
        id: kanjiLabel
        text: "Loading..."
        font.pointSize: 24
    }

    PlasmaCore.ToolTipArea {
        id: toolTip
        parent: kanjiLabel
        anchors.fill: kanjiLabel
        mainText: "Loading..."
    }

    PlasmaComponents.Button {
        text: "Load New Kanji"
        onClicked: {
           apiHandler.fetchAvailableKanji().then(() => {
            apiHandler.setRandomKanjiInfos();
          });
        }
    }

    Component.onCompleted: {
        apiHandler.fetchAvailableKanji().then(() => {
            apiHandler.setRandomKanjiInfos();
        });
    }
}
