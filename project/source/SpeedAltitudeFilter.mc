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


class SpeedAltitudeFilter {
    private var lastSpeed = null;
    private var lastAlt = null;
    private var speedWeight = 0.0;
    private var altitudeWeight = 0.0;

    function initialize(speedWeight, altitudeWeight) {
        self.speedWeight = speedWeight;
        self.altitudeWeight = altitudeWeight;
    }

    function update(speed, altitude) {
        if (lastSpeed != null) {
            lastSpeed = speedWeight * lastSpeed + (1-speedWeight) * speed;
        } else {
            lastSpeed = speed;
        }
        if (lastAlt != null) {
            lastAlt = altitudeWeight * lastAlt + (1-altitudeWeight) * altitude;
        } else {
            lastAlt = altitude;
        }
    }

    function getSpeed() {
        return lastSpeed;
    }

    function getAltitude() {
        return lastAlt;
    }
}
