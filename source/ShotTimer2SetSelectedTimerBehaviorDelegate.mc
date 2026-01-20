import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;

class ShotTimer2SetSelectedTimerBehaviorDelegate extends WatchUi.BehaviorDelegate {
    private var _view as ShotTimer2SetSelectedTimerView;

    function initialize(view as ShotTimer2SetSelectedTimerView)
    {
        _view = view;
        BehaviorDelegate.initialize();
    }

    function onPreviousPage() as Boolean
    {
        System.println("ShotTimer2SetSelectedTimerInputDelegate onUp");

        // Handle the up button press
        _view.increment();
        WatchUi.requestUpdate();
        return true; 
    }

    function onNextPage() as Boolean
    {
        System.println("ShotTimer2SetSelectedTimerInputDelegate onDown");

        // Handle the down button press
        _view.decrement();
        WatchUi.requestUpdate();
        return true; 
    }

    function onBack() as Boolean
    {
        System.println("ShotTimer2SetSelectedTimerInputDelegate onBack");
        // Handle the back button press

        // return to the previous digit (or pop view if already at the first digit)
        _view.reverseDigit();
        WatchUi.requestUpdate();
        
        return true; 
    }

    function onSelect() as Boolean
    {
        System.println("ShotTimer2SetSelectedTimerInputDelegate onSelect");
        // Handle the select button press

        // advance to the next digit (or pop view if already at the last digit)
        _view.advanceDigit();
        WatchUi.requestUpdate();

        return true; 
    }
}