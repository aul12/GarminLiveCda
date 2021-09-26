using Toybox.System;

class CdaCalc {
    private var lastTime = 0;
    private var lastAltitude = 0;
    private var lastSpeed = 0;
    private var lastDistance = 0;

    private const G = 9.81;
    private const M = 60 + 10;
    private const CRR = 0.002845;
    private const R_specific = 287.058; // https://en.wikipedia.org/wiki/Density_of_air

    private var speedAltitudeFilter = new SpeedAltitudeFilter(0.001, 0.001, 1, 1);
    private var cdaFilter = new ExponentialSmoothing(0.0);

    function initialize() {
    }

    function update(time, power, altitude, speed, distance, pressure, temperature) {
        var dt = time - lastTime;

        speedAltitudeFilter.update(speed, altitude, dt);
        speed = speedAltitudeFilter.getSpeed();
        altitude = speedAltitudeFilter.getAltitude();

        var energyIn = power * dt;
        var potentialEnergy = M * G * (altitude - lastAltitude);
        var kineticEnergy = (0.5 * M * speed * speed) - (0.5 * M * lastSpeed * lastSpeed);
        var dDistance = distance - lastDistance;
        var rollForce = CRR * M * G;
        var rollLossEnergy = dDistance * rollForce;
        var dragEnergy = energyIn - potentialEnergy - kineticEnergy - rollLossEnergy;

        //System.println("Energy in: " + energyIn + " (power = " + power + ")");
        //System.println("Potential in: " + potentialEnergy + " (deltaAltitude=" + (altitude-lastAltitude) + ")");
        //System.println("Kinetic in: " + kineticEnergy + " (deltaSpeed=" + (speed - lastSpeed) + ")");
        //System.println("Roll loss: " + rollLossEnergy);

        if (speed != 0 && dDistance != 0) {
            var dragForce = dragEnergy / dDistance;
            var rho_air = pressure / (R_specific * temperature);
            var cda = 2 * dragForce / (rho_air * speed * speed);
            System.println("cda: " + cda);
            cdaFilter.update(cda);
        } else {
            System.println("Skipping calculations as standing");
        }


        lastTime = time;
        lastAltitude = altitude;
        lastSpeed = speed;
        lastDistance = distance;

        return cdaFilter.get();
    }

    function getCda() {
        return cdaFilter.get();
    }
}
