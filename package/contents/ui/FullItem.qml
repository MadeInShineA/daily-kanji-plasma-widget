import QtQuick
import org.kde.plasma.components as PlasmaComponents
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.core as PlasmaCore

RowLayout {
  height: 100
  width: 200

  QtObject {
    id: apiHandler

    function fetchKanjiInfos(kanji, successCallback, errorCallback) {
      let xhr = new XMLHttpRequest();
      xhr.open("GET", "https://kanjiapi.dev/v1/kanji/" + kanji, true); 
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
      apiHandler.fetchKanjiInfos(
        "㒵",
        function(response) {
          let kanjiData = JSON.parse(response);
          kanjiLabel.text = kanjiData.kanji; // Display the fetched kanji
          toolTip.mainText = "Reading: " + kanjiData.kun_readings.join(", ") + 
            "\nMeaning: " + kanjiData.meanings.join(", "); // Update hover details
        },
        function(status, statusText) {
          console.error("Error:", status, statusText);
          kanjiLabel.text = "Error loading kanji";
        }
      );
    }
  }

  Component.onCompleted: {
    apiHandler.fetchKanjiInfos(
      "水",
      function(response) {
        let kanjiData = JSON.parse(response);
        kanjiLabel.text = kanjiData.kanji; // Display the kanjiapi
        toolTip.mainText  = "Reading: " + kanjiData.kun_readings.join(", ") + 
          "\nMeaning: " + kanjiData.meanings.join(", "); // Set hover details
      },
      function(status, statusText) {
        console.error("Error:", status, statusText);
        kanjiLabel.text = "Error loading kanji";
      }
    );
  }
}

