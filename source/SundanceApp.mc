using Toybox.Application;
using Toybox.WatchUi;

class SundanceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new SundanceView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
        var uc = new UiCalc();
        var halfWidth = Application.getApp().getProperty("halfWidth");
        var app = Application.getApp();
        if (app.getProperty("UseWatchBezel")) {
            app.setProperty("smallDialCoordsNums", uc.calculateSmallDialNumsForBuildInBezel(halfWidth));
        } else {
            app.setProperty("smallDialCoordsNums", uc.calculateSmallDialNums(halfWidth));
        }
        WatchUi.requestUpdate();
    }

}