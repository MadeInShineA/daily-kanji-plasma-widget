import QtQuick
import org.kde.plasma.components
import org.kde.plasma.plasmoid
import QtQuick.Layouts

PlasmoidItem {
  id: root
  preferredRepresentation: compactRepresentation
  compactRepresentation: CompactItem {}
  fullRepresentation: FullItem{}

  property int someInt: 69
  property string buttontext: "Click me!"  
}

