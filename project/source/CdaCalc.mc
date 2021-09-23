using Toybox.System;

class CdaCalc {
    private var lastTime = 0;
    private var lastAltitude = 0;
    private var lastSpeed = 0;

    private const G = 9.81;
    private const M = 60;

    function initialize() {
    }

    function update(time, power, altitude, speed, distance) {
        var dt = time - lastTime;
        var energyIn = power * dt;
        var potentialEnergy = M * G * (altitude - lastAltitude);
        var kineticEnergy = 0.5 * M * speed * speed - 0.5 * M - lastSpeed * lastSpeed;
        var rollLossEnergy = distance * 0; // TODO
        var dragEnergy = energyIn - potentialEnergy - kineticEnergy - rollLossEnergy;
        var cda = 0;

        if (speed != 0 && distance != 0) {
            var dragForce = dragEnergy / distance;
            var rho_air = 1;
            cda = 2 * dragForce / (rho_air * speed * speed);
            System.println(cda);
        } else {
            System.println("Skipping calculations as standing");
        }
    


        lastTime = time;
        lastAltitude = altitude;
        lastSpeed = speed;

        return cda;
    }
}
