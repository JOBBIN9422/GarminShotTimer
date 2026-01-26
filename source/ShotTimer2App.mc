import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class ShotTimer2App extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {

        var timerState = new IntervalTimer();

        var menu = new WatchUi.Menu2({:title=>"Interval Timer"});
        menu.addItem(new WatchUi.MenuItem("Start Delay", null, :start_delay, null));
        menu.addItem(new WatchUi.MenuItem("Interval Duration", null, :interval_duration, null));
        menu.addItem(new WatchUi.MenuItem("START", null, :start_selector, null));

        var menuDelegate = new ShotTimer2MenuDelegate(menu, timerState);

        return [ menu, menuDelegate ];
    }

}

function getApp() as ShotTimer2App {
    return Application.getApp() as ShotTimer2App;
}