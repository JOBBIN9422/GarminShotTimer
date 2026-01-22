import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

public class Drawing
{
    public static var TIMER_FORMAT_STR = "%.1f";

    public static function drawTimerValueBasic(dc as Dc, timerVal as Float) as Void
    {
        var fontHeight = dc.getFontHeight(Graphics.FONT_LARGE);
        var fontWidth = fontHeight * 0.6;
        //var dotWidth = fontWidth * 0.4;

        var centerX = dc.getWidth() / 2 - fontWidth / 2;
        var centerY = dc.getHeight() / 2 - fontHeight / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(centerX, centerY, Graphics.FONT_LARGE, timerVal.format("%.1f"), Graphics.TEXT_JUSTIFY_LEFT);
    }

    public static function drawTimerValWithSelectorBasic(dc as Dc, timerVal as Float, selectedDigit as Number) as Void
    {
        var fontHeight = dc.getFontHeight(Graphics.FONT_LARGE);
        var fontWidth = fontHeight * 0.6;
        //var dotWidth = fontWidth * 0.4;

        var centerX = dc.getWidth() / 2 - fontWidth / 2;
        var centerY = dc.getHeight() / 2 - fontHeight / 2;

        var pickerSecondsOffsetX = centerX + fontHeight * 0.2;
        var pickerOffsetY = centerY + fontHeight;
        var pickerTenthsOffsetX = pickerSecondsOffsetX + fontHeight * 0.5;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(centerX, centerY, Graphics.FONT_LARGE, timerVal.format("%.1f"), Graphics.TEXT_JUSTIFY_LEFT);

        // Indicate selected digit
        if (selectedDigit == 0)
        {
            //dc.drawRectangle(centerX, centerY, fontWidth, fontHeight); // around seconds
            dc.drawText(pickerSecondsOffsetX, pickerOffsetY, Graphics.FONT_MEDIUM, "^", Graphics.TEXT_JUSTIFY_CENTER);
        }
        else if (selectedDigit == 1)
        {
            //dc.drawRectangle(centerX + fontWidth, centerY, fontWidth, fontHeight); // around tenths
            dc.drawText(pickerTenthsOffsetX, pickerOffsetY, Graphics.FONT_MEDIUM, "^", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    public static function drawTextWithFont(x as Number, y as Number, text as String, dc as Dc, font as FontResource) as Void
    {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(x, y, font, text, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    public static function drawTimerValueWithFont(x as Number, y as Number, dc as Dc, timerVal as Float, font as FontResource) as Void
    {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.drawText(centerX, centerY, font, timerVal.format(TIMER_FORMAT_STR), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    public static function drawTimerValueWithFontAndSelector(x as Number, y as Number, dc as Dc, timerVal as Float, selectedDigit as Number, font as FontResource) as Void
    {
        drawTimerValueWithFont(x, y, dc, timerVal, font);

        var textWidth = dc.getTextWidthInPixels(timerVal.format(TIMER_FORMAT_STR), font);
        var selectorY = y - dc.getFontHeight(font) - 10;
        var selectorX = 0;

        if (selectedDigit == 0)
        {
            selectorX = x - textWidth / 2 + textWidth / 4;
        }
        else if (selectedDigit == 1)
        {
            selectorX = x + textWidth / 4;
        }

        dc.drawText(selectorX, selectorY, Graphics.FONT_MEDIUM, "V", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
