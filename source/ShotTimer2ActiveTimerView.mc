import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.Lang;
import Toybox.Time;

class ShotTimer2ActiveTimerView extends WatchUi.View {

    private var _timerState as IntervalTimer;
    private var _timer as Timer.Timer?;
    private var hasVibratedForIntervalStart as Boolean = false;

    function initialize(timerState as IntervalTimer) {
        _timerState = timerState;
        
        
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void
    {
        //setLayout(Rez.Layouts.ActiveTimerLayout(dc));

        _timer = new Timer.Timer();
        _timer.start(method(:timerCallback), 100, true);
        _timerState.start();
    }
    
    function playVibeAndTone() as Void
    {
        
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


    function timerCallback() as Void
    {
        _timerState.doTimerTick(0.1);

        // If the interval timer just started, vibrate the watch
        if (_timerState.justStartedIntervalTimer() and !hasVibratedForIntervalStart)
        {
            hasVibratedForIntervalStart = true;

            playVibeAndTone();
        }

        // Request the view to be redrawn
        WatchUi.requestUpdate();
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

        if (_timerState.getCurrentState() == IntervalTimer.STATE_FINISHED)
        {
            WatchUi.popView(WatchUi.SLIDE_DOWN);

            _timer.stop();
            _timerState.reset();

            playVibeAndTone();

            return;
        }

        var timerVal = _timerState.getCurrentTimeRemaining() >= 0.0 ? _timerState.getCurrentTimeRemaining() : 0.0;

        var fontHeight = dc.getFontHeight(Graphics.FONT_LARGE);
        var fontWidth = fontHeight * 0.6;

        var centerX = dc.getWidth() / 2 - fontWidth / 2;
        var centerY = dc.getHeight() / 2 - fontHeight / 2;

        dc.drawText(centerX, centerY, Graphics.FONT_LARGE, timerVal.format("%.1f"), Graphics.TEXT_JUSTIFY_LEFT);


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
        hasVibratedForIntervalStart = false;
    }   

}