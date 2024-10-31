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

        property var kanjiSets: [
            {name: "Jōyō Kanji", path: "/v1/kanji/joyo", kanji: [], checked: plasmoid.configuration.joyo_kanji},
            {name: "Jinmeiyō Kanji", path: "/v1/kanji/jinmeiyo", kanji: [], checked: plasmoid.configuration.jinmeiyo_kanji},
            {name: "Heisig Kanji", path: "/v1/kanji/heisig", kanji: [], checked: plasmoid.configuration.heisig_kanji},
            {name: "Kyōiku Kanji", path: "/v1/kanji/kyouiku", kanji: [], checked: plasmoid.configuration.kyouiku_kanji},
            {name: "Grade 1 Kyōiku Kanji", path: "/v1/kanji/grade-1", kanji: [], checked: plasmoid.configuration.grade_1_kanji},
            {name: "Grade 2 Kyōiku Kanji", path: "/v1/kanji/grade-2", kanji: [], checked: plasmoid.configuration.grade_2_kanji},
            {name: "Grade 3 Kyōiku Kanji", path: "/v1/kanji/grade-3", kanji: [], checked: plasmoid.configuration.grade_3_kanji},
            {name: "Grade 4 Kyōiku Kanji", path: "/v1/kanji/grade-4", kanji: [], checked: plasmoid.configuration.grade_4_kanji},
            {name: "Grade 5 Kyōiku Kanji", path: "/v1/kanji/grade-5", kanji: [], checked: plasmoid.configuration.grade_5_kanji},
            {name: "Grade 6 Kyōiku Kanji", path: "/v1/kanji/grade-6", kanji: [], checked: plasmoid.configuration.grade_6_kanji},
            {name: "Jōyō Kanji excluding Kyōiku", path: "/v1/kanji/grade-8", kanji: [], checked: plasmoid.configuration.joyo_excluding_kyouiku}
        ];

        function refreshKanjiSets() {
            kanjiSets.forEach((set) => {
                switch (set.name) {
                    case "Jōyō Kanji":
                        set.checked = plasmoid.configuration.joyo_kanji;
                        break;
                    case "Jinmeiyō Kanji":
                        set.checked = plasmoid.configuration.jinmeiyo_kanji;
                        break;
                    case "Heisig Kanji":
                        set.checked = plasmoid.configuration.heisig_kanji;
                        break;
                    case "Kyōiku Kanji":
                        set.checked = plasmoid.configuration.kyouiku_kanji;
                        break;
                    case "Grade 1 Kyōiku Kanji":
                        set.checked = plasmoid.configuration.grade_1_kanji;
                        break;
                    case "Grade 2 Kyōiku Kanji":
                        set.checked = plasmoid.configuration.grade_2_kanji;
                        break;
                    case "Grade 3 Kyōiku Kanji":
                        set.checked = plasmoid.configuration.grade_3_kanji;
                        break;
                    case "Grade 4 Kyōiku Kanji":
                        set.checked = plasmoid.configuration.grade_4_kanji;
                        break;
                    case "Grade 5 Kyōiku Kanji":
                        set.checked = plasmoid.configuration.grade_5_kanji;
                        break;
                    case "Grade 6 Kyōiku Kanji":
                        set.checked = plasmoid.configuration.grade_6_kanji;
                        break;
                    case "Jōyō Kanji excluding Kyōiku":
                        set.checked = plasmoid.configuration.joyo_excluding_kyouiku;
                        break;
                }
            });
        }

        function fetchKanji() {
            let fetchPromises = kanjiSets.map((set, index) => {
                return fetchKanjiFromSetUrl(set.path).then((kanji) => {
                    kanjiSets[index].kanji = kanji;
                });
            });

            // Return a Promise that resolves when all fetches complete
            return Promise.all(fetchPromises).then(() => {
                console.log("All kanji sets fetched:", kanjiSets);
            }).catch((error) => {
                console.error("Error in fetchKanji:", error);
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
                            resolve([]); // Resolve with an empty array on error to avoid undefined
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
            refreshKanjiSets()
            let checkedKanjiSets = kanjiSets.filter(set => set.checked)
            if (checkedKanjiSets.length > 0) {
                let randomKanjiSet = checkedKanjiSets[Math.floor(Math.random() * checkedKanjiSets.length)];
                let randomKanji = randomKanjiSet.kanji[Math.floor(Math.random() * randomKanjiSet.kanji.length)];

                fetchKanjiInfos(
                    randomKanji,
                    function(response) {
                        let kanjiData = response;
                        kanjiLabel.text = kanjiData.kanji;
                        toolTip.mainText = 
                          "Meaning: " + kanjiData.meanings.join(", ") +
                          "\nKun Reading: " + kanjiData.kun_readings.join(", ") +
                          "\nOn Reading: " + kanjiData.on_readings.join(",") +
                          "\nKanji set: " + randomKanjiSet.name
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
            apiHandler.setRandomKanjiInfos();
        }
    }

    Component.onCompleted: {
        apiHandler.fetchKanji().then(() => {
            apiHandler.setRandomKanjiInfos();
        });
    }
}
