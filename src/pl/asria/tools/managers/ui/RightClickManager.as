package pl.asria.tools.managers.ui 
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import pl.asria.tools.event.display.ui.RightClickEvent;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public final class RightClickManager 
	{
		private static var _stage:Stage;
		static private var _time:int = -1;
		
		/**
		 * Register external interface using rightClick.js
		 * @param	stage
		 * @return	true if this is web browser application, false in other case
		 */
		public static function register(stage:Stage,addInterface:Boolean = true):Boolean
		{
			if(_stage) throw new Error("Only one time can be register stage");
			_stage = stage;
			var _return:Boolean = true;
			if (addInterface)
			{
				try
				{
					ExternalInterface.addCallback("rightClick", handleRightClick);
				}
				catch (e:Error)
				{
					trace("External interface not available");
					_return = false;
				}
			}
			
			return _return;
			
		}
		
		static public function handleRightClick():void 
		{
			var _currTime:int = getTimer();
			if (_currTime - _time < 200) return;
			_time = _currTime;
			
			var objects:Array = _stage.getObjectsUnderPoint(new Point(_stage.mouseX, _stage.mouseY));
			if(objects.length)IEventDispatcher(objects[objects.length-1]).dispatchEvent(new RightClickEvent(RightClickEvent.RIGHT_CLICK,true,false, objects[objects.length-1].mouseX, objects[objects.length-1].mouseY));
			//for (var i:int = 0; i < objects.length; i++) 
			//{
				//if (objects[i] is EventDispatcher || objects[i] is IEventDispatcher)
				//{
					//IEventDispatcher(objects[i]).dispatchEvent(new RightClickEvent(RightClickEvent.RIGHT_CLICK,true,false, objects[i].mouseX, objects[i].mouseY));
				//}
			//}
		}
		public function RightClickManager() 
		{
			throw new Error("Cannot to be instanted");
		}
		
	}

}