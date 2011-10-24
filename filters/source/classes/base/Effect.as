package base
{
	import flash.external.ExternalInterface;
	import dupin.display.removeAllChildren;
	import dupin.display.bitmapData;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import dupin.display.*;

	public class Effect extends Sprite
	{
		protected var image:Bitmap;
		protected var text:String;

		public const CM_TO_INCH:Number = 0.393700787;
		public const PPI:int = 300;
		public const BOOK_WIDTH:int = 42 * CM_TO_INCH * PPI;
		public const BOOK_HEIGHT:int = 28 * CM_TO_INCH * PPI;

		//Holds all book content
		protected var bookCanvas:Sprite;

    	public function Effect()
		{
			//Stage setup
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//Load initial image
			var l:Loader = new Loader()
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				image = l.content as Bitmap;

				//do some setup
				setup(function():void{
					//Apply effect with 50% strength
					setAmount(0.5);

					//Enabling customization
					if(ExternalInterface.available)
						ExternalInterface.addCallback("setAmount", setAmount);
				})
			})
			l.load(new URLRequest(loaderInfo.parameters['image'] || "testImage.jpg"));
		  
		  	//Get the text
		  	this.text = loaderInfo.parameters['text'] || "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmodtempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodoconsequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
		}

		//Method to override
		protected function setup(callback:Function):void
		{
			callback();
			return;
		}

		//Method to override
		protected function getProcessedImage(amount:Number):DisplayObject
		{
			return null;
		}

		//amount of effect, method to override
		public function setAmount(value:Number):void
		{
			removeAllChildren(bookCanvas);
			addPageSizedChild(getProcessedImage(Math.max(value, 0.1)));
		}

		/*
		making things easier by avoiding scale issues
		*/
		override public function addChild(o:DisplayObject):DisplayObject
		{
			if(!bookCanvas){
				//Create real proportion
				bookCanvas = new Sprite();
				bookCanvas.graphics.beginFill(0x0);
				bookCanvas.graphics.drawRect(0, 0, BOOK_WIDTH, BOOK_HEIGHT);
				bookCanvas.graphics.endFill();

				//Make fit screen
				bookCanvas.width = stage.stageWidth;
				bookCanvas.scaleY = bookCanvas.scaleX;

				//Add
				super.addChild(bookCanvas);
			}
			return bookCanvas.addChild(o);
		}
		override public function removeChild(o:DisplayObject):DisplayObject
		{
			return bookCanvas.removeChild(o);
		}

		/*
		Helpers
		*/

		protected function addPageSizedChild(target:DisplayObject):void
		{
			//Create a mask
			var m:Shape = new Shape();
			m.graphics.beginFill(0x0);
			m.graphics.drawRect(0, 0, BOOK_WIDTH, BOOK_HEIGHT);
			m.graphics.endFill();
			addChild(m);

			//Making fit
			fitAndMask(target, m);
		}

		// Saturation 0..1
		protected function saturate(saturation:Number, o:DisplayObject):void
		{
			var _s:Number = saturation*2;
			var m:Array = [
				0.114 + 0.886 * _s, 0.299 * (1 - _s), 0.587 * (1 - _s), 0, 
				0, 0.114 * (1 - _s), 0.299 + 0.701 * _s, 0.587 * (1 - _s), 
				0, 0, 0.114 * (1 - _s), 0.299 * (1 - _s), 
				0.587 + 0.413 * _s, 0, 0, 0, 
				0, 0, 1, 0
			];

			o.filters = o.filters.concat([new ColorMatrixFilter(m)]);
		}

		// Contrast 0..1
		protected function contrast(contrast:Number, o:DisplayObject):void
		{
			var s:Number = -100 + contrast*200;
			var a : Number = 128 * (1 - s);

			var m:Array = [
            	s, 0, 0, 0, a,  // red
            	0, s, 0, 0, a,  // green
            	0, 0, s, 0, a,  // blue
            	0, 0, 0, 1, 0  // alpha
            ];
            o.filters = o.filters.concat([new ColorMatrixFilter(m)]);
		}

		protected function getInProportion(o:DisplayObject, width:int, height:int):Bitmap
		{
			var r:Bitmap = new Bitmap(new BitmapData(width, height, true, 0x0));
			var cp:Bitmap = new Bitmap(bitmapData(o));

			//Put in the size we want
			var holder:Sprite = new Sprite();
			var s:Shape = new Shape();
			with(s.graphics) beginFill(0x0), drawRect(0, 0, width, height), endFill();
			holder.addChild(s);
			fitAndMask(cp, s);

			//Print
			r.bitmapData.draw(holder);
			r.smoothing = true;

			return r;
		}
	}

}