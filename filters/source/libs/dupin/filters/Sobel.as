package dupin.filters
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	public class Sobel extends EventDispatcher
	{
    	public function Sobel()
		{
		  
		}

		public static function execute(bmp:BitmapData):BitmapData{

			var ret:BitmapData = new BitmapData(bmp.width, bmp.height);
			
			//top left, left, bottom... pixels
			var pT:uint=0, pTR:uint=0, pR:uint=0, pBR:uint=0, pB:uint=0, pBL:uint=0, pL:uint=0, pTL:uint=0;
			//Average and final colors
			var gx:uint=0, gy:uint=0, color:uint=0;

			for (var y:int = 0; y < bmp.height; y++)
			{
				for (var x:int = 0; x < bmp.width; x++)
				{
					pT = bmp.getPixel(x, y-1) >> 16 & 0xff;
					pTR = bmp.getPixel(x+1, y-1) >> 16 & 0xff;
					pR = bmp.getPixel(x+1, y) >> 16 & 0xff;
					pBR = bmp.getPixel(x+1, y+1) >> 16 & 0xff;
					pB = bmp.getPixel(x, y+1) >> 16 & 0xff;
					pBL = bmp.getPixel(x-1, y+1) >> 16 & 0xff;
					pL = bmp.getPixel(x-1, y) >> 16 & 0xff;
					pTL = bmp.getPixel(x-1, y-1) >> 16 & 0xff;

					//Calculate filter
					gx = Math.abs((pTR + pR*2 + pBR) - (pTR + pL*2 + pBL));
					gy = Math.abs((pTL + pT*2 + pTR) - (pBL + pB*2 + pBR));
					color = gx + gy;

					if(color > 255) color = 255;

					ret.setPixel(x, y, color + (color << 8) + (color << 16));
				}
			}

			return ret;
		}
	}

}