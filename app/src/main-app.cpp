//////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2007-2017 Casey Langen
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice,
//      this list of conditions and the following disclaimer.
//
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//
//    * Neither the name of the author nor the names of other contributors may
//      be used to endorse or promote products derived from this software
//      without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
//////////////////////////////////////////////////////////////////////////////

#include <QtCore/qglobal.h>

#ifndef QT_HAS_XD
#  error "dimmer requires the XD framework (https://github.com/top-master/XD); plain Qt is not supported. Point qmake at XD's bin/qmake.exe or set XD_ROOT before running build.sh."
#endif

#include <QApplication>

#include <Windows.h>
#include <Commctrl.h>
#include <string>
#include <vector>
#include <map>
#include <memory>

#include "Monitor.h"
#include "Overlay.h"
#include "TrayMenu.h"
#include "Util.h"

#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")

using OverlayPtr = std::shared_ptr<dimmer::Overlay>;
using Overlays = std::map<std::wstring, OverlayPtr>;
static Overlays overlays;
static std::vector<dimmer::Monitor> monitors;

static void updateOverlays(HINSTANCE instance) {
    monitors = dimmer::queryMonitors();

    Overlays old;
    std::swap(overlays, old);

    if (dimmer::isDimmerEnabled()) {
        for (auto monitor : monitors) {
            auto id = monitor.getId();
            auto it = old.find(monitor.getId());

            OverlayPtr overlay;
            if (it != old.end()) {
                overlay = it->second;
                overlay->update(monitor);
            }
            else {
                overlay = std::make_shared<dimmer::Overlay>(instance, monitor);
            }

            overlays[id] = overlay;
        }
    }
}

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    HINSTANCE instance = ::GetModuleHandleW(nullptr);

    InitCommonControlsEx(nullptr);

    dimmer::loadConfig();

    dimmer::TrayMenu trayMenu(instance, [instance]() {
        updateOverlays(instance);
    });

    trayMenu.setPopupMenuChangedCallback([](bool visible) {
        for (auto overlay : overlays) {
            if (visible) {
                overlay.second->killTimer();
            }
            else {
                overlay.second->startTimer();
            }
        }
    });

    int rc = app.exec();

    dimmer::saveConfig();

    monitors.clear();
    overlays.clear();

    return rc;
}

