import QtQuick
import QtQuick.Controls
import qs.Common
import qs.Modules.Plugins
import qs.Modules.ProcessList
import qs.Services
import qs.Widgets

BasePill {
    id: root

    property bool showVerticalStack: false

    onClicked: {
        showVerticalStack = !showVerticalStack;
    }

    function formatNetworkSpeed(bytesPerSec) {
        if (bytesPerSec < 1024) {
            return bytesPerSec.toFixed(0) + " B/s"
        } else if (bytesPerSec < 1024 * 1024) {
            return (bytesPerSec / 1024).toFixed(1) + " KB/s"
        } else if (bytesPerSec < 1024 * 1024 * 1024) {
            return (bytesPerSec / (1024 * 1024)).toFixed(1) + " MB/s"
        } else {
            return (bytesPerSec / (1024 * 1024 * 1024)).toFixed(1) + " GB/s"
        }
    }

    Component.onCompleted: {
        DgopService.addRef(["network"])
    }
    Component.onDestruction: {
        DgopService.removeRef(["network"])
    }

    content: Component {
        Item {
            implicitWidth: root.isVerticalOrientation ? (root.widgetThickness - root.horizontalPadding * 2) : contentRow.implicitWidth
            implicitHeight: root.isVerticalOrientation ? contentColumn.implicitHeight : (root.widgetThickness - root.horizontalPadding * 2)

            Column {
                id: contentColumn
                anchors.centerIn: parent
                spacing: 2
                visible: root.isVerticalOrientation

                DankIcon {
                    name: "network_check"
                    size: Theme.barIconSize(root.barThickness, undefined, root.barConfig?.maximizeWidgetIcons, root.barConfig?.iconScale)
                    color: Theme.widgetTextColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                StyledText {
                    text: {
                        const rate = DgopService.networkRxRate
                        if (rate < 1024) return rate.toFixed(0)
                        if (rate < 1024 * 1024) return (rate / 1024).toFixed(0) + "K"
                        return (rate / (1024 * 1024)).toFixed(0) + "M"
                    }
                    font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                    color: Theme.info
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                StyledText {
                    text: {
                        const rate = DgopService.networkTxRate
                        if (rate < 1024) return rate.toFixed(0)
                        if (rate < 1024 * 1024) return (rate / 1024).toFixed(0) + "K"
                        return (rate / (1024 * 1024)).toFixed(0) + "M"
                    }
                    font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                    color: Theme.error
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Row {
                id: contentRow
                anchors.centerIn: parent
                spacing: Theme.spacingS
                visible: !root.isVerticalOrientation

                DankIcon {
                    name: "network_check"
                    size: Theme.barIconSize(root.barThickness, undefined, root.barConfig?.maximizeWidgetIcons, root.barConfig?.iconScale)
                    color: Theme.widgetTextColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Row {
                    spacing: Theme.spacingS
                    visible: !root.showVerticalStack
                    anchors.verticalCenter: parent.verticalCenter

                    Row {
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter

                        StyledText {
                            text: "↓"
                            font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                            color: Theme.info
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: DgopService.networkRxRate > 0 ? root.formatNetworkSpeed(DgopService.networkRxRate) : "0 B/s"
                            font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                            color: Theme.widgetTextColor
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideNone
                            wrapMode: Text.NoWrap

                            StyledTextMetrics {
                                id: rxBaseline
                                font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                                text: "88.8 MB/s"
                            }

                            width: Math.max(rxBaseline.width, paintedWidth)
                        }
                    }

                    Row {
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter

                        StyledText {
                            text: "↑"
                            font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                            color: Theme.error
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: DgopService.networkTxRate > 0 ? root.formatNetworkSpeed(DgopService.networkTxRate) : "0 B/s"
                            font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                            color: Theme.widgetTextColor
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideNone
                            wrapMode: Text.NoWrap

                            StyledTextMetrics {
                                id: txBaseline
                                font.pixelSize: Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText)
                                text: "88.8 MB/s"
                            }

                            width: Math.max(txBaseline.width, paintedWidth)
                        }
                    }
                }

                Column {
                    id: stackedColumn
                    spacing: 0
                    visible: root.showVerticalStack
                    anchors.verticalCenter: parent.verticalCenter

                    readonly property int stackedFontSize: Math.max(8, Theme.barTextSize(root.barThickness, root.barConfig?.fontScale, root.barConfig?.maximizeWidgetText) - 2)

                    Row {
                        spacing: 4

                        StyledText {
                            text: "↑"
                            font.pixelSize: stackedColumn.stackedFontSize
                            color: Theme.error
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: DgopService.networkTxRate > 0 ? root.formatNetworkSpeed(DgopService.networkTxRate) : "0 B/s"
                            font.pixelSize: stackedColumn.stackedFontSize
                            color: Theme.widgetTextColor
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideNone
                            wrapMode: Text.NoWrap

                            StyledTextMetrics {
                                id: txStackedBaseline
                                font.pixelSize: stackedColumn.stackedFontSize
                                text: "88.8 MB/s"
                            }

                            width: Math.max(txStackedBaseline.width, paintedWidth)
                        }
                    }

                    Row {
                        spacing: 4

                        StyledText {
                            text: "↓"
                            font.pixelSize: stackedColumn.stackedFontSize
                            color: Theme.info
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        StyledText {
                            text: DgopService.networkRxRate > 0 ? root.formatNetworkSpeed(DgopService.networkRxRate) : "0 B/s"
                            font.pixelSize: stackedColumn.stackedFontSize
                            color: Theme.widgetTextColor
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideNone
                            wrapMode: Text.NoWrap

                            StyledTextMetrics {
                                id: rxStackedBaseline
                                font.pixelSize: stackedColumn.stackedFontSize
                                text: "88.8 MB/s"
                            }

                            width: Math.max(rxStackedBaseline.width, paintedWidth)
                        }
                    }
                }
            }
        }
    }
}
