/**
* CHANGELOG:
*
* 2011-11-08 16:02: Create file
*/
package pl.asria.tools.display.windows 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class TopBarWindow extends Sprite
	{
		public var label:TextField;
		public var minimalize:Sprite;
		public var close:Sprite;
		public var background:Sprite;
		public var pin:Sprite;
		
		public function TopBarWindow() 
		{
			buttonMode = true;
			doubleClickEnabled = false;
			close.buttonMode = true;
			minimalize.buttonMode = true;
			if(pin)pin.buttonMode = true;
			addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
		}
		
		private function doubleClickHandler(e:MouseEvent):void 
		{
			minimalize.dispatchEvent(new MouseEvent(MouseEvent.CLICK,false));
		}
		
		override public function get width():Number 
		{
			return background.width;
		}
		
		override public function set width(value:Number):void 
		{
			background.width = value;
			close.x = value - close.width/2 - 6;
			minimalize.x = close.x - close.width / 2 - minimalize.width / 2 - 3 ;
			if(pin) pin.x = minimalize.x - minimalize.width / 2 - pin.width / 2 - 3 ;
		}
		
	}

}