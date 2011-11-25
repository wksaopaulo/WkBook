package effects
{
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
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
    public class Effect22 extends Effect
    {   
        private const PIXELATE:int = 50;
        private const PIXEL_SIZE:Number = 1000;
        
        override protected function getProcessedImage(amount:Number):DisplayObject
        {
            amount += 0.1;

            var scale:Number = 50 + PIXELATE/amount;

            //Create a image in the size we need
            var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/scale, BOOK_HEIGHT/scale);
            
            var result:Sprite = new Sprite();
            for (var x:int = 0; x < resizedImage.width; x++)
            {
                for (var y:int = 0; y < resizedImage.height; y++)
                {
                    var pixelColor:uint = resizedImage.bitmapData.getPixel(x, y);
                    var pixelSize:Number = luma(pixelColor)/255;
                    result.graphics.beginFill(pixelColor);
                    result.graphics.drawRect(x * scale, y * scale, PIXEL_SIZE/2 + PIXEL_SIZE*pixelSize, PIXEL_SIZE*pixelSize);
                    result.graphics.endFill();
                }
            }


            
            return result;
        }
    }
} 