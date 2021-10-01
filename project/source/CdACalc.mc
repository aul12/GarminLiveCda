using Toybox.System;

class CdACalc {
    private var lastTime = null;
    private var lastAltitude = null;
    private var lastGroundSpeed = null;
    private var lastDistance = null;

    private const G = 9.81;
    private var M;
    private var CRR;
    private const R_specific = 287.058; // https://en.wikipedia.org/wiki/Density_of_air

    private var speedAltitudeFilter = new SpeedAltitudeFilter(0.0001, 0.00005, 1, 1);
    private var cdAFilter = new ExponentialSmoothing(0.9);

    function initialize(CRR, M) {
        self.CRR = CRR;
        self.M = M;
    }

    function update(time, power, altitude, groundSpeed, airSpeed, distance, pressure, temperature) {
        if (lastTime == null) {
            lastTime = time;
            lastAltitude = altitude;
            lastGroundSpeed = groundSpeed;
            lastDistance = distance;
        }

        var dt = time - lastTime;
        if (dt <= 0) {
            return null;
        }

        speedAltitudeFilter.update(groundSpeed, altitude, dt);
        groundSpeed = speedAltitudeFilter.getSpeed();
        altitude = speedAltitudeFilter.getAltitude();

        var energyIn = power * dt;
        var potentialEnergy = M * G * (altitude - lastAltitude);
        var kineticEnergy = 0.5 * M * (groundSpeed * groundSpeed - lastGroundSpeed * lastGroundSpeed);
        var dDistance = distance - lastDistance;
        var rollForce = CRR * M * G;
        var rollLossEnergy = dDistance * rollForce;
        var dragEnergy = energyIn - potentialEnergy - kineticEnergy - rollLossEnergy;

        //System.println("Energy in: " + energyIn + " (power = " + power + ")");
        //System.println("Potential in: " + potentialEnergy + " (deltaAltitude=" + (altitude-lastAltitude) + ")");
        //System.println("Kinetic in: " + kineticEnergy + " (deltaSpeed=" + (speed - lastSpeed) + ")");
        //System.println("Roll loss: " + rollLossEnergy);

        if (groundSpeed != 0 && dDistance != 0) {
            var dragForce = dragEnergy / dDistance;
            var rho_air = pressure / (R_specific * temperature);
            var cdA = 2 * dragForce / (rho_air * airSpeed * airSpeed);
            System.println("CdA: " + cdA);
            if (cdA > 0) {
                cdAFilter.update(cdA);
            } else {
                System.println("CdA negative, ignoring!");
            }
        } else {
            System.println("Skipping calculations as standing");
        }


        lastTime = time;
        lastAltitude = altitude;
        lastGroundSpeed = groundSpeed;
        lastDistance = distance;

        return cdAFilter.get();
    }
}
