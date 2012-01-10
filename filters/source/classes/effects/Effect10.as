package effects
{
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
	public class Effect10 extends Effect 
	{	
        private var effectMask:Bitmap;

        [Embed(source = "../../shader/deformer.pbj", mimeType = 'application/octet-stream')] 
        private static const PBK  :Class;
        private var deformShader      :Shader     = new Shader( new PBK() ); 

        override protected function getProcessedImage(amount:Number):DisplayObject
        {
           //Create a image in the size we need
           var resizedImage:Bitmap = getInProportion(image, 1024, 768);

           deformShader.data.stretch.value = [ 2 ];
           deformShader.data.center_x.value  = [ 152 ];
           deformShader.data.center_y.value  = [ 102 ];
           deformShader.data.imageHeight.value = [ 2024 + amount*1000 ];

           var f:ShaderFilter = new ShaderFilter(deformShader);
           resizedImage.bitmapData.applyFilter( resizedImage.bitmapData, resizedImage.bitmapData.rect, new Point, f );

           return getInProportion(resizedImage, BOOK_WIDTH, BOOK_HEIGHT);
    	}
    }
} 