package effects
{
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
	public class Effect18 extends Effect
	{	
        private const BLUR_VAL:Number = 5;
        private const MAX_WIDTH:Number = 10;
        private const MIN_WIDTH:Number = 10;
        
		override protected function getProcessedImage(amount:Number):DisplayObject
    	{
            //Create a image in the size we need
            var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/3, BOOK_HEIGHT/3);

            //Calculate how much to resize
            var s:Number = 0.01 + 0.02*amount;

            //Do it
            var bmp:Bitmap = getThin(resizedImage, s);
            //bmp.transform.colorTransform = new ColorTransform(1.2, 1.1, 0.8);

            bmp = getInProportion(bmp, BOOK_WIDTH, BOOK_HEIGHT);
            
            return bmp;
    	}

        protected function getThin(source:Bitmap, s:Number):Bitmap
        {
            //How thin?
            var m:Matrix = new Matrix();
            m.scale(s, 1);

            //Create a really thin image
            var thin:Bitmap = new Bitmap(new BitmapData(source.width * s, source.height, true, 0xff0000));
            thin.bitmapData.draw(source, m);
            thin.bitmapData.applyFilter(thin.bitmapData, new Rectangle(0, 0, BOOK_WIDTH/2, BOOK_HEIGHT/2), new Point, new BlurFilter(BLUR_VAL, 0));
            var normal:Bitmap = new Bitmap(new BitmapData(source.width, source.height));
            m = new Matrix();
            m.scale(1/s, 1);
            normal.bitmapData.draw(thin, m);

            return normal;
        }
    }
} 