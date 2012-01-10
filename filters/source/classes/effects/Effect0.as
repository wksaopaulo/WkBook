package effects
{
	import flash.events.Event;
	import dupin.display.bitmapData;
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.filters.DisplacementMapFilter;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import base.Effect;

	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class Effect0 extends Effect
	{
		
		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
           return getInProportion(image, BOOK_WIDTH, BOOK_HEIGHT);
    	}

	}

} 