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
	public class Effect15 extends Effect 
	{	
        override protected function getProcessedImage(amount:Number):DisplayObject
        {
          var mountain:Mountain = new Mountain;
          trace(BOOK_WIDTH, BOOK_HEIGHT)

          //Store size value because it will change due to masking
          var mHeight:int = mountain.height;
          var mWidth:int = mountain.width;

          //Paint BG
          var result:Sprite = new Sprite();
          result.graphics.beginFill(0xffffff);
          result.graphics.drawRect(0, 0, BOOK_WIDTH, BOOK_HEIGHT);
          result.graphics.endFill();

          var i:int=0;
          //Fill mountain with user image
          while (mountain.hasOwnProperty("top" + (++i)))
          {
            var b:Bitmap = new Bitmap(bitmapData(image));
            b.filters = [new DropShadowFilter()];
            b.smoothing = true;
            fitAndMask(b, mountain["top" + i], true);
          }

          i=0;
          //Fill mountain with user image
          while (mountain.hasOwnProperty("front" + (++i)))
          {
            b = new Bitmap(bitmapData(image));
            b.filters = [new DropShadowFilter()];
            b.smoothing = true;
            fitAndMask(b, mountain["front" + i], true);
          }

          //Proportion on layout
          var mountainScale:Number = 3.5;
          //Draw the final mountain
          var bigMountain:Bitmap = new Bitmap(new BitmapData(mWidth*mountainScale, mHeight*mountainScale, true, 0x0));
          var matrix:Matrix = new Matrix();
          matrix.scale(mountainScale, mountainScale);
          bigMountain.bitmapData.draw(mountain, matrix);

          amount = 3;
          if(amount <= 0.33) {

            var m1:Bitmap = new Bitmap(bitmapData(bigMountain));
            m1.x = BOOK_WIDTH/2 - bigMountain.width/2;
            m1.y = BOOK_HEIGHT - bigMountain.height;
            result.addChild(m1);

          } else if (amount <= 0.66){

            var m2:Bitmap = new Bitmap(bitmapData(bigMountain));
            m2.x = BOOK_WIDTH/4*3 - bigMountain.width/2;
            m2.y = BOOK_HEIGHT - bigMountain.height;
            result.addChild(m2);

            var m3:Bitmap = new Bitmap(bitmapData(bigMountain));
            m3.x = BOOK_WIDTH/4 - bigMountain.width/2;
            m3.y = BOOK_HEIGHT - bigMountain.height;
            result.addChild(m3);

          } else {

            m1 = new Bitmap(bitmapData(bigMountain));
            m1.x = BOOK_WIDTH/2 - bigMountain.width/2;
            m1.y = m1.height;
            m1.scaleY = -1;
            result.addChild(m1);
            
            m2 = new Bitmap(bitmapData(bigMountain));
            m2.x = BOOK_WIDTH/4*3 - bigMountain.width/2;
            m2.y = BOOK_HEIGHT - bigMountain.height;
            result.addChild(m2);

            m3 = new Bitmap(bitmapData(bigMountain));
            m3.x = BOOK_WIDTH/4 - bigMountain.width/2;
            m3.y = BOOK_HEIGHT - bigMountain.height;
            result.addChild(m3);            

          }

          //Crop external stuff
          var finalBmp:Bitmap = new Bitmap(new BitmapData(BOOK_WIDTH, BOOK_HEIGHT));
          finalBmp.bitmapData.draw(result);

           return finalBmp;
    	}
    }
} 