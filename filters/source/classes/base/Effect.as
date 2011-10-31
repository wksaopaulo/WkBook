package base
{
	import dupin.display.safeRemoveChild;
	import flash.utils.ByteArray;
	import mx.graphics.codec.JPEGEncoder;
	import flash.utils.setInterval;
	import flash.external.ExternalInterface;
	import dupin.display.removeAllChildren;
	import dupin.display.bitmapData;
	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import dupin.display.*;

	public class Effect extends Sprite
	{
		protected var image:Bitmap;
		protected var text:String;

		private var _result:DisplayObject;

		public const CM_TO_INCH:Number = 0.393700787;
		public var PPI:int = 300;
		public var BOOK_WIDTH:int = 42 * CM_TO_INCH * PPI;
		public var BOOK_HEIGHT:int = 28 * CM_TO_INCH * PPI;

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
					if(ExternalInterface.available){
						ExternalInterface.addCallback("setAmount", setAmount);
						ExternalInterface.addCallback("upload", upload)
					} else
						trace("No external interface available");
				})
			})
			l.load(new URLRequest(loaderInfo.parameters['image'] || "testImage.jpg"));
		  
		  	//Get the text
		  	this.text = loaderInfo.parameters['text'] || "";
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
			safeRemoveChild(bookCanvas);
			bookCanvas = null;

			addPageSizedChild(_result = getProcessedImage(Math.max(value, 0.1)));
		}

		//Send file to the server
		protected function upload(url:String="/book_creator/save_image"):void
		{
			var encoder:JPEGEncoder = new JPEGEncoder(90);
			var data:ByteArray = encoder.encode(bitmapData(_result));

			var hdr:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var req:URLRequest = new URLRequest(url);
				req.requestHeaders.push(hdr);
				req.data = data;
				req.method = URLRequestMethod.POST;			
			
            var ldr:URLLoader = new URLLoader();
                ldr.dataFormat = URLLoaderDataFormat.BINARY;
                ldr.addEventListener(Event.COMPLETE, onRequestComplete);
                ldr.addEventListener(IOErrorEvent.IO_ERROR, onRequestFailure);
                ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRequestFailure);	
          		ldr.load(req);
		}
		private function onRequestComplete(e:Event):void
		{
			ExternalInterface.call("uploadComplete");
		}
		private function onRequestFailure(e:ErrorEvent):void
		{
			ExternalInterface.call("uploadFailed", e.toString());
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