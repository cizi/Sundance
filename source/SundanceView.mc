using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application as App;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;

class SundanceView extends WatchUi.WatchFace {

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
    const DISABLED = 100;
    const DISTANCE = 11;
    const BATTERY_IN_DAYS = 12;
    const PRESSURE_ARRAY_KEY = "pressure";
    const SOLAR_INTENSITY_ARRAY_KEY = "solar";
    const SOALR_X_STEP = 4;
    const SOLAR_Y_STEP = 0.22;

    // others
    hidden var settings;
    hidden var app;
    hidden var is218dev;
    hidden var is240dev;
    hidden var is280dev;
    // hidden var is416dev; Epix2, Venu2 etc. need polishing
    hidden var secPosX;
    hidden var secPosY;
    hidden var secFontWidth;
    hidden var secFontHeight;
    hidden var uc;
    hidden var smallDialCoordsLines;
    hidden var activityInfo;
    hidden var dataFieldsYCentering;

    // Sunset / sunrise / moon phase vars
    hidden var sc;
    hidden var sunriseMoment;
    hidden var sunsetMoment;
    hidden var blueAmMoment;
    hidden var bluePmMoment;
    hidden var goldenAmMoment;
    hidden var goldenPmMoment;
    hidden var location = null;
    hidden var moonPhase;

    // night mode
    hidden var frColor = null;
    hidden var bgColor = null;
    hidden var themeColor = null;

    hidden var fnt1 = null;
    hidden var fnt2 = null;
    hidden var fnt3 = null;
    hidden var fnt4 = null;
    hidden var fnt5 = null;
    hidden var fnt7 = null;
    hidden var fnt8 = null;
    hidden var fnt9 = null;
    hidden var fnt11 = null;
    hidden var fnt10 = null;
    hidden var fnt13 = null;
    hidden var fnt14 = null;
    hidden var fnt15 = null;
    hidden var fnt16 = null;
    hidden var fnt17 = null;
    hidden var fnt19 = null;
    hidden var fnt20 = null;
    hidden var fnt21 = null;
    hidden var fnt22 = null;
    hidden var fnt23 = null;

    hidden var fnt1r = null;
    hidden var fnt2r = null;
    hidden var fnt3r = null;
    hidden var fnt4r = null;
    hidden var fnt5r = null;
    hidden var fnt7r = null;
    hidden var fnt8r = null;
    hidden var fnt9r = null;
    hidden var fnt11r = null;
    hidden var fnt10r = null;
    hidden var fnt13r = null;
    hidden var fnt14r = null;
    hidden var fnt15r = null;
    hidden var fnt16r = null;
    hidden var fnt17r = null;
    hidden var fnt19r = null;
    hidden var fnt20r = null;
    hidden var fnt21r = null;
    hidden var fnt22r = null;
    hidden var fnt23r = null;

    hidden var fntIcons = null;
    hidden var fntDataFields = null;
    hidden var useBezelAsDial = null;

    hidden var halfWidth = null;
    hidden var field1 = null;
    hidden var field2 = null;
    hidden var field3 = null;
    hidden var field4 = null;

