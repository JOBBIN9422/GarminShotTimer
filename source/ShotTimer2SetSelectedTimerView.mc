import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class ShotTimer2SetSelectedTimerView extends WatchUi.View {

    private static enum DigitSelection
    {
        DIGIT_SECONDS,
        DIGIT_TENTHS
    }

    private var _font as FontResource?;

    private var _timerState as IntervalTimer;
    private var _selectedTimerId as Symbol;

    private var _selectedDigit as DigitSelection = DIGIT_SECONDS;
    private var _exitRequested as Boolean = false;

    function initialize(timerState as IntervalTimer, selectedTimerId as Symbol) {
        _timerState = timerState;
        _selectedTimerId = selectedTimerId;

        System.println("entering ShotTimer2SetSelectedTimerView with timerId: " + _selectedTimerId.toString());

        View.initialize();
    }

    function increment() as Void
    {
        if (_selectedTimerId == :start_delay)
        {
            var val = _timerState.getDelayDuration();
            if (_selectedDigit == DIGIT_SECONDS)
            {
                val += 1.0;
            }
            else if (_selectedDigit == DIGIT_TENTHS)
            {
                val += 0.1;
            }
            _timerState.setDelayDuration(val);
        }
        else if (_selectedTimerId == :interval_duration)
        {
            var val = _timerState.getIntervalDuration();
            if (_selectedDigit == DIGIT_SECONDS)
            {
                val += 1.0;
            }
            else if (_selectedDigit == DIGIT_TENTHS)
            {
                val += 0.1;
            }
            _timerState.setIntervalDuration(val);
        }
    }

    function decrement() as Void
    {
        if (_selectedTimerId == :start_delay)
        {
            var val = _timerState.getDelayDuration();
            if (_selectedDigit == DIGIT_SECONDS and val >= 1.0)
            {
                val -= 1.0;
            }
            else if (_selectedDigit == DIGIT_TENTHS and val >= 0.1)
            {
                val -= 0.1;
            }
            _timerState.setDelayDuration(val);
        }
        else if (_selectedTimerId == :interval_duration)
        {
            var val = _timerState.getIntervalDuration();
            if (_selectedDigit == DIGIT_SECONDS and val >= 1.0)
            {
                val -= 1.0;
            }
            else if (_selectedDigit == DIGIT_TENTHS and val >= 0.1)
            {
                val -= 0.1;
            }
            _timerState.setIntervalDuration(val);
        }
    }

    function advanceDigit() as Void
    {
        if (_selectedDigit == DIGIT_SECONDS)
        {
            _selectedDigit = DIGIT_TENTHS;
        }
        else
        {
            _exitRequested = true;
            //WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }

    function reverseDigit() as Void
    {
        if (_selectedDigit == DIGIT_TENTHS)
        {
            _selectedDigit = DIGIT_SECONDS;
        }
        else
        {
            _exitRequested = true;
            //WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.SetSelectedTimerLayout(dc));

        _font = WatchUi.loadResource($.Rez.Fonts.id_font_gameplay) as FontResource;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void
    {
        dc.clear();

        if (_exitRequested)
        {
            _exitRequested = false;
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            return;
        }

        var timerVal = 0.0;
        if (_selectedTimerId == :start_delay)
        {
            timerVal = _timerState.getDelayDuration();

        }
        else if (_selectedTimerId == :interval_duration)
        {
            timerVal = _timerState.getIntervalDuration();
        }

        Drawing.drawTimerValueWithFontAndSelector(dc, timerVal, _selectedDigit, _font);
        
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void
    {
        resetViewState();
    }

    private function resetViewState() as Void
    {
        _selectedDigit = DIGIT_SECONDS;
        _exitRequested = false;
    }

}