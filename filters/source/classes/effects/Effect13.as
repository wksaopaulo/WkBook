package effects
{
  import dupin.filters.Sobel;
  import ru.inspirit.image.edges.SobelEdgeDetector;
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
	public class Effect13 extends Effect 
	{	
        override protected function getProcessedImage(amount:Number):DisplayObject
        {
           //Create a image in the size we need
           var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/(5+10*amount), BOOK_HEIGHT/(5+10*amount));

           return new Bitmap(Sobel.execute(resizedImage.bitmapData));
    	}
    }
} 