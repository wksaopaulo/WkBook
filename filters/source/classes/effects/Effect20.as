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
    public class Effect19 extends Effect
    {   
        private const MAX_DISPL:Number = 500;
        
        override protected function getProcessedImage(amount:Number):DisplayObject
        {
           //Return value
           var result:Sprite = new Sprite;

            //Create a image in the size we need
            var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH, BOOK_HEIGHT);

            //Separate channels
            var pixelsRect:Rectangle = new Rectangle(0, 0, resizedImage.width, resizedImage.height);
            var displ:Number = MAX_DISPL * amount; 
            var i:int=0;
            for each (var channel:uint in [1, 2, 4])
            {
                //Create bitmap
                var bmp:Bitmap = new Bitmap(new BitmapData(resizedImage.width, resizedImage.height, false, 0xff000000));
                //Copy channel
                bmp.bitmapData.copyChannel(resizedImage.bitmapData, pixelsRect, new Point(), channel, channel);
                //Set blend mode as screen
                bmp.blendMode = BlendMode.SCREEN;
                //Compose
                bmp.x = -displ/3 + displ*i++;

                //Present
                result.addChild(bmp);
            }

            
            return result;
        }
    }
} 