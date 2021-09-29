using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.FitContributor;


class LiveCdaView extends WatchUi.SimpleDataField
{
    private var cdaCalc = new CdaCalc();
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
    function getInitialView() {
        return [new LiveCdaView()];
    }
}
