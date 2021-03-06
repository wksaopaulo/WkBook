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
    import flash.filters.ShaderFilter;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import base.Effect;

	[SWF(width='1024', height='768', backgroundColor='#000000', frameRate='60')]
	public class Effect11 extends Effect
	{	
        private var effectMask:Bitmap;

        [Embed(source = "../../shader/warp.pbj", mimeType = 'application/octet-stream')] 
        private static const Warp  :Class;
        private var warpShader      :Shader     = new Shader( new Warp() ); 

        override protected function getProcessedImage(amount:Number):DisplayObject
        {
          amount = 0.4 + amount*0.6;
           //Create a image in the size we need
           var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH, BOOK_HEIGHT);

           warpShader.data.image_h.value = [ BOOK_HEIGHT/2 ];
           warpShader.data.center.value  = [ BOOK_WIDTH/2 , BOOK_HEIGHT/2 ];
           warpShader.data.spread.value  = [ BOOK_WIDTH * 4 * (amount) ];

           var f:ShaderFilter = new ShaderFilter(warpShader);
           resizedImage.bitmapData.applyFilter( resizedImage.bitmapData, resizedImage.bitmapData.rect, new Point, f );

           //resizedImage2.bitmapData.draw(resizedImage);

           return resizedImage;
    	}
    }
} 