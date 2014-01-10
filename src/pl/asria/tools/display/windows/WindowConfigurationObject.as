/**
* CHANGELOG:
*
* 2011-11-09 14:42: Create file
*/
package pl.asria.tools.display.windows 
{
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class WindowConfigurationObject
	{
		private var _title:String = "";
		private var _position:String = WindowContentAlign.TOP_LEFT;
		private var _needInited:Boolean = false;
		private var _visibleCloseButton:Boolean = true;
		private var _visiblePinButton:Boolean = true;
		private var _visibleMinimalizeButton:Boolean = true;
		public function WindowConfigurationObject() 
		{
		}
		
		
		[Inspectable (name = "position", variable = "position", type = "String", defaultValue = 'topLeft', category = 'Other', enumeration= 'topLeft,topRight,topMiddle,middleLeft,middleRight,center,bottomLeft,bottomRight,bottomMiddle')]
		public function get position():String 
		{
			return _position;
		}
		
		public function set position(value:String):void 
		{
			_position = value;
		}
		
		[Inspectable (name = "title", variable = "title", type = "String", defaultValue = 'Title Window', category = 'Other')]
		public function get title():String 
		{
			
			return _title;
		}
		
		public function set title(value:String):void 
		{
			_title = value;
		}
		
		[Inspectable (name = "Init after added To Stage", variable = "needInited", type = "Boolean", defaultValue = 'false', category = 'Other')]
		public function get needInited():Boolean 
		{
			return _needInited;
		}
		
		public function set needInited(value:Boolean):void 
		{
			_needInited = value;
		}
		
		public function get visibleMinimalizeButton():Boolean 
		{
			return _visibleMinimalizeButton;
		}
		
		public function set visibleMinimalizeButton(value:Boolean):void 
		{
			_visibleMinimalizeButton = value;
		}
		
		public function get visiblePinButton():Boolean 
		{
			return _visiblePinButton;
		}
		
		public function set visiblePinButton(value:Boolean):void 
		{
			_visiblePinButton = value;
		}
		
		public function get visibleCloseButton():Boolean 
		{
			return _visibleCloseButton;
		}
		
		public function set visibleCloseButton(value:Boolean):void 
		{
			_visibleCloseButton = value;
		}
		
	}

}