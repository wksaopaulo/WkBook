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
	public class Effect1 extends Effect
	{
		protected var effect1Displace:Bitmap;

		//Load effect map
		override protected function setup(callback:Function):void
		{
			var l:Loader = new Loader;
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				
				effect1Displace = l.content as Bitmap;
				callback();

			})
			l.load(new URLRequest("effect1_map.jpg"));
		}
		
		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
           amount=0.55 + amount*0.45;
           effect1Displace.filters = [];
           contrast(amount, effect1Displace);

    		//Create a image in the size we need
    		var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH, BOOK_HEIGHT);
    		var displacementMap:Bitmap = getInProportion(effect1Displace, BOOK_WIDTH, BOOK_HEIGHT);

            //add to screen
    		addChild(resizedImage);
    		//addChild(displacementMap);

    		//Desaturate
    		saturate(0, resizedImage);

    		//Reapply filters
    		resizedImage.filters = [resizedImage.filters[0], getFilter(displacementMap.bitmapData)];

    		return new Bitmap(bitmapData(resizedImage));
    	}

    	protected function getFilter(bmp:BitmapData):DisplacementMapFilter
    	{
    		var mapBitmap:BitmapData = bmp;
            var mapPoint:Point       = new Point(0, 0);
            var componentX:uint      = BitmapDataChannel.RED;
            var componentY:uint      = BitmapDataChannel.GREEN;
            var scaleX:Number        = 1000;
            var scaleY:Number        = 1000;
            var mode:String          = DisplacementMapFilterMode.WRAP;
            var color:uint           = 0;
            var alpha:Number         = 0;
            return new DisplacementMapFilter(mapBitmap,
                                             mapPoint,
                                             componentX,
                                             componentY,
                                             scaleX,
                                             scaleY,
                                             mode,
                                             color,
                                             alpha);
    	}
	}

} 