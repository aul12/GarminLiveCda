using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.FitContributor;


class LiveCdaView extends WatchUi.SimpleDataField
{
    private var cdaCalc;
    private var env = new EnvironmentCollector();
    var cdaField = null;

    function initialize() {
        SimpleDataField.initialize();
        self.label = "Cda";

        cdaField = createField(
            self.label,
            0,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"m^2"}
        );

        var app = Application.getApp();
        cdaCalc = new CdaCalc(app.getProperty("crr"), app.getProperty("mass"));
    }

    function compute(info) {
        env.update(info);
        
        var cda = null;
        if (env.ready()) {
            cda = cdaCalc.update(env.getTime(), 
                                    env.getPower(),
                                    env.getAltitude(),
                                    env.getGroundSpeed(),
                                    env.getRelativeSpeed(),
                                    env.getDistance(),
                                    env.getPressure(),
                                    env.getTemperature());
        }

        if (cda != null) {
            cdaField.setData(cda);
            return cda;
        }

        return "---";
    }
}

class Main extends Application.AppBase
{
    function initialize() {
        var app = Application.getApp();
        //app.setProperty("crr",  0.002845);
        //app.setProperty("mass",  60+10);

    }
    function getInitialView() {
        return [new LiveCdaView()];
    }
}
