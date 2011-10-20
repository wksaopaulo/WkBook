package effects
{
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

	[SWF(width='1024', height='768', backgroundColor='#FFFFFF', frameRate='60')]
	public class Effect2 extends Effect
	{	
        private const PIXEL_WIDTH:int = 20;
        private const PIXEL_HEIGHT:int = 20;

		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
           //Return value
           var result:Sprite = new Sprite;

    		//Create a image in the size we need
    		var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/40, BOOK_HEIGHT/40);

            for (var y:int = 0; y < resizedImage.height; y++)
            {
                for (var x:int = 0; x < resizedImage.width; x++)
                {
                    //Draw the pixel
                    var pixel:Shape = new Shape();
                    pixel.graphics.beginFill(resizedImage.bitmapData.getPixel(x,y));
                    pixel.graphics.drawRoundRect(0, 0, PIXEL_WIDTH, PIXEL_HEIGHT, 10);

                    //Place on screen
                    pixel.x = x * BOOK_WIDTH/resizedImage.width;
                    pixel.y = y * BOOK_HEIGHT/resizedImage.height;
                    
                    //show
                    result.addChild(pixel);
                }
            }
            
    		
    		return new Bitmap(bitmapData(result));
    	}
    }
} 