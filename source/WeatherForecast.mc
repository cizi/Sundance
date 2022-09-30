class WeatherForecast {

    // Artill weather icon
    // "z" - sun, fog, cloud (smoke, dust, sand, haze) = 33 = 30 = 35 = 39
    // "1" - sun (clear sky) = 0
    // "K" - heavy rain = 15 = 26
    // "O" - heavy snow  = 17 = 34
    // "Q" - heavy rain snow = 19 = 50
    // "S" - light rain snow = 18 = 7 = 21 = 44 = 47
    // "U" - heavy rain = 15
    // "W" - snow = 4 = 43 = 46 = 51
    // "A" - mostly cloudy = 2 = 22
    // "Y" - thunderstorm = 6 = 12 = 13 = 28
    // "I" - light snow = 16
    // "M" - light rain = 14 = 11 = 24 = 31
    // ":" - tornado = 32 = 41 = 42
    // "2" - partly cloudy = 1 = 23 = 40
    // "E" - sandstorm = 37 = 38
    // "C" - hazy = 9
    // "Z" - fog = 8 = 29
    // "G" - rain = 3 = 25 = 27 = 45
    // "3" - cloudy = 20 = 52
    // "*" - unknow = 53
    // "/" - volcanic ash = 38
    // "4" - two thunders (Squall) = 36
    // "," - windy = 5 = 48
    // "6" - moon (clear sky) = 54 my own code for night and clear sky
    // "5" - hail = 10 = 49
    var weatherIcons = {
        0 => "1", 
        1 => "2", 
        2 => "A", 
        3 => "G", 
        4 => "W", 
        5 => ",", 
        6 => "Y", 
        7 => "S", 
        8 => "Z", 
        9 => "C", 
        10 => "5", 
        11 => "M", 
        12 => "Y", 
        13 => "Y", 
        14 => "M", 
        15 => "K", 
        16 => "I", 
        17 => "O", 
        18 => "S", 
        19 => "Q", 
        20 => "3", 
        21 => "S", 
        22 => "A", 
        23 => "2", 
        24 => "M", 
        25 => "G", 
        26 => "K", 
        27 => "G", 
        28 => "Y", 
        29 => "Z", 
        30 => "z", 
        31 => "M", 
        32 => ":", 
        33 => "z", 
        34 => "O", 
        35 => "z", 
        36 => "4", 
        37 => "E", 
        38 => "/", 
        39 => "z", 
        40 => "2", 
        41 => ":", 
        42 => ":", 
        43 => "W", 
        44 => "S", 
        45 => "G", 
        46 => "W", 
        47 => "S", 
        48 => ",", 
        49 => "5", 
        50 => "Q", 
        51 => "W", 
        52 => "3", 
        53 => "*",
        54 => "6", 
    };

    var weatherIconsCentering = {
        3 => 4, 
        4 => 4, 
        6 => 4, 
        7 => 4, 
        8 => 4, 
        9 => 4, 
        11 => 4, 
        12 => 4, 
        13 => 4, 
        14 => 4, 
        15 => 4, 
        16 => 4, 
        17 => 4, 
        18 => 4, 
        19 => 4, 
        21 => 4, 
        24 => 4, 
        25 => 4, 
        26 => 4, 
        27 => 4, 
        28 => 4, 
        29 => 4, 
        31 => 4, 
        34 => 4, 
        36 => 4, 
        37 => 4, 
        38 => 4, 
        43 => 4, 
        44 => 4, 
        45 => 4, 
        46 => 4, 
        47 => 4, 
        50 => 4, 
        51 => 4, 
        54 => 4,
    };

    function getIconCentering(weatherCode) {
        if (weatherIconsCentering[weatherCode] != null) {
            return weatherIconsCentering[weatherCode];
        } else {
            return 0;
        }
    }

    function getIconChar(weatherCode) {
        return weatherIcons[weatherCode];
    }
}