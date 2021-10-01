using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.FitContributor;


class LiveCdAView extends WatchUi.SimpleDataField
{
    private var cdACalc;
    private var env = new EnvironmentCollector();
    private var cdAAverager = new Averager();
    var liveCdAField, averageCdAField = null;

    function initialize() {
        SimpleDataField.initialize();
        self.label = "CdA";

        liveCdAField = createField(
            "CdA",
            0,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_RECORD, :units=>"m^2"}
        );

        averageCdAField = createField(
            "Lap CdA",
            1,
            FitContributor.DATA_TYPE_FLOAT,
            {:mesgType=>FitContributor.MESG_TYPE_LAP, :units=>"m^2"}
        );

        var app = Application.getApp();
        cdACalc = new CdACalc(app.getProperty("CRR"), app.getProperty("MASS"));
    }

    function compute(info) {
        env.update(info);
        
        var cdA = null;
        if (env.ready()) {
            cdA = cdACalc.update(env.getTime(), 
                                    env.getPower(),
                                    env.getAltitude(),
                                    env.getGroundSpeed(),
                                    env.getRelativeSpeed(),
                                    env.getDistance(),
                                    env.getPressure(),
                                    env.getTemperature());
        }

        if (cdA != null) {
            cdAAverager.update(cdA);

            liveCdAField.setData(cdA);
            averageCdAField.setData(cdA);
            return cdA;
        }

        return "---";
    }

    function onTimerLap() {
        cdAAverager.reset();
    }
}

class Main extends Application.AppBase
{
    function getInitialView() {
        return [new LiveCdAView()];
    }
}
