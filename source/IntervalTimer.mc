import Toybox.Lang;


public class IntervalTimer
{
    public static enum CurrTimerState
    {
        STATE_INITIAL,
        STATE_TIMING_START_DELAY,
        STATE_TIMING_INTERVAL,
        STATE_PAUSED,
        STATE_FINISHED
    }

    private var prevState as CurrTimerState = STATE_INITIAL;
    private var currState as CurrTimerState = STATE_INITIAL;
    private var stateAtPauseTime as CurrTimerState = STATE_INITIAL;
    private var delayDuration as Float = 0.0;
    private var intervalDuration as Float = 0.0;
    private var currTimeRemaining as Float = 0.0;

    public function initialize()
    {
    }

    public function getCurrentState() as CurrTimerState
    {
        return currState;
    }

    public function getCurrentTimeRemaining() as Float
    {
        return currTimeRemaining;
    }

    public function getDelayDuration() as Float
    {
        return delayDuration;
    }

    public function getIntervalDuration() as Float
    {
        return intervalDuration;
    }

    public function setDelayDuration(duration as Float) as Void
    {
        delayDuration = duration;
    }

    public function setIntervalDuration(duration as Float) as Void
    {
        intervalDuration = duration;
    }

    private function changeState(newState as CurrTimerState) as Void
    {
        prevState = currState;
        currState = newState;
    }

    private function resetTimeRemaining() as Void
    {
        if (delayDuration > 0.0)
        {
            changeState(STATE_TIMING_START_DELAY);
            currTimeRemaining = delayDuration;
        }
        else
        {
            changeState(STATE_TIMING_INTERVAL);
            currTimeRemaining = intervalDuration;
        }
    }

    // initial timer start - start delay if > 0, otherwise start interval
    public function start() as Void
    {
        prevState = STATE_INITIAL;
        currState = STATE_INITIAL;
        
        resetTimeRemaining();
    }

    public function pause() as Void
    {
        if (currState == STATE_TIMING_START_DELAY || currState == STATE_TIMING_INTERVAL)
        {
            stateAtPauseTime = currState;
            changeState(STATE_PAUSED);
        }
    }

    public function resume() as Void
    {
        if (currState == STATE_PAUSED)
        {
            currState = stateAtPauseTime;
        }
    }

    public function reset() as Void
    {
        changeState(STATE_INITIAL);
        
        resetTimeRemaining();
    }

    private function doTimerStateTransition() as Void
    {
        if (currState == STATE_TIMING_START_DELAY)
        {
            currState = STATE_TIMING_INTERVAL;
            currTimeRemaining = intervalDuration;
        }
        else if (currState == STATE_TIMING_INTERVAL)
        {
            currState = STATE_FINISHED;
        }
    }

    public function doTimerTick(timerDelta as Float) as Void
    {
        if (currState == STATE_INITIAL)
        {
            return;
        }
        
        if (currState == STATE_TIMING_START_DELAY || currState == STATE_TIMING_INTERVAL)
        {
            currTimeRemaining -= timerDelta;
            if (currTimeRemaining <= 0.0)
            {
                doTimerStateTransition();
            }
        }
        else if (currState == STATE_PAUSED)
        {
            return;
        }
        else if (currState == STATE_FINISHED)
        {
            return;
        }
    }

    public function justStartedIntervalTimer() as Boolean
    {
        return (prevState != STATE_TIMING_INTERVAL && currState == STATE_TIMING_INTERVAL);
    }
}