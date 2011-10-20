package dupin.display{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

    import flash.display.DisplayObject;
    import flash.display.BitmapData;
    import flash.display.Stage;

    public function bitmapData(o:DisplayObject, colorBounds:Boolean=false):BitmapData{
	
		if(!o is Stage){
			var oldX:Number=o.x;
			var oldY:Number=o.y;
			o.x = o.y = 0;
		}

		//Default bitmap with all content
		var b:BitmapData = new BitmapData(Math.max(o.width, 1), Math.max(o.height,1), true, 0x0);
		var m:Matrix = new Matrix(); //Default matrix with no transformation

		if(colorBounds){
			b.draw(o);
			var r:Rectangle = b.getColorBoundsRect(0xFF000000, 0x0);
			m.translate(-r.x, -r.y);
		}

		//Draw
		b.draw(o, m);
	
		if (!o is Stage) o.x = oldX, o.y = oldY;

	    return b;
    }
}
