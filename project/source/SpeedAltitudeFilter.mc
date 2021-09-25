/*
Idea: UKF

State vector:
    x = [speed, acc, altitude, gradient]

Prediction model:
    speed^+ = speed + acc *dt
    acc^+ = acc
    altitude^+ = altitde + (speed * dt + 0.5 * acc * dt^2) * gradient
    gradient^+ = gradient

Speed and Altitude can be measured
 */


using Toybox.System;

class SpeedAltitudeFilter {
    private var speedFilter, altFilter;

    function initialize(speedWeight, altitudeWeight) {
        self.speedFilter = new ExponentialSmoothing(speedWeight);
        self.altFilter = new ExponentialSmoothing(altitudeWeight);
    }

    function update(speed, altitude) {
        speedFilter.update(speed);
        altFilter.update(altitude);
    }

    function getSpeed() {
        return speedFilter.get();
    }

    function getAltitude() {
        return altFilter.get();
    }
}
