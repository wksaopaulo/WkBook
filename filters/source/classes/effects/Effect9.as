package effects
{
    import flash.display.GradientType;
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
	public class Effect9 extends Effect
	{	
        private var effectMask:Bitmap;

        override protected function getProcessedImage(amount:Number):DisplayObject
    	{
           //Minimum size and limit
           amount *= 0.06 + 0.01;

           //Pixelate to the final number of rows
           var smallImg:Bitmap = getInProportion(image, BOOK_WIDTH*amount, BOOK_HEIGHT*amount);

           var pixelSize:int = BOOK_WIDTH/smallImg.width;

           var result:Sprite = new Sprite();

           result.graphics.beginFill(0xffda0f);
           result.graphics.drawRect(0, 0, BOOK_WIDTH, BOOK_HEIGHT);
           result.graphics.endFill();

           var m:Matrix = new Matrix;
           m.createGradientBox(BOOK_WIDTH, BOOK_HEIGHT, Math.PI/2);
           result.graphics.beginGradientFill(GradientType.LINEAR, [0xff00ff, 0x00ff00], [1, 1], [70, 255], m, InterpolationMethod.RGB);
           for (var y:int = 0; y < smallImg.height; y++)
           {
                for (var x:int = 0; x < smallImg.width; x++)
                {
                    var c:uint = smallImg.bitmapData.getPixel(x, y);
                    var r:uint = (( c >> 16 ) & 0xFF);
                    var g:uint = ( (c >> 8) & 0xFF );
                    var b:uint = ( c & 0xFF );
                    var lum:uint = (r + g + b) / 3;

                    var thisPSize:Number = pixelSize * (lum/256);
                    result.graphics.drawRect(x*pixelSize - thisPSize/2, y*pixelSize - thisPSize/2, thisPSize, thisPSize);
                }
           }
           result.graphics.endFill();

           return result;
    	}
    }
} 