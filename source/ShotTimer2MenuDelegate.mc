import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class ShotTimer2MenuDelegate extends WatchUi.Menu2InputDelegate {

    private var _menu as WatchUi.Menu2;
    private var _timerState as IntervalTimer;

    function initialize(menu as WatchUi.Menu2, timerState as IntervalTimer) {
        _timerState = timerState;
        _menu = menu;
        Menu2InputDelegate.initialize();
    }


    function onSelect(item as WatchUi.MenuItem) as Void
    {
        if (item.getId() == :start_delay or item.getId() == :interval_duration)
        {
            var view = new ShotTimer2SetSelectedTimerView(_timerState, item.getId() as Symbol);
            var delegate = new ShotTimer2SetSelectedTimerBehaviorDelegate(view);

            WatchUi.pushView(view, delegate, WatchUi.SLIDE_UP);
        }
        else if (item.getId() == :start_selector)
        {
            WatchUi.pushView(new ShotTimer2ActiveTimerView(_timerState), null, WatchUi.SLIDE_UP);
        }
    }

}