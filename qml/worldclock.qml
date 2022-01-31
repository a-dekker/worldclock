

/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import QtQuick 2.2
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import harbour.worldclock.Settings 1.0
import Sailfish.Timezone 1.0
// not_allowed_in_store
import "pages"
import "cover"

ApplicationWindow {
    id: mainapp
    property string city_id: ''
    property string localTime: ''
    property string localContinent: ContinentName
    property string localCity: CityName
    property string localCityTr: ''
    property bool viewable: cover.status === Cover.Active || applicationActive
    property string timeFormat: '24'
    property string myAliases
    property bool isLightTheme: {
        if (Theme.colorScheme === Theme.LightOnDark)
            return false
        else
            return true
    }

    allowedOrientations: defaultAllowedOrientations
    _defaultPageOrientations: defaultAllowedOrientations

    initialPage: Component {
        MainPage {}
    }

    cover: CoverPage {
        id: cover
    }

    MySettings {
        id: myset
    }

    // not_allowed_in_store
    Component {
        id: timezonePickerComponent
        TimezonePicker {
            onTimezoneClicked: {
                console.log(name)
                if (name !== "") {
                    mainapp.city_id = name
                }
                pageStack.pop()
            }
        }
    }

    ConfigurationValue {
        id: timeFormatConfig
        key: "/sailfish/i18n/lc_timeformat24h"
    }

    function getAMPM() {
        timeFormat = timeFormatConfig.value
    }

    Timer {
        id: timerclock

        interval: 15000 // every 15 secs update for now
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cover.updateTime()
        }
        running: viewable
    }

    function newCity() {
        if (myset.value("city_pickertype", "0") === "0") {
            var cityPage = pageStack.find(function (page) {
                return page.objectName === "Timezone"
            })
            pageStack.pop(cityPage, PageStackAction.Immediate)
            pageStack.push(Qt.resolvedUrl("pages/Timezone.qml"), {},
                           PageStackAction.Immediate)
        } else {
            var cityPage = pageStack.find(function (page) {
                return page.objectName === "timezonePickerComponent"
            })
            pageStack.pop(cityPage, PageStackAction.Immediate)
            pageStack.push(timezonePickerComponent) // not_allowed_in_store
        }
    }

    Component.onCompleted: {
        getAMPM()
        timerclock.start()
    }
}
