package pl.asria.tools.managers 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Michal Mazur
	 * @author Piotr Paczkowski
	 */
	/** 
	* Dispatched OnChange basic status
	**/
	[Event(name="change", type="flash.events.Event")]
	public class SimpleSemaphore extends EventDispatcher
	{
		private var _lockCount:int = 0;
		
		public function lock():Boolean
		{
			lockCount++;
			return true;
		}
		
		public function unlock():void
		{
			lockCount--;
		}
		
		public function forceUnlock():void
		{
			lockCount = 0;
		}
		
		public function get isUnlocked():Boolean
		{
			return _lockCount == 0;
		}
		
		public function get isLocked():Boolean
		{
			return _lockCount > 0;
		}
		
		private function set lockCount(value:int):void 
		{
			if(_lockCount != value)
			{
				var _wasLocked:Boolean = isLocked;
				_lockCount = value;
				
				if(isLocked !=_wasLocked)
				{
					dispatchEvent(new Event(Event.CHANGE));
				}
			}
		}
		
		private function get lockCount():int 
		{
			return _lockCount;
		}
		
		public function SimpleSemaphore() 
		{
			
		}
		
	}

}