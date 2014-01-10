/**
* CHANGELOG:
*
* 2011-11-08 17:40: Create file
*/
package pl.asria.tools.display.windows 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import pl.asria.tools.display.IWorkspace;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public dynamic class WindowContent extends MovieClip implements IWorkspace
	{
		public var workspace:Sprite;
		private var _window:Window;
		public var settings:WindowConfigurationObject;
		public function WindowContent() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedHandelr);
		}
		
		private function addedHandelr(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedHandelr);
			if (workspace) workspace.visible = false;
			if (settings && window)
			{
				window.title = settings.title;
				window.contentAlign = settings.position;
			}
		}
		
		/* INTERFACE pl.asria.tools.display.IWorkspace */
		
		public function getWorkspace():Rectangle 
		{
			return workspace.getBounds(this);
		}
		
		public function get window():Window 
		{
			return _window;
		}
		
		public function set window(value:Window):void 
		{
			_window = value;
			if (settings)
			{
				window.title = settings.title;
				window.contentAlign = settings.position;
			}
		}
		
	}

}