    function initialize() {
        WatchFace.initialize();
        app = App.getApp();
        sc = new SunCalc();
        uc = new UiCalc();

        fnt1 = WatchUi.loadResource(Rez.Fonts.fntSd01);
        fnt2 = WatchUi.loadResource(Rez.Fonts.fntSd02);
        fnt3 = WatchUi.loadResource(Rez.Fonts.fntSd03);
        fnt4 = WatchUi.loadResource(Rez.Fonts.fntSd04);
        fnt5 = WatchUi.loadResource(Rez.Fonts.fntSd05);
        fnt7 = WatchUi.loadResource(Rez.Fonts.fntSd07);
        fnt8 = WatchUi.loadResource(Rez.Fonts.fntSd08);
        fnt9 = WatchUi.loadResource(Rez.Fonts.fntSd09);
        fnt10 = WatchUi.loadResource(Rez.Fonts.fntSd10);
        fnt11 = WatchUi.loadResource(Rez.Fonts.fntSd11);
        fnt13 = WatchUi.loadResource(Rez.Fonts.fntSd13);
        fnt14 = WatchUi.loadResource(Rez.Fonts.fntSd14);
        fnt15 = WatchUi.loadResource(Rez.Fonts.fntSd15);
        fnt16 = WatchUi.loadResource(Rez.Fonts.fntSd16);
        fnt17 = WatchUi.loadResource(Rez.Fonts.fntSd17);
        fnt19 = WatchUi.loadResource(Rez.Fonts.fntSd19);
        fnt20 = WatchUi.loadResource(Rez.Fonts.fntSd20);
        fnt21 = WatchUi.loadResource(Rez.Fonts.fntSd21);
        fnt22 = WatchUi.loadResource(Rez.Fonts.fntSd22);
        fnt23 = WatchUi.loadResource(Rez.Fonts.fntSd23);

        fnt1r = WatchUi.loadResource(Rez.Fonts.fntSd01_r);
        fnt2r = WatchUi.loadResource(Rez.Fonts.fntSd02_r);
        fnt3r = WatchUi.loadResource(Rez.Fonts.fntSd03_r);
        fnt4r = WatchUi.loadResource(Rez.Fonts.fntSd04_r);
        fnt5r = WatchUi.loadResource(Rez.Fonts.fntSd05_r);
        fnt11r = WatchUi.loadResource(Rez.Fonts.fntSd11_r);
        fnt10r = WatchUi.loadResource(Rez.Fonts.fntSd10_r);
        fnt9r = WatchUi.loadResource(Rez.Fonts.fntSd09_r);
        fnt8r = WatchUi.loadResource(Rez.Fonts.fntSd08_r);
        fnt7r = WatchUi.loadResource(Rez.Fonts.fntSd07_r);
        fnt13r = WatchUi.loadResource(Rez.Fonts.fntSd13_r);
        fnt14r = WatchUi.loadResource(Rez.Fonts.fntSd14_r);
        fnt15r = WatchUi.loadResource(Rez.Fonts.fntSd15_r);
        fnt16r = WatchUi.loadResource(Rez.Fonts.fntSd16_r);
        fnt17r = WatchUi.loadResource(Rez.Fonts.fntSd17_r);
        fnt19r = WatchUi.loadResource(Rez.Fonts.fntSd19_r);
        fnt20r = WatchUi.loadResource(Rez.Fonts.fntSd20_r);
        fnt21r = WatchUi.loadResource(Rez.Fonts.fntSd21_r);
        fnt22r = WatchUi.loadResource(Rez.Fonts.fntSd22_r);
        fnt23r = WatchUi.loadResource(Rez.Fonts.fntSd23_r);

        fntIcons = WatchUi.loadResource(Rez.Fonts.fntIcons);
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        is218dev = (dc.getWidth() == 218);
        is240dev = (dc.getWidth() == 240);
        is280dev = (dc.getWidth() == 280);
        // is416dev = (dc.getWidth() == 416);

        halfWidth = dc.getWidth() / 2;
        secFontHeight = Gfx.getFontHeight(Gfx.FONT_TINY);
        secFontWidth = (is280dev ? 24 : 22);
        secPosX = dc.getWidth() - 15;
        secPosY = halfWidth - (secFontHeight / 2) - 3;

        var yPosFor23 = ((dc.getHeight() / 6).toNumber() * 4) - 9;
        if (is218dev) {
            field1 = [halfWidth - 23, 54];
        } else {
            field1 = [halfWidth - 23, 60];
        }
        field2 = [(dc.getWidth() / 5) + 2, yPosFor23];
        field3 = [halfWidth + 56, yPosFor23];
        field4 = [(dc.getWidth() / 13) * 7, ((dc.getHeight() / 4).toNumber() * 3) - 6];     // on F6 [140, 189]

        app.setProperty("halfWidth", halfWidth);
        if (app.getProperty("UseWatchBezel")) {
            app.setProperty("smallDialCoordsNums", uc.calculateSmallDialNumsForBuildInBezel(halfWidth));
        } else {
            app.setProperty("smallDialCoordsNums", uc.calculateSmallDialNums(halfWidth));
        }
        smallDialCoordsLines = uc.calculateSmallDialLines(halfWidth);

        // sun / moon etc. init
        sunriseMoment = null;
        sunsetMoment = null;
        blueAmMoment = null;
        bluePmMoment = null;
        goldenAmMoment = null;
        goldenPmMoment = null;
        moonPhase = null;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        if (dc has :clearClip) {    // Clear any partial update clipping.
            dc.clearClip();
        }

        // base objects reload
        activityInfo = Activity.getActivityInfo();

        // field font setting
        // if (is416dev) {
        //     fntDataFields = Gfx.FONT_LARGE;
        // } else {
            // fntDataFields = WatchUi.loadResource(Rez.Fonts.fntDataFields);
        if (App.getApp().getProperty("UseBiggerFontDataFields")) {
            fntDataFields = WatchUi.loadResource(Rez.Fonts.fntDataFieldsX);
            dataFieldsYCentering = 3;
        } else {
            fntDataFields = WatchUi.loadResource(Rez.Fonts.fntDataFields);
            dataFieldsYCentering = 0;
        }
        // }
        useBezelAsDial = App.getApp().getProperty("UseWatchBezel");

        var now = Time.now();
        var today = Gregorian.info(now, Time.FORMAT_MEDIUM);
        // if don't have the sun times load it if from position or load again in midnight
        if ((sunriseMoment == null) || (sunsetMoment == null)) {
            reloadSuntimes(now);    // calculate for current date
        }

        // the values are known, need to find last sun event for today and recalculated the first which will come tomorrow
        if ((sunriseMoment != null) && (sunsetMoment != null) && (location != null)) {
            var lastSunEventInDayMoment = (App.getApp().getProperty("ShowGoldenBlueHours") ? bluePmMoment : sunsetMoment);
            var nowWithOneMinute = now.add(new Time.Duration(60));
            // if sunrise moment is in past && is after last sunevent (bluePmMoment / sunsetMoment) need to recalculate
            if ((nowWithOneMinute.compare(sunriseMoment) > 0) && (nowWithOneMinute.compare(lastSunEventInDayMoment) > 0)) { // is time to recalculte?
                var nowWithOneDay = now.add(new Time.Duration(Gregorian.SECONDS_PER_DAY));
                reloadSuntimes(nowWithOneDay);
            }
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        settings = System.getDeviceSettings();
        var isNight = checkIfNightMode(sunriseMoment, sunsetMoment, new Time.Moment(now.value()));  // needs to by firts bucause of isNight variable
        if (isNight) {
            frColor = 0x000000;
            bgColor = 0xFFFFFF;
            themeColor = (App.getApp().getProperty("NightModeTheme") ? App.getApp().getProperty("NightModeThemeColor") : App.getApp().getProperty("DaylightProgess"));
        } else {
            frColor = App.getApp().getProperty("ForegroundColor");
            bgColor = App.getApp().getProperty("BackgroundColor");
            themeColor = App.getApp().getProperty("DaylightProgess");
        }

        drawDial(dc, today);                                // main dial
        if (App.getApp().getProperty("ShowFullDial")) {     // subdial small numbers
            drawNrDial(dc);
        }

        drawSunsetSunriseLine(field1[0], field1[1], dc, today);     // SUNSET / SUNRICE line from public variables

        // DATE
        if (App.getApp().getProperty("DateFormat") != DISABLED) {
            var dateString = getFormatedDate();
            var moonCentering = 0;
            if (App.getApp().getProperty("ShowMoonPhaseBeforeDate")) {
                today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
                var dateWidth = dc.getTextWidthInPixels(dateString, Gfx.FONT_TINY);
                moonCentering = 14;
                var moonY = is218dev ? 70 : 78;
                drawMoonPhase(halfWidth - (dateWidth / 2) - 6, moonY, dc, getMoonPhase(today), 0);
            }
            dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
            var dateY = is218dev ? 59 : 65;
            dc.drawText(halfWidth + moonCentering, dateY, Gfx.FONT_TINY, dateString, Gfx.TEXT_JUSTIFY_CENTER);
        }
        
        // Logging pressure history each hour and only if I don't have the value already logged
        var lastPressureLoggingTimeHistoty = (app.getProperty("lastPressureLoggingTimeHistoty") == null ? null : app.getProperty("lastPressureLoggingTimeHistoty").toNumber());
        if ((today.min == 0) && (today.hour != lastPressureLoggingTimeHistoty)) {
            handlePressureHistorty(getPressure());
            app.setProperty("lastPressureLoggingTimeHistoty", today.hour);
        }

        // Logging solar intensity history each five minutes only if I don't have the value already logged
        var lastSolarLoggingTimeHistory = (app.getProperty("lastSolarLoggingTimeHistory") == null ? null : app.getProperty("lastSolarLoggingTimeHistory").toNumber());
        if ((today.min % App.getApp().getProperty("SolarIntensityPeriod").toNumber() == 0) && (today.min != lastSolarLoggingTimeHistory)) {
            var solarIntensityCurrent = 0;
            if (System.getSystemStats() has :solarIntensity) {
                solarIntensityCurrent = System.getSystemStats().solarIntensity == null ? 0 : System.getSystemStats().solarIntensity.toNumber();
                solarIntensityCurrent = solarIntensityCurrent < 0 ? 0 : solarIntensityCurrent;
            }
            handleSolarIntensityHistory(solarIntensityCurrent);
            app.setProperty("lastSolarLoggingTimeHistory", today.min);
        }

        // second time calculation and dial drawing if any
        var secondTime = calculateSecondTime(new Time.Moment(now.value()));
        if (App.getApp().getProperty("ShowSecondTimeOnDial")) {
            drawTimePointerInDial(secondTime, App.getApp().getProperty("SecondTimePointerType"), App.getApp().getProperty("SecondTimeOnDialColor"), dc);
        }
        
        drawDataField(App.getApp().getProperty("Opt1"), 1, field1, today, secondTime, dc);  // FIELD 1
        drawDataField(App.getApp().getProperty("Opt2"), 2, field2, today, secondTime, dc);  // FIELD 2
        drawDataField(App.getApp().getProperty("Opt3"), 3, field3, today, secondTime, dc);  // FIELD 3
        drawDataField(App.getApp().getProperty("Opt4"), 4, field4, today, secondTime, dc);  // FIELD 4
        
        if (App.getApp().getProperty("ShowConnection")) {
            drawBtConnection(dc);
        }
        
        if (App.getApp().getProperty("ShowNotification")) {            
            drawNotification(dc);
        }
        
        if (App.getApp().getProperty("AlarmIndicator")) {
            drawBell(dc);
        }

        // TIME
        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        var timeString = getFormattedTime(today.hour, today.min);
        dc.drawText(46, halfWidth - (dc.getFontHeight(Gfx.FONT_SYSTEM_NUMBER_HOT) / 2) + 2, fntDataFields, timeString[:amPmFull], Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(halfWidth, halfWidth - (Gfx.getFontHeight(Gfx.FONT_SYSTEM_NUMBER_HOT) / 2), Gfx.FONT_SYSTEM_NUMBER_HOT, timeString[:formatted], Gfx.TEXT_JUSTIFY_CENTER);

        // CURRENT TIME POINTER
        drawTimePointerInDial(today, App.getApp().getProperty("CurrentTimePointerType"), App.getApp().getProperty("CurrentTimePointer"), dc);
    }


    function onPartialUpdate(dc) {
        if (App.getApp().getProperty("ShowSeconds")) {
            dc.setClip(secPosX - secFontWidth, secPosY - 2, secFontWidth, secFontHeight);
            dc.setColor(frColor, bgColor);
            dc.clear();
            var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
            dc.drawText(secPosX, secPosY, Gfx.FONT_TINY, today.sec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT); // seconds
        }
    }


    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {

    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    
    // Draw data field by params. One function do all the fields by coordinates and position
    function drawDataField(dataFiled, position, fieldCors, today, secondTime, dc) {
        switch (dataFiled) {
            case MOON_PHASE:
            today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            drawMoonPhase(fieldCors[0], fieldCors[1], dc, getMoonPhase(today), position);
            break;

            case SUNSET_SUNSRISE:
            drawSunsetSunriseTime(fieldCors[0], fieldCors[1], dc, position);
            break;

            case NEXT_SUN_EVENT:
            drawNextSunTime(fieldCors[0], fieldCors[1], dc, position);
            break;

            case BATTERY:
            drawBattery(fieldCors[0], fieldCors[1], dc, position, today, false);
            break;
            
            case BATTERY_IN_DAYS:
            drawBattery(fieldCors[0], fieldCors[1], dc, position, today, true);
            break;

            case HR:
            drawHr(fieldCors[0], fieldCors[1], dc, position);
            break;

            case PRESSURE:
            drawPressure(fieldCors[0], fieldCors[1], dc, getPressure(), today, position);
            break;

            case STEPS:
            drawSteps(fieldCors[0], fieldCors[1], dc, position);
            break;
            
            case DISTANCE:
            drawDistance(fieldCors[0], fieldCors[1], dc, position);
            break;

            case ALTITUDE:
            drawAltitude(fieldCors[0], fieldCors[1], dc, position);
            break;

            case FLOORS:
            drawFloors(fieldCors[0], fieldCors[1], dc, position);
            break;

            case CALORIES:
            drawCalories(fieldCors[0], fieldCors[1], dc, position);
            break;
            
            case SECOND_TIME:
            drawSecondTime(fieldCors[0], fieldCors[1], dc, secondTime, position);
            break;

            case SOLAR_INTENSITY:
            drawSolarIntensity(fieldCors[0], fieldCors[1], dc, today, position);
            break;
        }
    }
    
    // Draw time pointer in dial by type, color and of course time
    function drawTimePointerInDial(time, pointerType, pointerColor, dc) {
        switch(pointerType) {           
            case 1:
            dc.setPenWidth(App.getApp().getProperty("CurrentTimePointerWidth"));
            var timeCoef = (time.hour + (time.min.toFloat() / 60)) * 15;
            // 270 was corrected better placing of current time holder
            var timeStart = 272 - timeCoef + (useBezelAsDial ? 180 : 0); 
            // 270 was corrected better placing of current time holder
            var timeEnd = 268 - timeCoef + (useBezelAsDial ? 180 : 0);   
            dc.setColor(pointerColor, Gfx.COLOR_TRANSPARENT);
            dc.drawArc(halfWidth, halfWidth, halfWidth - 2, Gfx.ARC_CLOCKWISE, timeStart, timeEnd);
            break;

            case 2:
            drawPointToDialFilled(dc, pointerColor, time);
            break;
            
            case 3:
            drawPointToDialTransparent(dc, pointerColor, time);
            break;
            
            case 4:
            drawSuuntoLikePointer(dc, pointerColor, time);
            break;
        }
    }
    
    
    // Calculate second time from setting option
    // returns Gregorian Info
    function calculateSecondTime(todayMoment) {
        var utcOffset = System.getClockTime().timeZoneOffset * -1;
        var utcMoment = todayMoment.add(new Time.Duration(utcOffset));
        var secondTimeMoment = utcMoment.add(new Time.Duration(App.getApp().getProperty("SecondTimeUtcOffset")));
        
        return sc.momentToInfo(secondTimeMoment);
    }
    
    
    // Draw second time liek a data field
    function drawSecondTime(xPos, yPos, dc, secondTime, position) {
        if (position == 1) {
            xPos += 24;
            yPos -= 17;
        }
        if (position == 2) {
            xPos += 21;
        }
        if (position == 3) {
            xPos -= (is280dev ? -2 : (is240dev ? 9 : 3));
        }
        if (position == 4) {
            xPos -= ((is240dev == false) && (is280dev == false) ? 9 : 5);
        }
        var value = getFormattedTime(secondTime.hour, secondTime.min);
        value = value[:formatted] + value[:amPm];
        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPos, yPos, fntDataFields, value, Gfx.TEXT_JUSTIFY_CENTER);
    }

    function drawSolarIntensity(xPos, yPos, dc, today, position) {
        yPos -= 1;
        if (position == 1) {
            xPos += 32;
            yPos -= 19;
        }
        if (position == 2) {
            xPos += 42;
        }

        var solar1 = app.getProperty(SOLAR_INTENSITY_ARRAY_KEY + "0");   // always need a current value which is saved on position 0
        if (solar1 == null) {
            dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(xPos, yPos, fntDataFields, "W8", Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            var solarInt;
            var solarIntPrev;
            var sol;
            dc.setPenWidth(2);
            dc.setColor(themeColor, Gfx.COLOR_TRANSPARENT);
            var xPosGraph = xPos - 15;
            var yPosGraph = yPos + 21;
            for(sol = 6; sol > 1; sol-=1) {
                solarInt = app.getProperty(SOLAR_INTENSITY_ARRAY_KEY + sol.toString());

                solarIntPrev = app.getProperty(SOLAR_INTENSITY_ARRAY_KEY + (sol - 1).toString());
                dc.drawLine(xPosGraph - (sol * SOALR_X_STEP).toNumber(), yPosGraph - (SOLAR_Y_STEP * solarInt).toNumber(), xPosGraph - ((sol - 1) * SOALR_X_STEP).toNumber(), yPosGraph - (SOLAR_Y_STEP * solarIntPrev).toNumber());
            }
            //System.println(solar1);
            dc.drawLine(xPosGraph - (sol * SOALR_X_STEP), yPosGraph - (SOLAR_Y_STEP * solarIntPrev).toNumber(), xPosGraph, yPosGraph - (SOLAR_Y_STEP * solar1).toNumber());

            dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(xPos, yPos, fntDataFields, solar1, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

    // Load or refresh the sun times
    function reloadSuntimes(now) {
        var suntimes = getSunTimes(now);
        sunriseMoment = suntimes[:sunrise];
        sunsetMoment = suntimes[:sunset];
        blueAmMoment = suntimes[:blueAm];
        bluePmMoment = suntimes[:bluePm];
        goldenAmMoment = suntimes[:goldenAm];
        goldenPmMoment = suntimes[:goldenPm];
    }

    // Draw current HR
    function drawHr(xPos, yPos, dc, position) {
        if (position == 1) {
            xPos += 44;
            yPos = (is240dev ? yPos - 18 : yPos - 16);
        }
        if ((position == 2) && is240dev) {
            xPos += 42;
        } else if ((position == 2) && is280dev) {
            xPos += 47;
        } else if (position == 2) {
            xPos += 37;
        }
        if ((position == 3) || (position == 4)) {
            xPos += 11;
        }
        dc.setColor(themeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(xPos - 44, yPos - 3, fntIcons, "3", Gfx.TEXT_JUSTIFY_LEFT);

        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        var hr = "--";
        if (activityInfo.currentHeartRate != null) {
            hr = activityInfo.currentHeartRate.toString();
        }
        dc.drawText(xPos - 19, yPos - dataFieldsYCentering, fntDataFields, hr, Gfx.TEXT_JUSTIFY_LEFT);
    }


    // calculate sunset and sunrise times based on location
    // return array of moments
    function getSunTimes(now) {
        // Get today's sunrise/sunset times in current time zone.
        var sunrise = null;
        var sunset = null;
        var blueAm = null;
        var bluePm = null;
        var goldenAm = null;
        var goldenPm = null;

        location = activityInfo.currentLocation;
        if (location) {
            location = activityInfo.currentLocation.toRadians();
            app.setProperty("location", location);
        } else {
            location = app.getProperty("location");
        }

         if (location != null) {
            sunrise = sc.calculate(now, location, SUNRISE);
            sunset = sc.calculate(now, location, SUNSET);

            blueAm = sc.calculate(now, location, BLUE_HOUR_AM);
            bluePm = sc.calculate(now, location, BLUE_HOUR_PM);

            goldenAm = sc.calculate(now, location, GOLDEN_HOUR_AM);
            goldenPm = sc.calculate(now, location, GOLDEN_HOUR_PM);
        }

        return {
            :sunrise => sunrise,
            :sunset => sunset,
            :blueAm => blueAm,
            :bluePm => bluePm,
            :goldenAm => goldenAm,
            :goldenPm => goldenPm
        };
    }

    function drawSunsetSunriseLine(xPos, yPos, dc, today) {
        if ((sunriseMoment != null) && (sunsetMoment != null)) {
            var rLocal = halfWidth - 2;

            // BLUE & GOLDEN HOUR
            if (App.getApp().getProperty("ShowGoldenBlueHours")) {
                drawDialLine(
                    halfWidth,
                    halfWidth,
                    rLocal,
                    sc.momentToInfo(blueAmMoment),
                    sc.momentToInfo(bluePmMoment),
                    App.getApp().getProperty("DaylightProgessWidth"),
                    App.getApp().getProperty("BlueHourColor"),
                    dc
                );

                // NORMAL SUN = GOLDEN COLOR
                drawDialLine(
                    halfWidth,
                    halfWidth,
                    rLocal,
                    sc.momentToInfo(sunriseMoment),
                    sc.momentToInfo(sunsetMoment),
                    App.getApp().getProperty("DaylightProgessWidth"),
                    App.getApp().getProperty("GoldenHourColor"),
                    dc
                );

                // GOLDEN = NORMAL COLOR
                drawDialLine(
                    halfWidth,
                    halfWidth,
                    rLocal,
                    sc.momentToInfo(goldenAmMoment),
                    sc.momentToInfo(goldenPmMoment),
                    App.getApp().getProperty("DaylightProgessWidth"),
                    themeColor,
                    dc
                );
            } else { // JUST NORMAL SUN
                drawDialLine(
                    halfWidth,
                    halfWidth,
                    rLocal,
                    sc.momentToInfo(sunriseMoment),
                    sc.momentToInfo(sunsetMoment),
                    App.getApp().getProperty("DaylightProgessWidth"),
                    themeColor,
                    dc
                );
            }
        }
    }


    // draw the line by the parametrs
    function drawDialLine(arcX, arcY, radius, momentStart, momentEnd, penWidth, color, dc) {
        var angleCoef = 15;
        dc.setPenWidth(penWidth);
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);

        var startDecimal = momentStart.hour + (momentStart.min.toDouble() / 60);
        var lineStart = 270 - (startDecimal * angleCoef) + (useBezelAsDial ? 180 : 0);

        var endDecimal = momentEnd.hour + (momentEnd.min.toDouble() / 60);
        var lineEnd = 270 - (endDecimal * angleCoef) + (useBezelAsDial ? 180 : 0);

        dc.drawArc(arcX, arcY, radius, Gfx.ARC_CLOCKWISE, lineStart, lineEnd);
    }


    // draw next sun event
    function drawNextSunTime(xPos, yPos, dc, position) {
        if (location != null) {
            if (position == 1) {
                xPos -= 6;
            }
            if (position == 4) {
                xPos -= 38;
                yPos += 14;
            }

            if ((sunriseMoment != null) && (sunsetMoment != null)) {
                var nextSunEvent = 0;
                var now = new Time.Moment(Time.now().value());
                // Convert to same format as sunTimes, for easier comparison. Add a minute, so that e.g. if sun rises at
                // 07:38:17, then 07:38 is already consided daytime (seconds not shown to user).
                now = now.add(new Time.Duration(60));

                if (blueAmMoment.compare(now) > 0) {            // Before blue hour today: today's blue hour is next.
                    nextSunEvent = sc.momentToInfo(blueAmMoment);
                    drawSun(xPos, yPos, dc, false, App.getApp().getProperty("BlueHourColor"));
                } else if (sunriseMoment.compare(now) > 0) {        // Before sunrise today: today's sunrise is next.
                    nextSunEvent = sc.momentToInfo(sunriseMoment);
                    drawSun(xPos, yPos, dc, false, App.getApp().getProperty("GoldenHourColor"));
                } else if (goldenAmMoment.compare(now) > 0) {
                    nextSunEvent = sc.momentToInfo(goldenAmMoment);
                    drawSun(xPos, yPos, dc, false, themeColor);
                } else if (goldenPmMoment.compare(now) > 0) {
                    nextSunEvent = sc.momentToInfo(goldenPmMoment);
                    drawSun(xPos, yPos, dc, true, App.getApp().getProperty("GoldenHourColor"));
                } else if (sunsetMoment.compare(now) > 0) { // After sunrise today, before sunset today: today's sunset is next.
                    nextSunEvent = sc.momentToInfo(sunsetMoment);
                    drawSun(xPos, yPos, dc, true, App.getApp().getProperty("BlueHourColor"));
                } else {    // This is here just for sure if some time condition won't meet the timing
                            // comparation. It menas I will force calculate the next event, the rest will be updated in
                            // the next program iteration - After sunset today: tomorrow's blue hour (if any) is next.
                    now = now.add(new Time.Duration(Gregorian.SECONDS_PER_DAY));
                    var blueHrAm = sc.calculate(now, location, BLUE_HOUR_AM);
                    nextSunEvent = sc.momentToInfo(blueHrAm);
                    drawSun(xPos, yPos, dc, false, App.getApp().getProperty("BlueHourColor"));
                }

                var value = getFormattedTime(nextSunEvent.hour, nextSunEvent.min); // App.getApp().getFormattedTime(hour, min);
                value = value[:formatted] + value[:amPm];
                dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
                dc.drawText(xPos + 21, yPos - 15 - dataFieldsYCentering, fntDataFields, value, Gfx.TEXT_JUSTIFY_LEFT);
            }
        }
    }


    // draw next sun event
    function drawSunsetSunriseTime(xPos, yPos, dc, position) {
        if (location != null) {
            if (position == 1) {
                xPos -= 6;
                yPos -= 2;
            }
            if (position == 4) {
                xPos -= 34;
                yPos += 14;
            }

            var now = new Time.Moment(Time.now().value());
            if ((sunriseMoment != null) && (sunsetMoment != null)) {
                var nextSunEvent = 0;
                // Convert to same format as sunTimes, for easier comparison. Add a minute, so that e.g. if sun rises at
                // 07:38:17, then 07:38 is already consided daytime (seconds not shown to user).
                now = now.add(new Time.Duration(60));

                // Before sunrise today: today's sunrise is next.
                if (sunriseMoment.compare(now) > 0) {       // now < sc.momentToInfo(sunrise)
                    nextSunEvent = sc.momentToInfo(sunriseMoment);
                    drawSun(xPos, yPos, dc, false, themeColor);
                    // After sunrise today, before sunset today: today's sunset is next.
                } else if (sunsetMoment.compare(now) > 0) { // now < sc.momentToInfo(sunset)
                    nextSunEvent = sc.momentToInfo(sunsetMoment);
                    drawSun(xPos, yPos, dc, true, themeColor);
                } else {    // This is here just for sure if some time condition won't meet the timing
                            // comparation. It menas I will force calculate the next event, the rest will be updated in
                            // the next program iteration -  After sunset today: tomorrow's sunrise (if any) is next.
                    now = now.add(new Time.Duration(Gregorian.SECONDS_PER_DAY));
                    var sunrise = sc.calculate(now, location, SUNRISE);
                    nextSunEvent = sc.momentToInfo(sunrise);
                    drawSun(xPos, yPos, dc, false, themeColor);
                }

                var value = getFormattedTime(nextSunEvent.hour, nextSunEvent.min); // App.getApp().getFormattedTime(hour, min);
                value = value[:formatted] + value[:amPm];
                dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
                //dc.drawText(xPos + 20, yPos - 15, fntDataFields, value, Gfx.TEXT_JUSTIFY_LEFT);
                dc.drawText(xPos + 21, yPos - 15 - dataFieldsYCentering, fntDataFields, value, Gfx.TEXT_JUSTIFY_LEFT);
            }
        }
    }


    // check if night mode on and if is night
    function checkIfNightMode(sunrise, sunset, now) {
        var isNight = false;
        if (App.getApp().getProperty("NightMode") && (sunrise != null) && (sunset != null)) {
            now = now.add(new Time.Duration(60));   // add 1 minute because I need to switch the colors in the next onUpdate iteration
            if (sunrise.compare(now) > 0) {     // Before sunrise today: today's sunrise is next.
                isNight = true;
            } else if (sunset.compare(now) > 0) {   // After sunrise today, before sunset today: today's sunset is next.
                isNight = false;
            } else {    // This is here just for sure if some time condition won't meet the timing
                        // comparation. It menas I will force calculate the next event, the rest will be updated in
                        // the next program iteration -  After sunset today: tomorrow's sunrise (if any) is next.
                isNight = true;
            }
        }

        return isNight;
    }

    // Will draw bell if is alarm set
    function drawBell(dc) {
        if (settings.alarmCount > 0) {
            var xPos = dc.getWidth() / 2;
            var yPos = ((dc.getHeight() / 6).toNumber() * 4) + 2;
            dc.setColor(frColor, bgColor);
            dc.fillCircle(xPos, yPos, 7);
            // dc.drawText(posX - 10, posY - 18, fntIcons, ":", Gfx.TEXT_JUSTIFY_LEFT);

            // stands
            dc.setPenWidth(3);
            dc.drawLine(xPos - 5, yPos, xPos - 7, yPos + 7);
            dc.drawLine(xPos + 5, yPos, xPos + 7, yPos + 7);

            dc.setPenWidth(2);
            dc.drawLine(xPos - 5, yPos - 7, xPos - 9, yPos - 3);
            dc.drawLine(xPos + 6, yPos - 7, xPos + 10, yPos - 3);

            dc.setColor(bgColor, frColor);
            dc.fillCircle(xPos, yPos, 5);

            // hands
            dc.setColor(frColor, bgColor);
            dc.drawLine(xPos, yPos, xPos, yPos - 5);
            dc.drawLine(xPos, yPos, xPos - 2, yPos + 4);
        }
    }

    // Draw the master dial
    function drawDial(dc, today) {
        var coorsArray = null;

        dc.setColor(bgColor, Gfx.COLOR_TRANSPARENT);    // nmake background
        dc.fillCircle(halfWidth, halfWidth, halfWidth + 1);

        // this part is draw the net over all display
        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(2);

        for(var angle = 0; angle < 360; angle+=15) {
            if ((angle != 0) && (angle != 90) && (angle != 180) && (angle != 270)) {
                    coorsArray = smallDialCoordsLines.get(angle);
                    dc.drawLine(halfWidth, halfWidth, coorsArray[0], coorsArray[1]);
            }
        }
        // hide the middle of the net to shows just pieces on the edge of the screen
        dc.setColor(bgColor, Gfx.COLOR_TRANSPARENT);
        dc.drawCircle(halfWidth, halfWidth, halfWidth - 1);
        dc.fillCircle(halfWidth, halfWidth, halfWidth - App.getApp().getProperty("SmallHoursIndicatorSize"));

        // draw the master pieces in 24, 12, 6, 18 hours point
        var masterPointLen = 12;
        var masterPointWid = 4;
        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(masterPointWid);
        dc.drawLine(halfWidth, 0, halfWidth, masterPointLen);
        dc.drawLine(halfWidth, dc.getWidth(), halfWidth, dc.getWidth() - masterPointLen);
        dc.drawLine(0, halfWidth - (masterPointWid / 2), masterPointLen, halfWidth - (masterPointWid / 2));
        dc.drawLine(dc.getWidth(), halfWidth - (masterPointWid / 2), dc.getWidth() - masterPointLen, halfWidth - (masterPointWid / 2));

        // numbers
        if (!useBezelAsDial) {
            dc.drawText(halfWidth, masterPointLen - 3, Gfx.FONT_TINY, "12", Gfx.TEXT_JUSTIFY_CENTER);   // 12
            dc.drawText(halfWidth, dc.getHeight() - Gfx.getFontHeight(Gfx.FONT_TINY) - 11, Gfx.FONT_TINY, "24", Gfx.TEXT_JUSTIFY_CENTER);   // 24
            dc.drawText(15, secPosY, Gfx.FONT_TINY, "06", Gfx.TEXT_JUSTIFY_LEFT);   // 06
        } else {
            dc.drawText(halfWidth, masterPointLen - 3, Gfx.FONT_TINY, "24", Gfx.TEXT_JUSTIFY_CENTER);   // 24
            dc.drawText(halfWidth, dc.getHeight() - Gfx.getFontHeight(Gfx.FONT_TINY) - 11, Gfx.FONT_TINY, "12", Gfx.TEXT_JUSTIFY_CENTER);   // 12
            dc.drawText(15, secPosY, Gfx.FONT_TINY, "18", Gfx.TEXT_JUSTIFY_LEFT);   // 18
        }

        if (App.getApp().getProperty("ShowSeconds")) {
            dc.drawText(secPosX, secPosY, Gfx.FONT_TINY, today.sec.format("%02d"), Gfx.TEXT_JUSTIFY_RIGHT); // seconds
        } else {
            if (!useBezelAsDial) {
                dc.drawText(secPosX, secPosY, Gfx.FONT_TINY, "18", Gfx.TEXT_JUSTIFY_RIGHT); // 18
            } else {
                dc.drawText(secPosX, secPosY, Gfx.FONT_TINY, "06", Gfx.TEXT_JUSTIFY_RIGHT); // 06
            }
        }
    }

    // draw the by params
    function drawDialNum(dc, coordinatesArray, value, font) {
        var char = null;
        for(var i = 0; i < value.length(); i+=1) {
            char = value.substring(i, i + 1);
            dc.drawText(coordinatesArray[i * 2], coordinatesArray[(i * 2) + 1], font, char, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }


    // Draw numbers in the dial
    function drawNrDial(dc) {
        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        var coords = null;
        var hourValue = null;
        var angleToNrCorrection = -6;
        var font = null;
        var fullDialConfig = App.getApp().getProperty("ShowFullDial").toNumber();
        for(var nr = 1; nr < 24; nr+=1) {
            if ((nr != 6) && (nr != 12) && (nr != 18) && ((nr % fullDialConfig) == 0)) {
                // needs to do it for each number because thre is now fucnking indirection call like $$var or ${var}
                hourValue = nr + angleToNrCorrection;
                coords = app.getProperty("smallDialCoordsNums").get(hourValue);
                if (useBezelAsDial) {
                    drawNrDialRev(dc, hourValue, coords);
                } else {
                    drawNrDialStan(dc, hourValue, coords);
                }
            }
        }
    }

    function drawNrDialStan(dc, hourValue, coords) {
        if (hourValue == -1) {  // 23
            drawDialNum(dc, coords, "23", fnt23);
        } else if (hourValue == -2) {   // 22
            drawDialNum(dc, coords, "22", fnt22);
        } else if (hourValue == -3) {   // 21
            drawDialNum(dc, coords, "21", fnt21);
        } else if (hourValue == -4) {   // 20
            drawDialNum(dc, coords, "20", fnt20);
        } else if (hourValue == -5) {   // 19
            drawDialNum(dc, coords, "19", fnt19);
        } else if (hourValue == 1) {    
            drawDialNum(dc, coords, hourValue.toString(), fnt1);
        } else if (hourValue == 2) {    
            drawDialNum(dc, coords, hourValue.toString(), fnt2);
        } else if (hourValue == 3) {    
            drawDialNum(dc, coords, hourValue.toString(), fnt3);
        } else if (hourValue == 4) {    
            drawDialNum(dc, coords, hourValue.toString(), fnt4);
        } else if (hourValue == 5) {
            drawDialNum(dc, coords, hourValue.toString(), fnt5);
        } else if (hourValue == 7) {
            drawDialNum(dc, coords, hourValue.toString(), fnt7);
        } else if (hourValue == 8) {
            drawDialNum(dc, coords, hourValue.toString(), fnt8);
        } else if (hourValue == 9) {
            drawDialNum(dc, coords, hourValue.toString(), fnt9);
        } else if (hourValue == 10) {
            drawDialNum(dc, coords, hourValue.toString(), fnt10);
        } else if (hourValue == 11) {
            drawDialNum(dc, coords, hourValue.toString(), fnt11);
        } else if (hourValue == 13) {
            drawDialNum(dc, coords, hourValue.toString(), fnt13);
        } else if (hourValue == 14) {
            drawDialNum(dc, coords, hourValue.toString(), fnt14);
        } else if (hourValue == 15) {
            drawDialNum(dc, coords, hourValue.toString(), fnt15);
        } else if (hourValue == 16) {
            drawDialNum(dc, coords, hourValue.toString(), fnt16);
        } else if (hourValue == 17) {
            drawDialNum(dc, coords, hourValue.toString(), fnt17);
        } 
    }

    function drawNrDialRev(dc, hourValue, coords) {
        var trueHour = (hourValue - 12).toString();
        if (hourValue == -1) {  // 23 = 11
            drawDialNum(dc, coords, "11", fnt11r);
        } else if (hourValue == -2) {   // 22 = 10
            drawDialNum(dc, coords, "10", fnt10r);
        } else if (hourValue == -3) {   // 21 = 9
            drawDialNum(dc, coords, "9", fnt9r);
        } else if (hourValue == -4) {   // 20 = 8
            drawDialNum(dc, coords, "8", fnt8r);
        } else if (hourValue == -5) {   // 19 = 7
            drawDialNum(dc, coords, "7", fnt7r);
        } else if (hourValue == 1) {    
            drawDialNum(dc, coords, "13", fnt13r);
        } else if (hourValue == 2) {    
            drawDialNum(dc, coords, "14", fnt14r);
        } else if (hourValue == 3) {    
            drawDialNum(dc, coords, "15", fnt15r);
        } else if (hourValue == 4) {    
            drawDialNum(dc, coords, "16", fnt16r);
        } else if (hourValue == 5) {
            drawDialNum(dc, coords, "17", fnt17r);
        } else if (hourValue == 7) {
            drawDialNum(dc, coords, "19", fnt19r);
        } else if (hourValue == 8) {
            drawDialNum(dc, coords, "20", fnt20r);
        } else if (hourValue == 9) {
            drawDialNum(dc, coords, "21", fnt21r);
        } else if (hourValue == 10) {
            drawDialNum(dc, coords, "22", fnt22r);
        } else if (hourValue == 11) {
            drawDialNum(dc, coords, "23", fnt23r);
        } else if (hourValue == 13) {
            drawDialNum(dc, coords, trueHour, fnt1r);
        } else if (hourValue == 14) {
            drawDialNum(dc, coords, trueHour, fnt2r);
        } else if (hourValue == 15) {
            drawDialNum(dc, coords, trueHour, fnt3r);
        } else if (hourValue == 16) {
            drawDialNum(dc, coords, trueHour, fnt4r);
        } else if (hourValue == 17) {
            drawDialNum(dc, coords, trueHour, fnt5r);
        } 
    }

    // Draw sunset or sunrice image
    function drawSun(posX, posY, dc, up, color) {
        dc.setColor(color, bgColor);
        if (up) {
            dc.drawText(posX - 10, posY - 18, fntIcons, "?", Gfx.TEXT_JUSTIFY_LEFT);
        } else {    // down
            dc.drawText(posX - 10, posY - 18, fntIcons, ">", Gfx.TEXT_JUSTIFY_LEFT);
        }


        /*var radius = 8;
        var penWidth = 2;
        dc.setPenWidth(penWidth);
        dc.setColor(themeColor, bgColor);
        dc.fillCircle(posX, posY, radius);
        dc.drawLine(posX - 12, posY + 1 , posX + 14, posY + 1);

        // arrow up
        dc.drawLine(posX, posY - (radius * 2), posX, posY - (radius * 2) + 8);
        if (up) {
            dc.drawLine(posX, posY - (radius * 2) + 7, posX + 6, posY - (radius * 2) + 3);
            dc.drawLine(posX, posY - (radius * 2) + 7, posX - 6, posY - (radius * 2) + 3);
        } else {    // arrow down
            dc.drawLine(posX, posY - (radius * 2), posX + 6, posY - (radius * 2) + 3);
            dc.drawLine(posX, posY - (radius * 2), posX - 6, posY - (radius * 2) + 3);
        }

        // beams
        dc.drawLine(posX - 7, posY - radius - 1, posX - radius - 2, posY - radius - 3);
        dc.drawLine(posX + 7, posY - radius - 1, posX + radius + 2, posY - radius - 3);
        dc.drawLine(posX - 10, posY - radius + 4, posX - radius - 5, posY - radius + 2);
        dc.drawLine(posX + 10, posY - radius + 4, posX + radius + 5, posY - radius + 2);

        // hide second half of sun
        dc.setColor(bgColor, frColor);
        dc.fillRectangle(posX - radius - 1, posY + penWidth, (radius * 2) + (penWidth * 2), radius);
        */
    }


    // Draw steps info
    function drawSteps(posX, posY, dc, position) {
        if (position == 1) {
            posX -= 10;
            posY -= (is240dev ? 18 : 16);
        }
        if (position == 2) {
            posX -= (is240dev ? 6 : 4);
        }
        if (position == 3) {
            posX -= (is218dev ? 40 : 36); //(is280dev || is240dev ? 36 : 40);
        }
        if (position == 4) {
            posX -= (is240dev ? 40 : 41);
        }

        dc.setColor(themeColor, bgColor);
        dc.drawText(posX - 4, posY - 4, fntIcons, "0", Gfx.TEXT_JUSTIFY_LEFT);

        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        var info = ActivityMonitor.getInfo();
        var stepsCount = info.steps;
        if ((is218dev || is240dev) && (stepsCount > 999) && ((position == 2) || (position == 3))) {
            stepsCount = info.steps / 1000.0;           
            stepsCount = (stepsCount*10).toNumber().toFloat()/10; // truncate to 1 decimal places
            stepsCount = stepsCount.format("%.1f");
            stepsCount += (is240dev ? "k" : "");
        }
        //dc.drawText(posX + 22, posY, fntDataFields, stepsCount.toString(), Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(posX + 22, posY - dataFieldsYCentering, fntDataFields, stepsCount.toString(), Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    
    // Draw steps info
    function drawDistance(posX, posY, dc, position) {
        if (position == 1) {
            posX -= 10;
            posY -= (is240dev ? 18 : 16);
        }
        if (position == 2) {
            posX -= (is240dev ? 6 : (is280dev ? 14 : 4));
        }
        if (position == 3) {
            posX -= (is240dev ? 40 : 36);
        }
        if (position == 4) {
            posX -= (is240dev ? 40 : 41);
        }

        dc.setColor(themeColor, bgColor);
        dc.drawText(posX - 4, posY - 4, fntIcons, "7", Gfx.TEXT_JUSTIFY_LEFT);

        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        var info = ActivityMonitor.getInfo();
        var distanceKm = (info.distance / 100000).format("%.2f");
        if (is280dev || (position == 1) || (position == 4))  {
            distanceKm = distanceKm.toString() + "km";
        }
        dc.drawText(posX + 22, posY - dataFieldsYCentering, fntDataFields, distanceKm.toString(), Gfx.TEXT_JUSTIFY_LEFT);
    }


    // Draw floors info
    function drawFloors(posX, posY, dc, position) {
        if (position == 1) {
            posX += 2;
            posY = (is240dev ? posY - 18 : posY - 16);
        }
            if (position == 3) {
                posX -= 32;
        }
        if (position == 4) {
            posX = (is240dev ? (posX - 25) : (posX - 28));
        }

        dc.setColor(themeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(posX - 4, posY - 4, fntIcons, "1", Gfx.TEXT_JUSTIFY_LEFT);

        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        var info = ActivityMonitor.getInfo();
        dc.drawText(posX + 22, posY - dataFieldsYCentering, fntDataFields, info.floorsClimbed.toString(), Gfx.TEXT_JUSTIFY_LEFT);
    }


    // Draw calories per day
    function drawCalories(posX, posY, dc, position) {
        if (position == 1) {
            posX -= 2;
            posY = (is240dev ? posY - 18 : posY - 16);
        }
            if (position == 3) {
                posX = (is240dev ? (posX - 38) : (posX - 32));
        }
        if (position == 4) {
            posX = (is240dev ? (posX - 32) : (posX - 32));
        }

        dc.setColor(themeColor, Gfx.COLOR_TRANSPARENT);
        dc.drawText(posX - 2, posY - 4, fntIcons, "6", Gfx.TEXT_JUSTIFY_LEFT);

        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        var info = ActivityMonitor.getInfo();
        var caloriesCount = info.calories;
        if (is240dev && (caloriesCount > 999) && ((position == 2) || (position == 3))){
            caloriesCount = (caloriesCount / 1000.0).format("%.1f").toString() + "M";
        }
        dc.drawText(posX + 20, posY - dataFieldsYCentering, fntDataFields, caloriesCount.toString(), Gfx.TEXT_JUSTIFY_LEFT);
    }


    // Draw BT connection status
    function drawBtConnection(dc) {
        if ((settings has : phoneConnected) && (settings.phoneConnected)) {
            // var radius = 5;
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
            dc.drawText(halfWidth - 17, dc.getHeight() - Gfx.getFontHeight(Gfx.FONT_TINY) - 26, fntIcons, "8", Gfx.TEXT_JUSTIFY_LEFT);
            // dc.fillCircle((dc.getWidth() / 2) - 9, dc.getHeight() - Gfx.getFontHeight(Gfx.FONT_TINY) - (radius * 3), radius);
        }
    }


    // Draw notification alarm
    function drawNotification(dc) {
        if ((settings has : phoneConnected) && (settings.phoneConnected) && (settings has : notificationCount) && (settings.notificationCount)) {
            // var radius = 5;
            dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
            dc.drawText(halfWidth - 1, dc.getHeight() - Gfx.getFontHeight(Gfx.FONT_TINY) - 26, fntIcons, "5", Gfx.TEXT_JUSTIFY_LEFT);
            // dc.fillCircle((dc.getWidth() / 2) + 6, dc.getHeight() - Gfx.getFontHeight(Gfx.FONT_TINY) - (radius * 3), radius);
        }
    }


    // Returns formated date by settings
    function getFormatedDate() {
        var ret = "";
        if (App.getApp().getProperty("DateFormat") <= 3) {
            var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
            if (App.getApp().getProperty("DateFormat") == 1) {
                ret = Lang.format("$1$ $2$ $3$", [today.day_of_week, today.day, today.month]);
            } else if (App.getApp().getProperty("DateFormat") == 2) {
                ret = Lang.format("$1$ $2$ $3$", [today.day_of_week, today.month, today.day]);
            } else {
                ret = Lang.format("$1$ $2$", [today.day_of_week, today.day]);
            }
        } else {
            var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            ret = Lang.format("$1$ / $2$", [today.month, today.day]);
        }

        return ret;
    }


    // Draw a moon by phase
    function drawMoonPhase(xPos, yPos, dc, phase, position) {
        var radius = 9;
        if (position == 0) {
            yPos = (is280dev ? yPos + 4 : yPos + 1);
        }
        if (position == 1) {
            xPos += 22;
            yPos -= (is240dev ? 10 : (is218dev ? 8 : 6));
        }
        if (position == 2) {
            xPos += (is280dev || is218dev ? 34 : 28);
            yPos += 11;
        }
        if (position == 3) {
            xPos -= (is280dev ? 2 : (is218dev ? 25 : 12));
            yPos += 11;
        }
        if (position == 4) {
            xPos -= (is240dev ? 6 : (is218dev ? 3 : 8));
            yPos += 8;
            radius -= (is240dev || is218dev ? 1 : 0);
        }

        dc.setColor(frColor, bgColor);
        if (phase == 0) {
            dc.setPenWidth(2);
            dc.drawCircle(xPos, yPos, radius);
        } else {
            dc.fillCircle(xPos, yPos, radius);
            if (phase == 1) {
                dc.setColor(bgColor, frColor);
                dc.fillCircle(xPos - 5, yPos, radius);
                } else if (phase == 2) {
                    dc.setColor(bgColor, frColor);
                dc.fillRectangle(xPos - radius, yPos - radius, radius, (radius * 2) + 2);
                } else if (phase == 3) {
                    dc.setPenWidth(radius - 2);
                    dc.setColor(bgColor, frColor);
                    dc.drawArc(xPos + 5, yPos, radius + 5, Gfx.ARC_CLOCKWISE, 270, 90);
                } else if (phase == 5) {
                    dc.setPenWidth(radius - 2);
                    dc.setColor(bgColor, frColor);
                    dc.drawArc(xPos - 5, yPos, radius + 5, Gfx.ARC_CLOCKWISE, 90, 270);
                } else if (phase == 6) {
                    dc.setColor(bgColor, frColor);
                dc.fillRectangle(xPos + (radius / 2) - 3, yPos - radius, radius, (radius * 2) + 2);
                } else if (phase == 7) {
                    dc.setColor(bgColor, frColor);
                dc.fillCircle(xPos + 5, yPos, radius);
                }
        }
    }


    // Draw battery witch % state
    function drawBattery(xPos, yPos, dc, position, time, inDays) {
        if (position == 1) {
            xPos = (is280dev ? xPos + 33 : xPos + 32);
            yPos = (is240dev ? yPos - 18 : yPos - 16);
        }
        if (position == 2) {
            xPos = (is280dev ? xPos + 30 : xPos + 30);
        }
        if (position == 3) {
            xPos -= (is240dev ? 6 : (is218dev ? 5 : 0));
        }
        if (is280dev && (position == 4)) {
            xPos += 2;
        }
        dc.setPenWidth(1);
        var batteryPercent = System.getSystemStats().battery;
        if (batteryPercent <= 10) {
            dc.setColor(Gfx.COLOR_RED, bgColor);
        } else {
            dc.setColor(frColor, bgColor);
        }
        
        var batteryWidth = 23;
        dc.drawRectangle(xPos - 34, yPos + 4, batteryWidth, 13);    // battery
        dc.drawRectangle(xPos + batteryWidth - 34, yPos + 8, 2, 5); // battery top
        var batteryColor = Gfx.COLOR_GREEN;
        if (batteryPercent <= 10) {
            batteryColor = Gfx.COLOR_RED;
        } else if (batteryPercent <= 35) {
            batteryColor = Gfx.COLOR_ORANGE;
        }

        dc.setColor(batteryColor, bgColor);
        var batteryState = ((batteryPercent / 10) * 2).toNumber();
        dc.fillRectangle(xPos + 1 - 34, yPos + 5, batteryState + 1, 11);

        var batText = batteryPercent.toNumber().toString() + (is218dev ? "" : "%");
        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        if (inDays) {
            if (time.min % 10 == 0) {   // battery is calculating each ten minutes (hope in more accurate results)
                getRemainingBattery(time, batteryPercent);
            }
            batText = (app.getProperty("remainingBattery") == null ? "W8" : app.getProperty("remainingBattery").toString());
        }  
        dc.drawText(xPos + 29 - 34, yPos - dataFieldsYCentering, fntDataFields, batText, Gfx.TEXT_JUSTIFY_LEFT);  
    }
    
    
    // set variable named remainingBattery to remaining battery in days / hours
    function getRemainingBattery(time, batteryPercent) { 
        if (System.getSystemStats().charging) {         // if charging
            app.setProperty("batteryTime", null);
            app.setProperty("remainingBattery", "W8");  // will show up "wait" sign
        } else {
            var bat = app.getProperty("batteryTime");
            if (bat == null) {
                bat = [time.now().value(), batteryPercent];
                app.setProperty("batteryTime", bat);
                app.setProperty("remainingBattery", "W8");    // still waiting for battery
            } else {
                var nowValue = time.now().value(); 
                if ((batteryPercent + .5) > 100) {
                    bat = [time.now().value(), batteryPercent];
                    app.setProperty("batteryTime", bat);
                    app.setProperty("remainingBattery", "W8");  // will show up "wait" sign     
                } else if (bat[1] > batteryPercent) {
                    var remaining = (bat[1] - batteryPercent).toFloat() / (nowValue - bat[0]).toFloat();
                    remaining = remaining * 60 * 60;    // percent consumption per hour
                    remaining = batteryPercent.toFloat() / remaining;
                    if (remaining > 48) { 
                        remaining = Math.round(remaining / 24).toNumber() + "d";
                    } else {
                        remaining = Math.round(remaining).toNumber() + "h";
                    }
                    app.setProperty("remainingBattery", remaining);
                } 
            }
        }
    }


    // draw altitude
    function drawAltitude(xPos, yPos, dc, position) {
        if (position == 1) {
            xPos = (is240dev ? xPos + 32 : xPos + 34);
            yPos = (is240dev ? yPos - 18 : yPos - 16);
        }
        if (position == 2) {
            xPos = ((is240dev || is280dev) ? xPos + 42 : xPos + 40);
        }
        if (position == 3) {
            xPos += 8;
        }
        if ((position == 4 ) && is218dev) {
            xPos += 8;
        } 

        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        var alt = getAltitude();
        if (is280dev || (position == 1) || (position == 4)) {
            alt = alt[:altitude] + alt[:unit];
        } else {
            alt = alt[:altitude];
        }
        dc.drawText(xPos - 18, yPos - dataFieldsYCentering, fntDataFields, alt, Gfx.TEXT_JUSTIFY_LEFT);
        //dc.drawText(xPos - 18, yPos, fntDataFields, alt, Gfx.TEXT_JUSTIFY_LEFT);

        // coordinates correction text to mountain picture
        xPos = xPos - 46;
        yPos = yPos + 2;
        dc.setPenWidth(2);

        dc.setColor(themeColor, bgColor);
        dc.drawText(xPos, yPos - 6, fntIcons, ";", Gfx.TEXT_JUSTIFY_LEFT);

        /*dc.setColor(themeColor, bgColor);
        dc.drawLine(xPos + 1, yPos + 14, xPos + 5, yPos + 7);
        dc.drawLine(xPos + 5, yPos + 7, xPos + 7, yPos + 10);
        dc.drawLine(xPos + 7, yPos + 10, xPos + 11, yPos + 2);
        dc.drawLine(xPos + 11, yPos + 2, xPos + 20, yPos + 15); */
    }

    // Draw the pressure state and current pressure
    function drawPressure(xPos, yPos, dc, pressure, today, position) {
        if (position == 1) {
            xPos += 30;
            yPos = (is240dev ? yPos - 18 : yPos - 16);
        }
        if (position == 2) {
            xPos += (is218dev ? 28 : 30);
        }
        if (position == 3) {
            xPos -= (is240dev ? 4 : (is218dev ? 8 : 0));
        }
        var lastPressureLoggingTime = (app.getProperty("lastPressureLoggingTime") == null ? null : app.getProperty("lastPressureLoggingTime").toNumber());
        if ((today.min == 0) && (today.hour != lastPressureLoggingTime)) {   // grap is redrawning only in whole hour
            var baroFigure = 0;
            var targetPeriod = App.getApp().getProperty("PressureGraphPeriod");
            var pressure3 = app.getProperty(PRESSURE_ARRAY_KEY + targetPeriod.toString());  // last saved value for current setting
            var pressure2 = app.getProperty(PRESSURE_ARRAY_KEY + (targetPeriod / 2).toString());    // middle period for current setting
            var pressure1 = app.getProperty("pressure0");   // always need a current value which is saved on position 0
            var PRESSURE_GRAPH_BORDER = App.getApp().getProperty("PressureGraphBorder");    // pressure border to change the graph in hPa
            if (pressure1 != null) {    // always should have at least pressure1 but test it for sure
                pressure1 = pressure1.toNumber();
                pressure2 = (pressure2 == null ? pressure1 : pressure2.toNumber()); // if still dont have historical data, use the current data
                pressure3 = (pressure3 == null ? pressure1 : pressure3.toNumber());
                if ((pressure3 - pressure2).abs() < PRESSURE_GRAPH_BORDER) {    // baroFigure 1 OR 2
                    if ((pressure2 > pressure1) && ((pressure2 - pressure1) >= PRESSURE_GRAPH_BORDER)) {    // baroFigure 1
                        baroFigure = 1;
                    }
                    if ((pressure1 > pressure2) && ((pressure1 - pressure2) >= PRESSURE_GRAPH_BORDER)) {    // baroFigure 2
                        baroFigure = 2;
                    }
                }
                if ((pressure3 > pressure2) && ((pressure3 - pressure2) >= PRESSURE_GRAPH_BORDER)) {    // baroFigure 3, 4, 5
                    baroFigure = 4;
                    if ((pressure2 > pressure1) && ((pressure2 - pressure1) >= PRESSURE_GRAPH_BORDER)) {    // baroFigure 3
                        baroFigure = 3;
                    }
                    if ((pressure1 > pressure2) && ((pressure1 - pressure2) >= PRESSURE_GRAPH_BORDER)) {    // baroFigure 5
                        baroFigure = 5;
                    }
                }
                if ((pressure2 > pressure3) && ((pressure2 - pressure3) >= PRESSURE_GRAPH_BORDER)) {    // baroFigure 6, 7, 8
                    baroFigure = 7;
                    if ((pressure2 > pressure1) && ((pressure2 - pressure1) >= PRESSURE_GRAPH_BORDER)) {    // FIGIRE 6
                        baroFigure = 6;
                    }
                    if ((pressure1 > pressure2) && ((pressure1 - pressure2) >= PRESSURE_GRAPH_BORDER)) {    // baroFigure 8
                        baroFigure = 8;
                    }
                }
            }
            app.setProperty("lastPressureLoggingTime", today.hour);
            app.setProperty("baroFigure", baroFigure);
        }        
        
        var baroFigure = (app.getProperty("baroFigure") == null ? 0 : app.getProperty("baroFigure").toNumber());
        drawPressureGraph(xPos - 34, yPos + 10, dc, baroFigure);
        dc.setColor(frColor, Gfx.COLOR_TRANSPARENT);
        
        // convert hPa to Mg
        if (App.getApp().getProperty("PressureUnit").toNumber() == 1) {
            if (is218dev && ((position == 2) || (position == 3))) {
                pressure = Math.round(0.02953 * pressure.toFloat()).format("%.1f");
            } else {
                pressure = Math.round(0.02953 * pressure.toFloat()).format("%.2f");
            }
        } else if ((App.getApp().getProperty("PressureUnit").toNumber() == 2) && (activityInfo has :ambientPressure)) {
            pressure = activityInfo.ambientPressure == null ? 0 : (activityInfo.ambientPressure / 100).toNumber();
        }
        xPos -= (is218dev && ((position == 2) || (position == 3))) ? 8 : 6;
        dc.drawText(xPos, yPos - dataFieldsYCentering, fntDataFields, pressure.toString(), Gfx.TEXT_JUSTIFY_LEFT);
    }

    // Draw small pressure graph based on baroFigure
    // 0 - no change during last 8 hours - change don`t hit the PRESSURE_GRAPH_BORDER --
    // 1 - the same first 4 hours, then down -\
    // 2 - the same first 4 hours, then up -/
    // 3 - still down \
    // 4 - going down first 4 hours, then the same \_
    // 5 - going down first 4 house, then up \/
    // 6 - going up for first 4 hours, then down /\
    // 7 - going up for first 4 hours, then the same /-
    // 8 - stil going up /
    function drawPressureGraph(xPos, yPos, dc, figure) {
        dc.setPenWidth(3);
        dc.setColor(themeColor, bgColor);
        switch (figure) {
            case 0:
                dc.drawLine(xPos, yPos, xPos + 22, yPos);
            break;

            case 1:
                dc.drawLine(xPos, yPos, xPos + 11, yPos);
                dc.drawLine(xPos + 11, yPos, xPos + 22, yPos + 9);
            break;

            case 2:
                dc.drawLine(xPos, yPos, xPos + 11, yPos);
                dc.drawLine(xPos + 11, yPos, xPos + 22, yPos - 9);
            break;

            case 3:
                dc.drawLine(xPos, yPos - 9, xPos + 22, yPos + 9);
            break;

            case 4:
                dc.drawLine(xPos, yPos - 9, xPos + 11, yPos);
                dc.drawLine(xPos + 11, yPos, xPos + 22, yPos);
            break;

            case 5:
                dc.drawLine(xPos, yPos - 9, xPos + 11, yPos);
                dc.drawLine(xPos + 11, yPos, xPos + 22, yPos - 9);
            break;

            case 6:
                dc.drawLine(xPos, yPos + 9, xPos + 11, yPos);
                dc.drawLine(xPos + 11, yPos, xPos + 22, yPos + 9);
            break;

            case 7:
                dc.drawLine(xPos, yPos + 9, xPos + 11, yPos);
                dc.drawLine(xPos + 11, yPos, xPos + 22, yPos);
            break;

            case 8:
                dc.drawLine(xPos, yPos + 9, xPos + 22, yPos - 9);
            break;
        }
    }

    // Return a formatted time dictionary that respects is24Hour settings.
    // - hour: 0-23.
    // - min:  0-59.
    function getFormattedTime(hour, min) {
        var amPm = "";
        var amPmFull = "";
        var isMilitary = false;
        var timeFormat = "$1$:$2$";

        if (!System.getDeviceSettings().is24Hour) {
            // #6 Ensure noon is shown as PM.
            var isPm = (hour >= 12);
            if (isPm) {
                // But ensure noon is shown as 12, not 00.
                if (hour > 12) {
                    hour = hour - 12;
                }
                amPm = "p";
                amPmFull = "PM";
            } else {
                // #27 Ensure midnight is shown as 12, not 00.
                if (hour == 0) {
                    hour = 12;
                }
                amPm = "a";
                amPmFull = "AM";
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                isMilitary = true;
                timeFormat = "$1$$2$";
                hour = hour.format("%02d");
            }
        }

        return {
            :hour => hour,
            :min => min.format("%02d"),
            :amPm => amPm,
            :amPmFull => amPmFull,
            :isMilitary => isMilitary,
            :formatted => Lang.format(timeFormat, [hour, min.format("%02d")])
        };
    }

    // Return one of 8 moon phase by date
    // Trying to cache for better optimalization, becase calculation is needed once per day (date)
    // 0 => New Moon
    // 1 => Waxing Crescent Moon
    // 2 => Quarter Moon
    // 3 => Waning Gibbous Moon
    // 4 => Full Moon
    // 5 => Waxing Gibbous Moon
    // 6 => Last Quarter Moon
    // 7 => Waning Crescent Moon
    function getMoonPhase(today) {
        if ((moonPhase == null) || ((today.hour == 0) && (today.min == 0))) {
            var year = today.year;
            var month = today.month;
            var day = today.day;
            var c = 0;
            var e = 0;
            var jd = 0;
            var b = 0;

            if (month < 3) {
                year--;
                month += 12;
            }

            ++month;
            c = 365.25 * year;
            e = 30.6 * month;
            jd = c + e + day - 694039.09; //jd is total days elapsed
            jd /= 29.5305882; //divide by the moon cycle
            b = jd.toNumber(); //int(jd) -> b, take integer part of jd
            jd -= b; //subtract integer part to leave fractional part of original jd
            b = Math.round(jd * 8).abs(); //scale fraction from 0-8 and round
            if (b >= 8 ) {
                b = 0; //0 and 8 are the same so turn 8 into 0
            }
            moonPhase = b;
        }

        return moonPhase;
    }

    // Returns altitude info with units
    function getAltitude() {
        // Note that Activity::Info.altitude is supported by CIQ 1.x, but elevation history only on select CIQ 2.x
        // devices.
        var unit = "";
        var sample;
        var value = "";
        var altitude = activityInfo.altitude;
        if ((altitude == null) && (Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
            sample = SensorHistory.getElevationHistory({ :period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST })
                .next();
            if ((sample != null) && (sample.data != null)) {
                altitude = sample.data;
            }
        }
        if (altitude != null) {
            // Metres (no conversion necessary).
            if (settings.elevationUnits == System.UNIT_METRIC) {
                unit = "m";
            // Feet.
            } else {
                altitude *= /* FT_PER_M */ 3.28084;
                unit = "ft";
            }
            value = altitude.format("%d");
        }

        return {
            :altitude => value,
            :unit => unit
        };
    }

    // Returns pressure in hPa
    function getPressure() {
        var pressure = null;
        var value = 0;  // because of some watches not have barometric sensor
        // Avoid using ActivityInfo.ambientPressure, as this bypasses any manual pressure calibration e.g. on Fenix
        // 5. Pressure is unlikely to change frequently, so there isn't the same concern with getting a "live" value,
        // compared with HR. Use SensorHistory only.
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
            var sample = Toybox.SensorHistory.getPressureHistory({}).next();
            if ((sample != null) && (sample.data != null)) {
                pressure = sample.data;
            }
        }

        if (pressure != null) {
            pressure = pressure / 100; // Pa --> hPa;
            value = pressure.format("%.0f"); // + "hPa";
        }

        return value;
    }

    // Each hour is the pressure saved (durring last 8 hours) for creation a simple graph
    // storing 8 variables but working just with 4 right now (8,4.1)
    function handlePressureHistorty(pressureValue) {
        var graphPeriod = App.getApp().getProperty("PressureGraphPeriod");
        var pressures = []; 
        // var pressures = ["pressure0" ....  "pressure8"];
        for(var period = 0; period <= graphPeriod; period+=1) {
            pressures.add(PRESSURE_ARRAY_KEY + period.toString());
        }

        var preindex = -1;
        for(var pressure = pressures.size(); pressure > 1; pressure-=1) {
            preindex = pressure - 2;
            if (preindex >= 0) {
                if (app.getProperty(pressures[preindex]) == null) {
                    app.setProperty(pressures[preindex], pressureValue);
                }
                app.setProperty(pressures[pressure - 1], app.getProperty(pressures[preindex]));             
            }
        }
        app.setProperty("pressure0", pressureValue);
    }

    function handleSolarIntensityHistory(solarIntensityValue) {
        var solars = [];

        // var solars = ["solar0" ....  "solar6"];
        // var solarMock = [20, 45, 30, 80, 0, 100, 90, 67]; MOCK
        for(var period = 0; period <= 6; period+=1) {
            solars.add(SOLAR_INTENSITY_ARRAY_KEY + period.toString());
        }

        var preindex = -1;
        for(var solar = solars.size(); solar > 1; solar-=1) {
            preindex = solar - 2;
            if (preindex >= 0) {
                if (app.getProperty(solars[preindex]) == null) {
                    app.setProperty(solars[preindex], solarIntensityValue);
                    //app.setProperty(solars[preindex], solarMock[solar]); MOCK
                }
                app.setProperty(solars[solar - 1], app.getProperty(solars[preindex]));             
                //app.setProperty(solars[solar - 1], solarMock[preindex]);    MOCK     
            }
        }
        app.setProperty(SOLAR_INTENSITY_ARRAY_KEY + "0", solarIntensityValue);
    }


    // Draw filled pointer like a trinagle to dial by the settings
    function drawPointToDialFilled(dc, color, timeInfo) {
        var angleToNrCorrection = 5.99;
        var daylightProgessWidth = App.getApp().getProperty("DaylightProgessWidth");
        var rLocal = halfWidth - daylightProgessWidth + 2;  // line in day light
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);

        var secondTimeCoef = ((timeInfo.hour + (timeInfo.min.toFloat() / 60) + angleToNrCorrection + (useBezelAsDial ? 180 :0)) * 15);
        // the top  point touching the DaylightProgessWidth
        var angleDeg = (secondTimeCoef * Math.PI) / 180;
        var trianglPointX1 = ((rLocal * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY1 = ((rLocal * Math.sin(angleDeg)) + halfWidth);
        
        var secondTimeTriangleCircle = halfWidth - (daylightProgessWidth + App.getApp().getProperty("CurrentTimePointerWidth"));
        // one of the lower point of tringle        
        var trianglePointAngle = secondTimeCoef - 4;
        angleDeg = (trianglePointAngle * Math.PI) / 180;
        var trianglPointX2 = ((secondTimeTriangleCircle * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY2 = ((secondTimeTriangleCircle * Math.sin(angleDeg)) + halfWidth);
        
        // one of the higher point of tringle
        trianglePointAngle = secondTimeCoef + 4;
        angleDeg = (trianglePointAngle * Math.PI) / 180;
        var trianglPointX3 = ((secondTimeTriangleCircle * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY3 = ((secondTimeTriangleCircle * Math.sin(angleDeg)) + halfWidth);
        
        dc.fillPolygon([[trianglPointX1, trianglPointY1], [trianglPointX2, trianglPointY2], [trianglPointX3, trianglPointY3]]); 
    }
    
    // Draw filled pointer like a trinagle to dial by the settings
    function drawPointToDialTransparent(dc, color, timeInfo) {
        var angleToNrCorrection = 5.99;
        var daylightProgessWidth = App.getApp().getProperty("DaylightProgessWidth");
        var rLocal = halfWidth - daylightProgessWidth + 2;  // line in day light
        dc.setPenWidth(2);
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);

        var secondTimeCoef = ((timeInfo.hour + (timeInfo.min.toFloat() / 60) + angleToNrCorrection + (useBezelAsDial ? 180 : 0)) * 15);
        // the top  point touching the DaylightProgessWidth
        var angleDeg = (secondTimeCoef * Math.PI) / 180;
        var trianglPointX1 = ((rLocal * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY1 = ((rLocal * Math.sin(angleDeg)) + halfWidth);
        
        var secondTimeTriangleCircle = halfWidth - (daylightProgessWidth + App.getApp().getProperty("CurrentTimePointerWidth"));
        // one of the lower point of tringle        
        var trianglePointAngle = secondTimeCoef - 4;
        angleDeg = (trianglePointAngle * Math.PI) / 180;
        var trianglPointX2 = ((secondTimeTriangleCircle * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY2 = ((secondTimeTriangleCircle * Math.sin(angleDeg)) + halfWidth);
        
        // one of the higher point of tringle
        trianglePointAngle = secondTimeCoef + 4;
        angleDeg = (trianglePointAngle * Math.PI) / 180;
        var trianglPointX3 = ((secondTimeTriangleCircle * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY3 = ((secondTimeTriangleCircle * Math.sin(angleDeg)) + halfWidth);
        
        dc.drawLine(trianglPointX1, trianglPointY1, trianglPointX2, trianglPointY2);
        dc.drawLine(trianglPointX2, trianglPointY2, trianglPointX3, trianglPointY3);
        dc.drawLine(trianglPointX3, trianglPointY3, trianglPointX1, trianglPointY1);
    }
    
    // Draw pointer like a Suunto pointer to dial by the settings
    function drawSuuntoLikePointer(dc, color, timeInfo) {
        var angleToNrCorrection = 5.95;
        var daylightProgessWidth = (App.getApp().getProperty("DaylightProgessWidth") / 2).toNumber();
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        
        dc.setPenWidth(daylightProgessWidth);
        var secondTimeCoef = ((timeInfo.hour + (timeInfo.min.toFloat() / 60)) * 15);
        var secondTimeStart = 272 - secondTimeCoef + (useBezelAsDial ? 180 : 0); // 270 was corrected better placing of second time holder
        var secondTimeEnd = 268 - secondTimeCoef + (useBezelAsDial ? 180 : 0);   // 270 was corrected better placing of second time holder       
        dc.drawArc(halfWidth, halfWidth, halfWidth, Gfx.ARC_CLOCKWISE, secondTimeStart, secondTimeEnd);
        
        // the top  point touching the DaylightProgessWidth
        var secondTimeTriangleCircle = halfWidth - (daylightProgessWidth + App.getApp().getProperty("CurrentTimePointerWidth"));
        secondTimeCoef = ((timeInfo.hour + (timeInfo.min.toFloat() / 60) + angleToNrCorrection + (useBezelAsDial ? 180 : 0)) * 15);
        var angleDeg = (secondTimeCoef * Math.PI) / 180;
        var trianglPointX1 = ((secondTimeTriangleCircle * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY1 = ((secondTimeTriangleCircle * Math.sin(angleDeg)) + halfWidth);
        
        // one of the lower point of tringle        
        var trianglePointAngle = secondTimeCoef - 3;
        angleDeg = (trianglePointAngle * Math.PI) / 180;
        var trianglPointX2 = ((halfWidth * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY2 = ((halfWidth * Math.sin(angleDeg)) + halfWidth);
        
        // one of the higher point of tringle
        trianglePointAngle = secondTimeCoef + 3;
        angleDeg = (trianglePointAngle * Math.PI) / 180;
        var trianglPointX3 = ((halfWidth * Math.cos(angleDeg)) + halfWidth);
        var trianglPointY3 = ((halfWidth * Math.sin(angleDeg)) + halfWidth);
        
        dc.fillPolygon([[trianglPointX1, trianglPointY1], [trianglPointX2, trianglPointY2], [trianglPointX3, trianglPointY3]]); 
    }   
}
