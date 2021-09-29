/*
Idea: EKF

State vector:
    x = [speed, acc, altitude, gradient]

Prediction model:
    speed^+ = speed + acc *dt
    acc^+ = acc
    altitude^+ = altitude + (speed * dt + 0.5 * acc * dt^2) * gradient
    gradient^+ = gradient

Linearized dynamic
    A = [1, dt, 0, 0;
         0,  1, 0, 0;
         dt*gradient, 0.5*dt^2*gradient, 1, speed * dt + 0.5 * acc * dt^2;
         0, 0, 0, 1]

Speed and Altitude can be measured:
    C = [1, 0, 0, 0;
         0, 0, 1, 0]
 */


using Toybox.System;


class SpeedAltitudeFilter {
    private var x, P;
    private var A, C;
    private var Q, R;

    private var accProcessNoise, gradientProcessNoise;

    function initialize(accProcessNoise, gradientProcessNoise, speedMeasNoise, altMeasNoise) {
        A = new Matrix(4, 4);
        C = new Matrix(2, 4);
        C.setVals([1, 0, 0, 0,
                   0, 0, 1, 0]);
        
        Q = new Matrix(4, 4);
        R = new Matrix(2, 2);

        R.setVals([
            speedMeasNoise, 0,
            0, altMeasNoise
        ]);

        self.accProcessNoise = accProcessNoise;
        self.gradientProcessNoise = gradientProcessNoise;
    }

    function update(measSpeed, measAltitude, dt) {
        if (x == null) {
            x = new Matrix(4, 1);
            x.setVals([measSpeed, 0, measAltitude, 0]);
        }
        if (P == null) {
            P = new Matrix(4, 4);
            //@TODO init?
        }

        var speed = x.at(0, 0);
        var acc = x.at(1, 0);
        var altitude = x.at(2, 0);
        var gradient = x.at(3, 0);
        
        A.setVals([
            1, dt, 0, 0,
            0,  1, 0, 0,
            dt*gradient, 0.5*dt*dt*gradient, 1, speed * dt + 0.5 * acc * dt*dt,
            0, 0, 0, 1
        ]);

        Q.setVals([
            0.5 * dt * dt * accProcessNoise, dt * accProcessNoise, 0, 0,
            dt * accProcessNoise, accProcessNoise, 0, 0,
            0, 0, 0.5 * dt * dt * gradientProcessNoise, dt * gradientProcessNoise,
            0, 0, dt * gradientProcessNoise, gradientProcessNoise
        ]);

        var z = new Matrix(2, 1);
        z.setVals([measSpeed, measAltitude]);

        // Prediction
        x.setVals([
            speed + acc *dt,
            acc,
            altitude + (speed * dt + 0.5 * acc * dt*dt) * gradient,
            gradient
        ]);
        P = add(mm(mm(A, P), A.transposed()), Q);

        var z_hat = mm(C, x);
        var S = add(mm(mm(C, P), C.transposed()), R);

        var K = mm(mm(P, C.transposed()), S.inverse());

        // Innovation
        var tilde_z = add(z, z_hat.scaled(-1));
        x = add(x, mm(K, tilde_z));
        P = add(P, mm(K, mm(S, K.transposed())).scaled(-1));

        //System.println("z=["+z.at(0,0)+", "+z.at(1, 0)+"]");
        //System.println("x=["+x.at(0, 0)+", "+x.at(1, 0)+", "+x.at(2, 0)+", "+x.at(3, 0)+"]");
    }

    function getSpeed() {
        return x.at(0, 0);
    }

    function getAltitude() {
        return x.at(2, 0);
    }
}
