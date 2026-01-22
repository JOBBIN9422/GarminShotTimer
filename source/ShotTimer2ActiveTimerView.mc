import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Lang;
import Toybox.Time;

class ShotTimer2ActiveTimerView extends WatchUi.View
{
    private var _font as FontResource?;

    private var _iconBitmap as BitmapResource?;

    private var _subscrBoundingBox as Toybox.Graphics.BoundingBox?;

    private var _timerState as IntervalTimer;
    private var _timer as Timer.Timer?;

    // state flags
    private var _intervalStartAlertRequested as Boolean = false;
    private var _intervalFinishAlertRequested as Boolean = false;
    private var _exitRequested as Boolean = false;
    private var _alertTriggered as Boolean = false;

    function initialize(timerState as IntervalTimer)
    {
        _timerState = timerState;
        _timer = new Timer.Timer();
        
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void
    {
        //setLayout(Rez.Layouts.ActiveTimerLayout(dc));

        _font = WatchUi.loadResource($.Rez.Fonts.id_font_gameplay) as FontResource;

        _subscrBoundingBox = WatchUi.getSubscreen();
        _iconBitmap = WatchUi.loadResource($.Rez.Drawables.AppIcon_Inverted) as BitmapResource;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
    }
    
    function playVibeAndTone(shouldResetAlertFlag as Boolean) as Void
    {
        // allow to reset alert flag for subsequent alerts
        if (shouldResetAlertFlag)
        {
            _alertTriggered = false;
        }

        // play tone and vibrate only if alert has not already played
        if (!_alertTriggered)
        {
            _alertTriggered = true;  

            var toneData = 
            [
                new Attention.ToneProfile(2500, 500)
            ];
            var vibeData =
            [
                new Attention.VibeProfile(100, 500)
            ];
            Attention.vibrate(vibeData);
            Attention.playTone({:toneProfile=>toneData});
        }
    }


    function timerCallback() as Void
    {
        // advance timer state
        _timerState.doTimerTick(0.1);

        // if the interval timer has finished, request alert playback and exit
        if (_timerState.getCurrentState() == IntervalTimer.STATE_FINISHED)
        {
            _exitRequested = true;
            _intervalFinishAlertRequested = true;
        }
        // If the interval timer has just started, request alert playback
        else if (_timerState.justStartedIntervalTimer())
        {
            _intervalStartAlertRequested = true;
        }

        // Request the view to be redrawn
        WatchUi.requestUpdate();
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void
    {    
        _timerState.start();
        _timer.start(method(:timerCallback), 100, true);   
    }

    // Update the view
    function onUpdate(dc as Dc) as Void 
    {
        dc.clear();

        if (_subscrBoundingBox != null and _iconBitmap != null)
        {
            dc.drawBitmap(_subscrBoundingBox.x, _subscrBoundingBox.y, _iconBitmap);
        }

        // handle event flags (playback and/or exit)
        if (_intervalStartAlertRequested)
        {
            playVibeAndTone(false);
            _intervalStartAlertRequested = false;
        }
        if (_intervalFinishAlertRequested)
        {
            playVibeAndTone(true);
            _intervalFinishAlertRequested = false;
        }
        if (_exitRequested)
        {
            _exitRequested = false;
            WatchUi.popView(WatchUi.SLIDE_DOWN);
            return;
        }

        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var textY = centerY + dc.getHeight() / 4;

        var timerVal = _timerState.getCurrentTimeRemaining() >= 0.0 ? _timerState.getCurrentTimeRemaining() : 0.0;

        var displayStr = "";
        if (_timerState.getCurrentState() == IntervalTimer.STATE_TIMING_START_DELAY)
        {
            displayStr = "WAIT";
        }
        else if (_timerState.getCurrentState() == IntervalTimer.STATE_TIMING_INTERVAL)
        {
            displayStr = "INTERVAL";
        }

        Drawing.drawTimerValueWithFont(centerX, centerY, dc, timerVal, _font);
        Drawing.drawTextWithFont(centerX, textY, displayStr, dc, _font);

        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void
    {
        resetState();
    }

    function resetState() as Void
    {
        _timer.stop();
        _timerState.reset();

        _intervalStartAlertRequested = false;
        _intervalFinishAlertRequested = false;
        _exitRequested = false;
        _alertTriggered = false;
    }   

}