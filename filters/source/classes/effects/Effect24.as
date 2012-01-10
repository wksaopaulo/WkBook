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

    [SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
    public class Effect24 extends Effect
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
                    result.graphics.beginFill(pixelColor, 0.4);
                    result.graphics.moveTo(x * scale, y * scale);
                    result.graphics.lineTo(x * scale + PIXEL_SIZE/2, y * scale);
                    result.graphics.lineTo(x * scale + PIXEL_SIZE/2, y * scale + PIXEL_SIZE/2);
                    result.graphics.endFill();
                }
            }


            
            return result;
        }
    }
} 