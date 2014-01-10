/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-11 09:51</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.mouse 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	public class MouseManager 
	{
	
		private static const _lut:Dictionary = new Dictionary(true)
		protected static var _globalType:String;
		protected static var _pending:String;
		/**
		 * MouseManager - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function MouseManager() 
		{
			
		}
		
		public static function link(displayObject:DisplayObject, type:String):void
		{
			if (displayObject)
			{
				if (!_lut[displayObject])
				{
					displayObject.addEventListener(MouseEvent.ROLL_OUT, rollOutHanndler, false, int.MAX_VALUE, true)
					displayObject.addEventListener(MouseEvent.ROLL_OVER, rollOverHanndler, false, int.MAX_VALUE, true)
				}
				_lut[displayObject] = type;
			}
			
		}
		
		protected static function rollOverHanndler(e:MouseEvent):void 
		{
			if (_globalType)
			{
				_pending = _lut[e.currentTarget];
			}
			else
			{
				Mouse.cursor = _lut[e.currentTarget];
			}
		}
		
		protected static function rollOutHanndler(e:MouseEvent):void 
		{
			if (_globalType)
			{
				_pending =  MouseCursors.AUTO;
			}
			else
			{
				Mouse.cursor =  MouseCursors.AUTO;
			}
		}
		
		public static function setGlobal(type:String):void
		{
			_globalType = type;
		}
		
		public static function resetGlobal():void
		{
			_globalType = null;
			Mouse.cursor = _pending;
			_pending = null;
		}
		
		public static function unlink(displayObject:Sprite):void 
		{
			if (displayObject)
			{
				if (_lut[displayObject])
				{
					displayObject.removeEventListener(MouseEvent.ROLL_OUT, rollOutHanndler);
					displayObject.removeEventListener(MouseEvent.ROLL_OVER, rollOverHanndler);
					delete _lut[displayObject]
				}
			}
		}
	}

}