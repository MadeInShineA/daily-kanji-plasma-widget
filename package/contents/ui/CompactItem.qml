import QtQuick
import org.kde.plasma.components
import org.kde.ksvg as KSVG

Rectangle {
  //Notice id is not necessary
  MouseArea {  //Provided by QML to handle mouse events
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    onClicked:  (mouse) => {
      root.expanded = !root.expanded
        // This expands the compact representation into full and back
    }
  }
}
