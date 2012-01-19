package base
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import dupin.display.drawRect;
	import com.adobe.utils.StringUtil;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

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
		  	setTextLayout(loaderInfo.parameters['text_layout'] || 15);
			
		  	if (ExternalInterface.available)
				ExternalInterface.addCallback("setTextLayout", setTextLayout);

			stage.addEventListener(Event.RESIZE, onResize);
			onResize()
		}

		protected function onResize(e:Event=null):void
		{
			if (textOverlays.width / textOverlays.height > stage.stageWidth / stage.stageHeight) {
				textOverlays.width = stage.stageWidth;
				textOverlays.scaleY = textOverlays.scaleX;
			} else 
			{
				textOverlays.height = stage.stageHeight;
				textOverlays.scaleX = textOverlays.scaleY;
			}

			textOverlays.x = stage.stageWidth/2 - textOverlays.width/2;
			textOverlays.y = stage.stageHeight/2 - textOverlays.height/2;
		}

		//Set text disposition
		protected function setTextLayout(number:uint):void
		{
			trace("changing layout to: " + number);
			textOverlays.gotoAndStop(number);
			
			var allText:String = StringUtil.trim(title + "\n" + text);
			switch (number)
			{
				case 2 :
					textOverlays.text.text = allText;
				break;
				case 3 :
				case 4 :
					var words:Array = allText.split(" ");
					if (words.length > 0)
						textOverlays.top.text = words.shift();
					if (words.length > 0) {
						var last:String = words.pop();
						textOverlays.text.text = words.join(" ");
						words = [last];
					}
					if (words.length > 0)
						textOverlays.bottom.text = words.join(" ");
					
					textOverlays.top.y = textOverlays.text.y + textOverlays.text.height/2 - textOverlays.text.textHeight/2 - textOverlays.top.textHeight - 50;
					textOverlays.bottom.y = textOverlays.text.y + textOverlays.text.height/2 + textOverlays.text.textHeight/2 + 50;
					
				break;
				case 5 :
				case 6 :
					
					textOverlays.text.text = allText;
					textOverlays.quad.y = textOverlays.text.height/2 - textOverlays.text.textHeight/2 - 50;
					
				break;
				case 7 :
				case 8 :
					textOverlays.title.text = title;
					textOverlays.text.text = text;

					var h:Number = textOverlays.title.textHeight + 40 + textOverlays.text.textHeight;
					textOverlays.title.y = textOverlays.pageBase.height/2 - h/2;
					textOverlays.text.y = textOverlays.pageBase.height/2 - h/2 + textOverlays.title.textHeight + 40;
					if (textOverlays.text.textHeight < textOverlays.text.height){
						textOverlays.text.height = textOverlays.text.textHeight + 10;
						drawRect(textOverlays, textOverlays.text.x, textOverlays.text.y, textOverlays.text.width, textOverlays.text.height)
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
					textOverlays.title.text = allText.substring(0,3).toUpperCase();;
					try
					{
						var paragraphs:Array = allText.split("\n");
						textOverlays.text1.text = paragraphs.shift();
						textOverlays.text2.text = paragraphs.join("\n");
					} catch (e:Error) {}
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