package base
{
	import mx.graphics.codec.PNGEncoder;
	import fl.text.*;
	import flash.text.*;
	import flash.geom.ColorTransform;
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
		protected var title:String;

		private var _result:DisplayObject;
		private var _textColor:uint=0;

		public const CM_TO_INCH:Number = 0.393700787;
		public var PPI:int = 300;
		public var BOOK_WIDTH:int = 42 * CM_TO_INCH * PPI;
		public var BOOK_HEIGHT:int = 28 * CM_TO_INCH * PPI;

		//Holds all book content
		protected var bookCanvas:Sprite;
		//Text layouts
		protected var textOverlays:TextOverlays

    	public function Effect()
		{
			//Stage setup
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//Get the text form loaderInfo
		  	this.title = loaderInfo.parameters['title'] || "";
		  	this.text = loaderInfo.parameters['text'] || "";

			//Text
			textOverlays = new TextOverlays();
			textOverlays.width = BOOK_WIDTH;
			textOverlays.scaleY = textOverlays.scaleX;
			setTextLayout(loaderInfo.parameters['text_layout'] || 0);
			setTextColor(loaderInfo.parameters['text_color'] || 0x0);

			stage.addEventListener(Event.RESIZE, onResize);

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
						ExternalInterface.addCallback("setTextLayout", setTextLayout);
						ExternalInterface.addCallback("setTextColor", setTextColor);
						ExternalInterface.addCallback("upload", upload);
					} else
						trace("No external interface available");
				})
			})
			l.load(new URLRequest(loaderInfo.parameters['image'] || "testImage.jpg"));

		}
		protected function onResize(e:Event):void
		{
			if(_result)
				addPageSizedChild(_result);
		}

		//Method to override
		protected function setup(callback:Function):void
		{
			callback();
			return;
		}

		//Set text disposition
		protected function setTextLayout(number:uint):void
		{
			textOverlays.gotoAndStop(number+1);
			//try{
			//	textOverlays.title.text = title;
			//	textOverlays.text.text = text;
			//} catch(e:Error) {
			//	textOverlays.text.text = title + "\n\n" + text;
			//}
			updateTextColor();
			
		}
		//Set text color
		protected function setTextColor(c:uint):void
		{
			_textColor = c;
			updateTextColor();
		}
		protected function updateTextColor():void
		{
			//Create a text format with the selected color
			var fmt:TextFormat = new TextFormat;
			fmt.color = _textColor;

			for (var i:int = 0; i < textOverlays.numChildren; i++)
			{
				var tf:DisplayObject = textOverlays.getChildAt(i);
				if(tf is TLFTextField){
					(tf as TLFTextField).setTextFormat(fmt);
				}
			}
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
			var encoder:PNGEncoder = new PNGEncoder();
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

				////Make fit screen
				//bookCanvas.width = stage.stageWidth;
				//bookCanvas.scaleY = bookCanvas.scaleX;

				//Add
				super.addChild(bookCanvas);
			}

			//Add to the content holder
			bookCanvas.addChild(o)

			//Keep text on top
			bookCanvas.addChild(textOverlays);

			return o;
		}

		/*
		Helpers
		*/

		protected function addPageSizedChild(target:DisplayObject):void
		{
			const MARGIN_BOTTOM:Number = 135;
			var w:Number;
			var h:Number;
			var r:Number = stage.stageWidth/(stage.stageHeight-MARGIN_BOTTOM);

			if(r > BOOK_WIDTH/BOOK_HEIGHT){
				target.height = stage.stageHeight - MARGIN_BOTTOM;
				target.scaleX = target.scaleY;
				target.x = (stage.stageWidth-target.width)/2;
				target.y = 0;
			} else {
				target.width = stage.stageWidth;
				target.scaleY = target.scaleX;
				target.x = 0;
				target.y = (stage.stageHeight-MARGIN_BOTTOM-target.height)/2;
			}

			addChild(target);

			////Create a mask
			//var m:Shape = new Shape();
			//m.graphics.beginFill(0x0);
			//m.graphics.drawRect(0, 0, BOOK_WIDTH, BOOK_HEIGHT);
			//m.graphics.endFill();
			//addChild(m);

			////Making fit
			//fitAndMask(target, m);
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

		protected function luma(c:uint):uint
		{
            var r:uint = (( c >> 16 ) & 0xFF);
            var g:uint = ( (c >> 8) & 0xFF );
            var b:uint = ( c & 0xFF );
            return (r + g + b) / 3;
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