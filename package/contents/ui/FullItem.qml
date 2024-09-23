
import QtQuick
import org.kde.plasma.components
import QtQuick.Layouts

//RowLayout {
//  height: 100
//  width: 300
//  Label {
//    id: num
//    //text: root.someInt
//    text: "Kanji"
//  }
//  Button {
//    //text: root.buttontext
//    text: "Load"
//    //onClicked: root.someInt += 2
//  }
//}
// Define the logic container

//RowLayout {
//    height: 100
//    width: 300
//
//    // Define the logic container inside the RowLayout
//    QtObject {
//        id: apiHandler
//
//        function fetchKanji(successCallback, errorCallback) {
//            var xhr = new XMLHttpRequest();
//            xhr.open("GET", "https://kanjiapi.dev/v1/kanji/水", true); // Example endpoint for the kanji "水"
//            
//            xhr.onreadystatechange = function() {
//                if (xhr.readyState === XMLHttpRequest.DONE) {
//                    if (xhr.status === 200) {
//                        successCallback(xhr.responseText);
//                    } else {
//                        errorCallback(xhr.status, xhr.statusText);
//                    }
//                }
//            };
//            xhr.send();
//        }
//    }
//
//    Label {
//        id: num
//        text: "Kanji"
//    }
//
//    Button {
//        text: "Load"
//        onClicked: {
//            apiHandler.fetchKanji(
//                function(response) {
//                    var kanjiData = JSON.parse(response);
//                    console.log(kanjiData); // Inspect the structure of the response
//                    num.text = kanjiData.kanji; // Display the fetched kanji data
//                },
//                function(status, statusText) {
//                    console.error("Error:", status, statusText);
//                    num.text = "Error loading kanji";
//                }
//            );
//        }
//    }
//}
//
import QtQuick
import org.kde.plasma.components
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    //height: 100
    //width: 300

    // Define the logic container inside the RowLayout
    QtObject {
        id: apiHandler

        function fetchDailyKanji(kanji, successCallback, errorCallback) {
            let xhr = new XMLHttpRequest();
            xhr.open("GET", "https://kanjiapi.dev/v1/kanji/" + kanji, true); // Example endpoint for the kanji "水"
            
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        successCallback(xhr.responseText);
                    } else {
                        errorCallback(xhr.status, xhr.statusText);
                    }
                }
            };
            xhr.send();
        }
    }

    Label {
        id: kanjiLabel
        text: "Loading..."
        font.pointSize: 24

        // ToolTip for displaying kanji details on hover
        ToolTip {
            id: "toolTip"
            //visible: kanjiLabel.containsMouse // Show tooltip when hovered
            visible: true
            text: "Loading..." // Display hoverText set in the Label
        }

        // Fetch the daily kanji when component is completed
        Component.onCompleted: {
          apiHandler.fetchDailyKanji(
                "水",
                function(response) {
                  let kanjiData = JSON.parse(response);
                  console.log(kanjiData)
                  kanjiLabel.text = kanjiData.kanji; // Display the kanji
                  toolTip.text  = "Reading: " + kanjiData.kun_readings.join(", ") + 
                                         "\nMeaning: " + kanjiData.meanings.join(", "); // Set hover details
                },
                function(status, statusText) {
                    console.error("Error:", status, statusText);
                    kanjiLabel.text = "Error loading kanji";
                }
            );
        }
    }

    Button {
        text: "Load New Kanji"
        onClicked: {
          apiHandler.fetchDailyKanji(
                "㒵",
                function(response) {
                    let kanjiData = JSON.parse(response);
                    kanjiLabel.text = kanjiData.kanji; // Display the fetched kanji
                    toolTip.text = "Reading: " + kanjiData.kun_readings.join(", ") + 
                                   "\nMeaning: " + kanjiData.meanings.join(", "); // Update hover details
                    toolTip.visible = true
                },
                function(status, statusText) {
                    console.error("Error:", status, statusText);
                    kanjiLabel.text = "Error loading kanji";
                }
            );
        }
    }
}

