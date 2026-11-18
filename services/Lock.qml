pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pam

Singleton {
    id: root

    readonly property bool requested: persistent.locked
    property bool secure: false
    property bool leaving: false
    readonly property bool checking: pam.active && !responseExpected
    property string message: ""
    property string pending: ""
    property bool responseExpected: false
    signal aboutToLock
    signal failed

    function lock(): void {
        if (requested)
            return;
        message = "";
        leaving = false;
        aboutToLock();
        persistent.locked = true;
    }
    function submit(secret: string): void {
        if (!requested || !secure || leaving || !secret.length)
            return;
        message = "";
        if (pam.active) {
            if (responseExpected) {
                responseExpected = false;
                pam.respond(secret);
            }
            return;
        }
        pending = secret;
        if (!pam.start())
            fail("Unable to start authentication.");
    }
    function fail(reason: string): void {
        pending = "";
        responseExpected = false;
        message = reason;
        failed();
    }
    PersistentProperties {
        id: persistent
        reloadableId: "testshell-lock"
        property bool locked: false
    }
    PamContext {
        id: pam
        // Use the system's existing login authentication policy.
        config: "login"
        onPamMessage: {
            if (responseRequired) {
                if (root.pending.length) {
                    const response = root.pending;
                    root.pending = "";
                    respond(response);
                } else {
                    root.responseExpected = true;
                    root.message = "Additional authentication required.";
                }
            }
        }
        onCompleted: result => {
            root.pending = "";
            root.responseExpected = false;
            if (result === PamResult.Success && root.requested && root.secure) {
                root.message = "";
                root.leaving = true;
            } else if (result === PamResult.MaxTries) {
                root.fail("Too many attempts. Try again later.");
            } else {
                root.fail("Authentication failed. Try again.");
            }
        }
        onError: error => root.fail("Authentication is unavailable.")
    }
    Timer {
        interval: 200
        running: root.leaving && root.secure
        onTriggered: {
            if (root.leaving && root.secure) {
                persistent.locked = false;
                root.leaving = false;
            }
        }
    }
}
