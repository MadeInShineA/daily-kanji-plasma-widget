
import QtQuick
import org.kde.plasma.components
import QtQuick.Layouts

RowLayout {
  height: 100
  width: 300
  Label {
    id: num
    text: root.someInt
  }
  Button {
    text: root.buttontext
    onClicked: root.someInt += 2 }
  }
