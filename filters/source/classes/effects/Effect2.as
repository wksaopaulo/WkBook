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
	public class Effect2 extends Effect
	{	
        private const PIXEL_WIDTH:int = 30;
        private const PIXEL_HEIGHT:int = 30;
        private const DEPTH:Number = 4000;

        
		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
           //Return value
           var result:Sprite = new Sprite;

    		//Create a image in the size we need
    		var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/50, BOOK_HEIGHT/50);

            var c:uint, r:uint, g:uint, b:uint, lum:uint, pixel:Shape;
            for (var y:int = 0; y < resizedImage.height; y++)
            {
                for (var x:int = 0; x < resizedImage.width; x++)
                {
                    c = resizedImage.bitmapData.getPixel(x,y); //Pixel color
                    r = (( c >> 16 ) & 0xFF);
                    g = ( (c >> 8) & 0xFF );
                    b = ( c & 0xFF );
                    lum = (r + g + b) / 3;

                    //Draw the pixel
                    pixel = new Shape();
                    pixel.graphics.beginFill(c);
                    pixel.graphics.drawRoundRect(0, 0, PIXEL_WIDTH, PIXEL_HEIGHT, 10);

                    //Place on screen
                    pixel.x = x * BOOK_WIDTH/resizedImage.width;
                    pixel.y = y * BOOK_HEIGHT/resizedImage.height;
                    pixel.z = lum/256 * DEPTH * amount;
                    
                    //show
                    result.addChild(pixel);
                }
            }
            
    		
    		return new Bitmap(bitmapData(result));
    	}
    }
} 