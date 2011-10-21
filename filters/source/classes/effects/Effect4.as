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

	[SWF(width='1024', height='768', backgroundColor='#FFFFFF', frameRate='60')]
	public class Effect4 extends Effect
	{	
        private const PIXEL_WIDTH:int = 200;
        private const PIXEL_HEIGHT:int = 200;
        
		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
           //Return value
           var result:Sprite = new Sprite;

    		//Create a image in the size we need
    		var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/60, BOOK_HEIGHT/60);

            for (var y:int = 0; y < resizedImage.height; y++)
            {
                for (var x:int = 0; x < resizedImage.width; x++)
                {
                    var c:uint = resizedImage.bitmapData.getPixel(x,y); //Pixel color
                    var r:uint = (( c >> 16 ) & 0xFF);
                    var g:uint = ( (c >> 8) & 0xFF );
                    var b:uint = ( c & 0xFF );
                    var lum:uint = (r + g + b) / 3;

                    for each (var item:uint in [r << 16, g << 8, b])
                    {
                        //Draw the pixel
                        var pixel:Shape = new Shape();
                        pixel.blendMode = BlendMode.SCREEN;
                        pixel.graphics.beginFill(item);
                        pixel.graphics.drawRoundRect(0, 0, PIXEL_WIDTH*amount, PIXEL_HEIGHT*amount, 10);

                        //Place on screen
                        pixel.x = (x * BOOK_WIDTH/resizedImage.width + Math.random()* (PIXEL_WIDTH/2));
                        pixel.y = BOOK_HEIGHT - (y * BOOK_HEIGHT/resizedImage.height + Math.random()* (PIXEL_WIDTH/2));
                        pixel.z = lum/256;
                        
                        //show
                        result.addChild(pixel);
                    }

                }
            }
            
    		
    		return result;//new Bitmap(bitmapData(result));
    	}
    }
} 