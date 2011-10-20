package dupin.ui
{
	import dupin.display.bitmapData;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	public class Draggable extends EventDispatcher
	{
		protected var offX:Number;
		protected var offY:Number;
		public var asset:DisplayObject;
		protected var direction:int;

		public static const VERTICAL:int = 1;
		public static const HORIZONTAL:int = 2;

    	public function Draggable(asset:Sprite, direction:int = 3)
		{
		  asset.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		  asset.buttonMode = true;

		  this.asset = asset;
		  this.direction = direction;
		}
		protected function onDown(e:MouseEvent):void
		{
			offX = asset.mouseX;
			offY = asset.mouseY;

			asset.stage.addEventListener(MouseEvent.MOUSE_UP, onUp, false, 0, true);
			asset.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		protected function onUp(e:MouseEvent):void
		{
			asset.removeEventListener(Event.ENTER_FRAME, update);
			e.target.removeEventListener(MouseEvent.MOUSE_UP, onUp);
		}

		protected function update(e:Event):void
		{
			if(direction & HORIZONTAL)
				asset.x = asset.parent.mouseX - offX;
			if(direction & VERTICAL)
				asset.y = asset.parent.mouseY - offY;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
	}

}