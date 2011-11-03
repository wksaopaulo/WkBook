package effects
{
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.filters.DropShadowFilter;
  import dupin.display.fitAndMask;
  import flash.display.BlendMode;
  import dupin.filters.Sobel;
  import dupin.utils.ValueChanger;
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
    import flash.filters.ShaderFilter;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import base.Effect;

	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class Effect16 extends Effect 
	{	
        private const MIN_DIST:Number = 5;
        private const DIST:Number = 10;

        override protected function getProcessedImage(amount:Number):DisplayObject
        {
          var cp:Bitmap = getInProportion(image, BOOK_WIDTH/10, BOOK_HEIGHT/10);
          //cp.bitmapData.applyFilter(cp.bitmapData, cp.bitmapData.rect, new Point, new BlurFilter(30, 30));
          var displacedBmp:Bitmap = new Bitmap(new BitmapData(cp.width, cp.height, true, 0xffaaaaaa));
          displacedBmp.bitmapData.copyChannel(cp.bitmapData, cp.bitmapData.rect, new Point(-(MIN_DIST + DIST*amount), -(MIN_DIST + DIST*amount)), BitmapDataChannel.RED, BitmapDataChannel.RED);
          displacedBmp.bitmapData.copyChannel(cp.bitmapData, cp.bitmapData.rect, new Point(MIN_DIST + DIST*amount, MIN_DIST + DIST*amount), BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
          displacedBmp.bitmapData.applyFilter(displacedBmp.bitmapData, cp.bitmapData.rect, new Point, new BlurFilter(5+40*amount, 5+40*amount));

          var bigImg:Bitmap = getInProportion(displacedBmp, BOOK_WIDTH, BOOK_HEIGHT);
          
          return displacedBmp;
    	}
    }
} 