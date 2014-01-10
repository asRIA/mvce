/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-03-21 16:56</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	public class TextFieldUtil 
	{
	
		/**
		 * TextFieldUtil - Utils to management textfields
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function TextFieldUtil() 
		{
			
		}
		
		public static function autoSize(tf:TextField, maxHeight:Number = -1, maxWidth:Number = -1,fontRatio:Number = 1.3):TextField
		{
			if (!tf || tf.text.length == 0) return tf;
			//tf.multiline = true;
			var settings:Object = XML.settings;
			var format:TextFormat = tf.defaultTextFormat;
			XML.ignoreWhitespace = true;
			XML.ignoreComments = true;
			XML.prettyPrinting = false;
			XML.prettyIndent = 0;
			
			while(!checkFitPrecize(tf))
			{
				var dirty:Boolean = false;
				if(int(format.size) > 1) 
				{
					format.size = int(format.size) - 1;
					dirty = true;
				}
				var xml:XML = XML("<text>"+tf.htmlText+"</text>");
				tf.text = "";
				for each (var font:XML in xml..FONT) 
				{
					var size:int = int(font.@SIZE);
					if(size > 1) 
					{
						font.@SIZE = size-1;
						dirty = true;
					}
				}
				var text:String = xml.children().toXMLString();
				text = text.split("\n").join("");
				text = text.split("\r").join("");
				tf.htmlText = text;
				
				if(!dirty) break;
			}
			tf.defaultTextFormat = format;
			XML.setSettings(settings);
			return tf;
		}
		
		
		
		/**
		 * Realy importand to use this before attach other text to object
		 * @param	textFiled
		 * @param	fixEmbeding
		 * @param	fixClicable
		 * @return
		 */
		public static function fixEmbedingAndClicable(textFiled:TextField, fixEmbeding:Boolean = true, fixClicable:Boolean = true):TextField
		{
			if (!textFiled) 
				return textFiled;
			//textFiled.multiline = true;
			// flash hax10r
			if (fixEmbeding) textFiled.defaultTextFormat = textFiled.getTextFormat();
			if (fixClicable) textFiled.mouseEnabled = textFiled.mouseWheelEnabled = false;
			
			return textFiled;
		}
		
		/**
		 * Realy importand to use this before attach other text to object
		 * @param	textFiled
		 * @param	fixEmbeding
		 * @param	fixClicable
		 * @return
		 */
		public static function fixEmbedingAndClicableAutoSize(textFiled:TextField, fixEmbeding:Boolean = true, fixClicable:Boolean = true):TextField
		{
			if (textFiled)  textFiled.addEventListener(Event.EXIT_FRAME, onEnterFrame);
			function onEnterFrame(e:Event):void 
			{	
				textFiled.removeEventListener(Event.EXIT_FRAME, onEnterFrame);
				autoSize(textFiled);
			}
			return fixEmbedingAndClicable(textFiled, fixEmbeding, fixClicable);;
		}
		
		public static function getBoundsPrecize(tf:TextField):Rectangle 
		{
			var mHeight:Number = tf.height/tf.scaleY;
			//var mWidth:Number = tf.width/tf.scaleX;
			tf.height = mHeight + 256;
			//tf.width = mWidth + 256;
			var result:Rectangle;
			for (var i:int = 0; i<tf.length; i++)
			{
				var rect:Rectangle = tf.getCharBoundaries(i);
				if (!rect) continue;
				if (!result) result = rect;
				else result = result.union(rect);
			}
			tf.height = mHeight;
			//tf.width = mWidth;
			return result;
		}
		
		public static function checkFitPrecize(textField:TextField):Boolean
		{
			var bounds:Rectangle = getBoundsPrecize(textField);
			if (!bounds) return true;
			
			var precize:Number = 2;
			var precizeDim:Number = 2.1;
			//return (bounds.width / textField.scaleX >= bounds.width - 4)
				//&& (bounds.height / textField.scaleY >= bounds.height - 4);
			
			return bounds.x >=precize 
				&& bounds.y >=precize 
				&& (textField.width / textField.scaleX - bounds.left)>=precize 
				&& (textField.height / textField.scaleY - bounds.bottom)>=precizeDim
		}
		public static function breakeAppart(tf:TextField):Array
		{
			var result:Array = [];
			var mHeight:Number = tf.height/tf.scaleY;
			tf.height = 1000;
			for (var i:int = 0; i<tf.length; i++)
			{
				var rect:Rectangle = tf.getCharBoundaries(i);
				if (!rect) continue;
				var node:Object = { };
				var line:int = tf.getLineIndexOfChar(i);
				//var tfm:TextLineMetrics = tf.getLineMetrics(line);
				node.character = tf.text.charAt(i);
				node.line = line;
				node.rectangle = rect;
				node.textFormat = tf.getTextFormat(i, i);
				result.push(node);
			}
			
			tf.height = mHeight;
			return result;
		}
	}

}