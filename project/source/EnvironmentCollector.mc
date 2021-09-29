using Toybox.Math;

class EnvironmentCollector {
    private const P0 = 101325;

    private var temperature = 20+273;
    private var time = null;
    private var power = null;
    private var altitude = 0;
    private var groundSpeed = null;
    private var relativeSpeed = null;
    private var distance = null;
    private var pressure = P0;

    function update(info) {
        if (info has :timerTime && info.timerTime != null) {
            time = info.timerTime / 1000;
        } else {
            System.println("Time missing");
        }

        if (info has :currentPower && info.currentPower != null) {
            power = info.currentPower;
        } else {
            System.println("Power missing");
        }

        if (info has :altitude && info.altitude != null) {
            altitude = info.altitude;
        } else {
            System.println("Altitude missing");
        }

        if (info has :currentSpeed && info.currentSpeed != null) {
            groundSpeed = info.currentSpeed;
            relativeSpeed = groundSpeed;
        } else {
            System.println("Speed missing");
        }

        if (info has :elapsedDistance && info.elapsedDistance != null) {
            distance = info.elapsedDistance; 
        } else {
            System.println("Distance missing");
        }

        if (info has :ambientPressure && info.ambientPressure != null) {
            pressure = info.ambientPressure;
        } else if (info has :rawAmbientPressure && info.rawAmbientPressure != null) {
            pressure = info.rawAmbientPressure;
        } else if (altitude != null) {
            pressure = P0 * Math.pow(Math.E, -(0.02896 * 9.81 * altitude)/(8.3143 * temperature));
        } else {
            System.println("Pressure missing");
        }
    }

    function ready() {
        return time != null && power != null && groundSpeed != null && relativeSpeed != null && distance != null;
    }

    function getTemperature() {
        return temperature;
    }

    function getTime() {
        return time;
    }

    function getPower() {
        return power;
    }

    function getAltitude() {
        return altitude;
    }

    function getGroundSpeed() {
        return groundSpeed;
    }

    function getRelativeSpeed() {
        return relativeSpeed;
    }

    function getDistance() {
        return distance;
    }

    function getPressure() {
        return pressure;
    }
}