package base
{
	import flash.text.TextFieldAutoSize;
	import dupin.math.map;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import com.adobe.utils.StringUtil;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import effects.Block;

	[SWF(width='1280', height='800', backgroundColor='#330033', frameRate='60')]
	public class TextLayout extends Sprite
	{
		protected var text:String;
		protected var title:String;

		//Text layouts
		protected var textOverlays:TextOverlays;

    	public function TextLayout()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			//Get the text form loaderInfo
		  	this.title = loaderInfo.parameters['title'] || "";
		  	this.text = loaderInfo.parameters['text'] || "";

		  	//Text
			textOverlays = new TextOverlays();

		  	addChild(textOverlays);
		  	setTextLayout(loaderInfo.parameters['text_layout'] || 1);
			
		  	if (ExternalInterface.available)
				ExternalInterface.addCallback("setTextLayout", setTextLayout);

			stage.addEventListener(Event.RESIZE, onResize);
			onResize()
		}

		protected function onResize(e:Event=null):void
		{
			var propW:Number = stage.stageWidth * (textOverlays.width/textOverlays.scaleX / textOverlays.pageBase.width);
			var propH:Number = stage.stageHeight * (textOverlays.height/textOverlays.scaleY / textOverlays.pageBase.height);

			if (textOverlays.pageBase.width / textOverlays.pageBase.height > stage.stageWidth / stage.stageHeight) {
				textOverlays.width = propW;
				textOverlays.scaleY = textOverlays.scaleX;
			} else 
			{
				textOverlays.height = propH;
				textOverlays.scaleX = textOverlays.scaleY;
			}

			textOverlays.x = stage.stageWidth/2 - textOverlays.pageBase.width*textOverlays.scaleX/2;
			textOverlays.y = stage.stageHeight/2 - textOverlays.pageBase.height*textOverlays.scaleY/2;
		}

		//Set text disposition
		protected function setTextLayout(number:uint):void
		{
			trace("changing layout to: " + number);
			textOverlays.gotoAndStop(number);
			
			var allText:String = StringUtil.trim(title + "\n" + text);
			switch (number)
			{
				case 1 :
					var charIndex:int = 0;
					while (textOverlays.allText.hasOwnProperty("b"+charIndex))
					{
						//Get the text holder
						var block:Block = textOverlays.allText["b"+charIndex];

						//What are we going to fill it with?
						var t:String = " ";
						if (charIndex < allText.length)
							t = allText.substring(charIndex, charIndex + 1);
						trace("text at " + charIndex + " of " + allText.length + " is '" + t + "'")
						
						//Decide if it's a triangle
						if (t === " " || t == "\n")
						{
							block.gotoAndStop(2)
						} else
						{
							block.gotoAndStop(1)
							block.f.text = t.toUpperCase();
						}
						charIndex++;
					}
				break;
				case 2 :
					textOverlays.text.text = allText;
				break;
				case 3 :
				case 4 :
					var words:Array = allText.split(/\s|\n/);
					if (words.length > 0)
						textOverlays.top.top.text = words.shift().toUpperCase();
					if (words.length > 0) {
						var last:String = words.pop();
						textOverlays.text.text = words.join(" ");
						words = [last];
					} else { textOverlays.text.text = "" }
					if (words.length > 0)
						textOverlays.bottom.bottom.text = words.join(" ").toUpperCase();
					else { textOverlays.bottom.text = "" }

					// Make sprites as big as the text
					textOverlays.top.top.width = textOverlays.top.top.textWidth + 50;
					textOverlays.top.top.height = textOverlays.top.top.textHeight;
					textOverlays.bottom.bottom.width = textOverlays.bottom.bottom.textWidth + 50;
					
					//Match size of the big text fields with the size of the page
					var big:MovieClip, small:MovieClip;
					if (textOverlays.top.width > textOverlays.bottom.width)
					{
						big = textOverlays.top;
						small = textOverlays.bottom;
					} else
					{
						big = textOverlays.bottom;
						small = textOverlays.top;
					}
					// adjust width to match page
					big.width = 1200;
					big.scaleY = small.scaleX = small.scaleY = big.scaleX;

					textOverlays.top.y = textOverlays.text.y + textOverlays.text.height/2 - textOverlays.text.textHeight/2 - textOverlays.top.height;
					textOverlays.bottom.y = textOverlays.text.y + textOverlays.text.height/2 + textOverlays.text.textHeight/2 + 50;
					
				break;
				case 5 :
				case 6 :
					
					textOverlays.text.text = allText;
					textOverlays.quad.y = textOverlays.text.height/2 - textOverlays.text.textHeight/2 - 50;
					if (textOverlays.quad.y < textOverlays.quad.height){
						textOverlays.quad.visible = false;
						textOverlays.quad.y = textOverlays.quad.height;
					}
					
				break;
				case 7 :
				case 8 :
					textOverlays.title.text = title;
					textOverlays.text.text = text;
					textOverlays.text.height = textOverlays.text.textHeight + 10;

					var h:Number = textOverlays.title.textHeight + 40 + textOverlays.text.textHeight;
					textOverlays.title.y = textOverlays.pageBase.height/2 - h/2;
					textOverlays.text.y = textOverlays.pageBase.height/2 - h/2 + textOverlays.title.textHeight + 40;
					if (textOverlays.text.textHeight < textOverlays.text.height){
						textOverlays.text.height = textOverlays.text.textHeight + 10;
					}
						
				break;
				case 9 :
				case 10 :
				case 11 :
				case 12 :
					textOverlays.title.text = allText.substring(0,3).toUpperCase();;
					textOverlays.text.text = allText;
				break;
				case 13 :
				case 14 :
					try
					{
						textOverlays.mc.field.text = allText.split(/\s|\n/)[0];
						textOverlays.mc.field.height = textOverlays.mc.field.textHeight+5;
						textOverlays.mc.field.width = textOverlays.mc.field.textWidth+5;
						textOverlays.mc.width = 1150;
						textOverlays.mc.scaleY = textOverlays.mc.scaleX;
						var paragraphs:Array = allText.split("\n");
						textOverlays.text1.text = paragraphs.shift();
						textOverlays.text2.text = paragraphs.join("\n");
					} catch (e:Error) {}
					textOverlays.text1.y = textOverlays.mc.y + textOverlays.mc.field.textHeight*textOverlays.mc.scaleY;
					textOverlays.text2.y = textOverlays.text1.y + textOverlays.text1.textHeight + 50;
					textOverlays.text2.height = textOverlays.pageBase.height - (textOverlays.text2.y);
					
				break;
				case 15 :
					textOverlays.title.text = allText.substring(0,1).toUpperCase();;
					textOverlays.text.text = allText;
				break;
			}


		}
	}

}