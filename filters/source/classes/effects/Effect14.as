package effects
{
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

	[SWF(width='1024', height='768', backgroundColor='#FFFFFF', frameRate='60')]
	public class Effect14 extends Effect 
	{	
        override protected function getProcessedImage(amount:Number):DisplayObject
        {
           //Create a image in the size we need
           var sobel:BitmapData = Sobel.execute(getInProportion(image, BOOK_WIDTH/(5+10*amount), BOOK_HEIGHT/(5+10*amount)).bitmapData);
           var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH, BOOK_HEIGHT);

           //sobel.applyFilter(sobel, sobel.rect, new Point, new BlurFilter(3, 3));

           var matrix:Matrix = new Matrix();
           matrix.scale(resizedImage.width/sobel.width, resizedImage.height/sobel.height);
           resizedImage.bitmapData.draw(sobel, matrix, null, BlendMode.OVERLAY);
           var ct:ColorTransform = new ColorTransform();
           //ct.color = 0xffd510;
           resizedImage.transform.colorTransform = ct;

           return resizedImage;
    	}
    }
} 