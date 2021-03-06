package effects
{
    import flash.display.BitmapDataChannel;
    import flash.filters.DisplacementMapFilterMode;
    import flash.filters.DisplacementMapFilter;
    import flash.geom.ColorTransform;
    import com.greensock.plugins.ColorTransformPlugin;
    import flash.geom.Matrix;
    import dupin.display.bitmapData;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.filters.BlurFilter;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import base.Effect;

	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class Effect7 extends Effect
	{	
        private var effectDisplace:Bitmap;

        //Load effect map
        override protected function setup(callback:Function):void
        {
            var l:Loader = new Loader;
            l.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
                
                effectDisplace = l.content as Bitmap;
                callback();

            })
            l.load(new URLRequest("effect7_map.jpg"));
        }
        
		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
           if(amount == 0.5)
            amount = 0.6;
           //amount += 0.7;
            //User input
            effectDisplace.filters = [];
            contrast(amount, effectDisplace);

            var cp:BitmapData = effectDisplace.bitmapData.clone();
            cp.applyFilter(cp, cp.rect, new Point, effectDisplace.filters[0]);

            //Create a image in the size we need
            var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/2, BOOK_HEIGHT/2);
            resizedImage.filters = [getFilter(cp)];

            //Saturation
            saturate(0.3, resizedImage);

            resizedImage = getInProportion(resizedImage, BOOK_WIDTH, BOOK_HEIGHT);

            return resizedImage;
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