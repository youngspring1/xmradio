import QtQuick 2.3
import QtQuick.Controls 1.3
import QtMultimedia 5.0

Rectangle {
    id: page
    color: "lightgrey"
    width: 800; height: 600

    signal guessClicked()
    signal randomGuessClicked()
    signal pauseClicked()
    signal nextClicked()
    signal prevClicked()
    signal loadFavClicked()
    signal playerError(string error, string errorString)
    signal playerStopped()
    signal playerPosition(int position)
    signal playerDuration(int duration)
    signal playerStatus(int status)
    signal progressSeek(real x, real width)

    function setStatus(statusText) {
        status.text = statusText
    }

    function setSource(source) {
        player.source = source
    }

    function setProgress(duration, pos, msg) {
        progress.minimumValue = 0
        progress.maximumValue = duration
        if (duration == 0) {
            progress.indeterminate = true
        } else {
            progress.indeterminate = false
        }

        progress.value = pos
        progressText.text = msg
    }

    function play() {
        player.play()
    }

    function seek(position) {
        player.seek(position)
    }

    function pause() {
        if (player.playbackState == MediaPlayer.PausedState) {
            player.play()
        } else {
            player.pause()
        }
    }

    function getPlayerStatus() {
        return player.status
    }

    function setPlaylistHighlight(pos) {
    }

    function currentStation() {
        return favStations.currentIndex
    }

    function currentSong() {
        return playlist.currentIndex
    }

    function setCurrentSong(idx) {
        playlist.currentIndex = idx
    }

    MediaPlayer {
        id: player
        source: ""
        onError: playerError(error, errorString)
        onStopped: playerStopped()
        onPositionChanged: playerPosition(position)
        onDurationChanged: playerDuration(duration)
        onStatusChanged: playerStatus(status)
    }

    Text {
        id: lblPlaylist
        text: qsTr("Playlist")
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
    }

    Text {
        id: status
        y: 537
        text: qsTr("Ready")
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: btnPause.top
        anchors.bottomMargin: 8
        font.pixelSize: 15
        elide: Text.ElideRight
    }

    Component {
        id: songDelegate
        Rectangle {
            id: songCell
            height: songTitle.height + songDesc.height + 5
            width: playlist.width
            color: {
                if (model.display.highlight) {
                    return "lightblue"
                } else {
                    return "white"
                }
            }

            Text {
                id: songTitle
                text: model.display.title
                width: songCell.width
                font.bold: true
                wrapMode: TextEdit.Wrap
            }
            Text {
                id: songDesc
                text: model.display.desc
                width: songCell.width
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: songTitle.bottom
                anchors.topMargin: 0
                wrapMode: TextEdit.Wrap
            }
            MouseArea {
                anchors.fill: parent
                onDoubleClicked: {
                    playlist.currentIndex = model.index
                    controller.song_clicked(model.display, model.index)
                }
            }
        }
    }
    Rectangle {
        id: playlistRect
        color: "white"
        clip: true
        anchors.right: parent.right
        anchors.rightMargin: 256
        anchors.top: btnGuess.bottom
        anchors.topMargin: 8
        anchors.bottom: status.top
        anchors.bottomMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8

        ListView {
            id: playlist
            objectName: "playlist"
            anchors.fill: parent
            model: ListModel{}
            delegate: songDelegate
        }
    }

    Button {
        id: btnGuess
        x: 59
        y: 4
        text: qsTr("Guess")
        anchors.verticalCenter: lblPlaylist.verticalCenter
        onClicked: guessClicked()
    }

    Button {
        id: btnRandomGuess
        y: 4
        text: qsTr("Random Guess")
        anchors.verticalCenter: btnGuess.verticalCenter
        anchors.left: btnGuess.right
        anchors.leftMargin: 8
        onClicked: randomGuessClicked()
    }

    Button {
        id: btnLoadFav
        y: 4
        text: qsTr("Load favourite")
        anchors.verticalCenter: btnGuess.verticalCenter
        anchors.left: btnRandomGuess.right
        anchors.leftMargin: 8
        onClicked: loadFavClicked()
    }


    Button {
        id: btnPause
        y: 553
        text: qsTr("Pause/Resume")
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        onClicked: pauseClicked()
    }

    Component {
        id: stationDelegate
        Rectangle {
            id: stationCell
            height: stationTitle.height + stationDesc.height + 10
            width: favStations.width
            color: {
                if (model.display.highlight) {
                    return "lightblue"
                } else {
                    return "white"
                }
            }

            Text {
                id: stationTitle
                text: model.display.title
                width: stationCell.width
                font.bold: true
                wrapMode: TextEdit.Wrap
            }
            Text {
                id: stationDesc
                text: model.display.desc
                width: stationCell.width
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: stationTitle.bottom
                anchors.topMargin: 0
                wrapMode: TextEdit.Wrap
            }
            MouseArea {
                anchors.fill: parent
                onDoubleClicked: {
                    favStations.currentIndex = model.index
                    controller.station_clicked(model.display)
                }
            }
        }
    }

    Rectangle {
        color: "white"
        clip: true
        anchors.top: playlistRect.top
        anchors.topMargin: 0
        anchors.bottom: playlistRect.bottom
        anchors.bottomMargin: 0
        anchors.left: playlistRect.right
        anchors.leftMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8

        ListView {
            id: favStations
            objectName: "favStations"
            anchors.fill: parent
            model: ListModel {}
            delegate: stationDelegate
        }
    }

    Button {
        id: btnNext
        y: 553
        text: qsTr("Next")
        anchors.left: btnPause.right
        anchors.leftMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        onClicked: nextClicked()
    }

    Button {
        id: btnPrev
        y: 553
        text: qsTr("Prev")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: btnNext.right
        anchors.leftMargin: 8
        onClicked: prevClicked()
    }

    ProgressBar {
        id: progress
        y: 555
        height: 23
        value: 0
        maximumValue: 100
        indeterminate: false
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: btnPrev.right
        anchors.leftMargin: 8

        Text {
            id: progressText
            x: 167
            y: 9
            text: qsTr("")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 12
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                progressSeek(mouse.x, width)
            }
        }
    }

}