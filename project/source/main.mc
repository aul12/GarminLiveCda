using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Sensor;

class CdaView extends WatchUi.SimpleDataField
{
    private var cdaCalc = new CdaCalc();
    private var temperature = 20+273;

    function submitTemp(temp) {
        temperature = temp;
    }

    function compute(info) {
        var time = 0;
        if (info has :timerTime && info.timerTime != null) {
            time = info.timerTime / 1000;
        } else {
            System.println("Time missing");
        }

        var power = 0;
        if (info has :currentPower && info.currentPower != null) {
            power = info.currentPower;
        } else {
            System.println("Power missing");
        }

        var altitude = 0;
        if (info has :altitude && info.altitude != null) {
            altitude = info.altitude;
        } else {
            System.println("Altitude missing");
        }

        var speed = 0; 
        if (info has :currentSpeed && info.currentSpeed != null) {
            speed = info.currentSpeed;
        } else {
            System.println("Speed missing");
        }

        var distance = 0;
        if (info has :elapsedDistance && info.elapsedDistance != null) {
            distance = info.elapsedDistance; 
        } else {
            System.println("Distance missing");
        }

        var pressure = 101325;
        if (info has :ambientPressure && info.ambientPressure != null) {
            pressure = info.ambientPressure;
        } else {
            System.println("Pressure missing");
        }

        return cdaCalc.update(time, power, altitude, speed, distance, pressure, temperature);
    }
}

class Main extends Application.AppBase
{
    private var cdaView = new CdaView();

    function getInitialView() {
        System.println( "getInitialView()" );

        return [cdaView];
    }
}
