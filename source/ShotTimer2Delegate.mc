import Toybox.Lang;
import Toybox.WatchUi;

class ShotTimer2Delegate extends WatchUi.BehaviorDelegate {


    var timerState as IntervalTimer;
    var menu as WatchUi.Menu2;

    function initialize(timerState as IntervalTimer, menu as WatchUi.Menu2) {
        self.timerState = timerState;
        self.menu = menu;

        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        // Generate a new Menu with a drawable Title


        WatchUi.pushView(menu, new ShotTimer2MenuDelegate(menu, timerState), WatchUi.SLIDE_UP);
        return true;
    }

}