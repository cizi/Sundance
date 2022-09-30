using Toybox.Application;
using Toybox.WatchUi;

class SundanceApp extends Application.AppBase {

    var weatherForecast = null;

    // const for settings
    const MOON_PHASE = 0;
    const SUNSET_SUNSRISE = 1;
    const FLOORS = 2;
    const CALORIES = 3;
    const STEPS = 4;
    const HR = 5;
    const BATTERY = 6;
    const ALTITUDE = 7;
    const PRESSURE = 8;
    const NEXT_SUN_EVENT = 9;
    const SECOND_TIME = 10;
    const SOLAR_INTENSITY = 13;
    const WEATHER = 14;
    const DISABLED = 100;
    const DISTANCE = 11;
    const BATTERY_IN_DAYS = 12;

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
            app.Storage.setValue("smallDialCoordsNums", uc.calculateSmallDialNumsForBuildInBezel(halfWidth));
        } else {
            app.Storage.setValue("smallDialCoordsNums", uc.calculateSmallDialNums(halfWidth));
        }

        // Weather
        if ((app.getProperty("Opt1") == WEATHER) || (app.getProperty("Opt2") == WEATHER) || (app.getProperty("Opt3") == WEATHER) || (app.getProperty("Opt4") == WEATHER)) {
            weatherForecast = new WeatherForecast();
        } else {
            weatherForecast = null;
        }

        WatchUi.requestUpdate();
    }
}