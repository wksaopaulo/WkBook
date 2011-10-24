package effects
{
    import flash.display.Shape;
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

	[SWF(width='1024', height='768', backgroundColor='#FFFFFF', frameRate='60')]
	public class Effect8 extends Effect
	{	
        private var effectMask:Bitmap;

        //Load effect map
        override protected function setup(callback:Function):void
        {
            var l:Loader = new Loader;
            l.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
                
                effectMask = l.content as Bitmap;
                effectMask.cacheAsBitmap = true;
                callback();

            })
            l.load(new URLRequest("effect8_mask.jpg"));
        }
        
		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
           var result:Sprite = new Sprite();

           var val:uint = 155*amount;

           var finalMask:Bitmap = new Bitmap(new BitmapData(BOOK_WIDTH, BOOK_HEIGHT, true, 0xFF000000));
           finalMask.cacheAsBitmap = true;
           finalMask.bitmapData.threshold(effectMask.bitmapData, effectMask.bitmapData.rect, new Point(), "<", val, 0x0, 0x000000ff);

            var s:Shape = new Shape();
            with(s.graphics){
               beginFill(0xba00ff);
               drawRect(0, 0, BOOK_WIDTH, BOOK_HEIGHT);
               endFill();
            }
            s.cacheAsBitmap = true;
            s.mask = finalMask;
            result.addChild(getInProportion(image, BOOK_WIDTH, BOOK_HEIGHT));
            result.addChild(s);
            result.addChild(finalMask);
            
            return result;
    	}
    }
} 