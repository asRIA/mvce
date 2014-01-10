/**
* CHANGELOG:
*
* 2011-11-08 17:32: Create file
*/
package pl.asria.tools.factory 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import pl.asria.tools.display.IWorkspace;
	import pl.asria.tools.display.windows.Window;
	import pl.asria.tools.display.windows.WindowConfigurationObject;
	import pl.asria.tools.display.windows.WindowContent;
	import pl.asria.tools.display.windows.WindowError;
	import pl.asria.tools.factory.Factory;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class WindowsFactory 
	{
		private static const _dWindwos:Dictionary = new Dictionary(false);
		static private var _class:Class;
		static private var contener:DisplayObject;
		public static function destroyWindow(id:String):void
		{
			if (_dWindwos[id])
				delete _dWindwos[id];
		}
		
		public static function init(classWindow:Class, contener:DisplayObject):void
		{
			if (!contener) throw new WindowError(WindowError.CONTENER_NULL);
			WindowsFactory.contener = contener;
			_class = classWindow;
		}
		
		public static function getWindow(id:String, windowProperties:WindowConfigurationObject = null):Window
		{
			if (!_dWindwos[id])
			{
				var window:Window = new _class() as Window;
				var content:Sprite = Factory.generateObejct(id);
				if (content)
				{
					window.setContent(content, windowProperties);
					_dWindwos[id] = window;
				}
			}
			return _dWindwos[id];
		}
		
	}

}