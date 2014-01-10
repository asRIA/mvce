package pl.asria.tools.managers.focus 
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class FocusManagerGrup extends EventDispatcher
	{
		private var _type:String;
		
		/* TODO 
		 * ring focus
		 * max focus value
		 */
		
		private var _vContains:Vector.<IFocusManagerObject> = new Vector.<IFocusManagerObject>();
		private var _currentFocused:Vector.<IFocusManagerObject> = new Vector.<IFocusManagerObject>();
		
		public function FocusManagerGrup(type:String, maxFocused:uint) 
		{
			_type = type;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function push(object:IFocusManagerObject):uint
		{
			return _vContains.push(object);
		}
		
		public function focusOn(obejct:IFocusManagerObject):void
		{
			
		}
	}

}