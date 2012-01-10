package effects
{
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.display.Shape;
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
	public class Effect3 extends Effect
	{	
        private const PIXELATE:int = 100;
                
		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
    		amount += 0.5;
    		
            //Create a image in the size we need
    		var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/(PIXELATE*amount), BOOK_HEIGHT/(PIXELATE*amount));

            return getInProportion(resizedImage, BOOK_WIDTH, BOOK_HEIGHT);
    	}
    }
} 