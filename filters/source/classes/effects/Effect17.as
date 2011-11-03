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
	public class Effect17 extends Effect 
	{	
        override protected function getProcessedImage(amount:Number):DisplayObject
        {
          var mosaic:Mosaic = new Mosaic(), i:int=0;
          while (mosaic.hasOwnProperty("tri" + ++i))
          {
            var pos:Number = ((i*0.47) % 1) * (i%3==0? amount : 1-amount);
            var pos2:Number = ((i*0.12) % 1) * (i%2==0? amount : 1-amount);

            var cp:Bitmap = new Bitmap(new BitmapData(image.width, image.height));
            var m:Matrix = new Matrix();
            m.translate(-image.width/2*(pos), -image.height/2*(pos2));
            m.scale(2, 2);
            cp.bitmapData.draw(image, m);

            saturate(0, cp);
            fitAndMask(cp, mosaic["tri"+i]);
          }
          var matrix:Matrix = new Matrix();
          matrix.scale(4, 4);

          mosaic.tintTris.alpha = amount;

          var result:Bitmap = new Bitmap(new BitmapData(BOOK_WIDTH, BOOK_HEIGHT, true, 0x0));
          result.bitmapData.draw(mosaic, matrix);

          return result;
    	}
    }
} 