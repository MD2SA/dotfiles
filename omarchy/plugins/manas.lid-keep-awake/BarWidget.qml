import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Coffee-cup bar toggle for the `lid-keep-awake` user service.
//
// The service holds a `handle-lid-switch` block inhibitor so closing the lid
// does not suspend the machine, which keeps herdr and opencode working. This
// widget reflects the service state and enables/starts or disables/stops it.
BarWidget {
  id: root
  moduleName: "manas.lid-keep-awake"

  readonly property string serviceName: "lid-keep-awake.service"
  // Material Design Icons "sleep-off" (U+F04B3) — crossed-out Zzz, i.e. no sleep.
  readonly property string glyph: "󰒳"

  property bool serviceActive: false

  function refresh() {
    if (!statusProbe.running) statusProbe.running = true
  }

  function toggle() {
    if (!root.bar) return
    var command = root.serviceActive
      ? "systemctl --user disable --now " + root.serviceName
      : "systemctl --user enable --now " + root.serviceName
    root.bar.run(command)
    refreshTimer.restart()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: statusProbe
    command: ["systemctl", "--user", "is-active", root.serviceName]
    stdout: SplitParser {
      onRead: function(line) { root.serviceActive = String(line).trim() === "active" }
    }
  }

  // One immediate re-check after a toggle, then rely on the periodic poll.
  Timer {
    id: refreshTimer
    interval: 400
    repeat: false
    onTriggered: root.refresh()
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  Component.onCompleted: root.refresh()

  IpcHandler {
    target: "manas.lid-keep-awake"

    function refresh(): void { root.broadcast("refresh") }
    function toggle(): void { root.toggle() }
    function enable(): void { if (!root.serviceActive) root.toggle() }
    function disable(): void { if (root.serviceActive) root.toggle() }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.glyph
    active: root.serviceActive
    useActiveColor: true
    dimmed: !root.serviceActive
    tooltipText: root.serviceActive
      ? "Não suspender ao fechar a tampa: ativado"
      : "Não suspender ao fechar a tampa: desativado"
    onPressed: function(b) {
      if (b === Qt.RightButton) root.refresh()
      else root.toggle()
    }
  }
}
