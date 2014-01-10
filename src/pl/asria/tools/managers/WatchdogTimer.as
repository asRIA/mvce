/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-13 08:33</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import pl.asria.tools.data.ICleanable;
	
	/** 
	* Dispatched after watchodg time
	**/
	[Event(name="complete", type="flash.events.Event")]
	public class WatchdogTimer extends SimpleSemaphore implements ICleanable
	{
		protected var _lock:Boolean;
		protected var _timer:Timer;
		protected var _time:int;
	
		/**
		 * TimerSemaphore - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	time	time in ms
		 */
		public function WatchdogTimer(time:int, autoStart:Boolean = true) 
		{
			this.time = time;
			if (autoStart) touch();
		}
		
		public function start():void
		{
			touch();
		}
		public function touch():void 
		{
			if (_timer)
			{
				_timer.reset();
				_timer.start();
			}
		}
		
		protected function completeTimerHandler(e:TimerEvent):void 
		{
			if(isUnlocked) dispatchEvent(new Event(Event.COMPLETE))
		}
		
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
				_timer = null;
			}
		}
		
		public function get time():int 
		{
			return _time;
		}
		
		/**
		 * Reset watchtgo also [ms]
		 */
		public function set time(value:int):void 
		{
			_time = value;
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
				_timer = null;
			}
			_timer = new Timer(_time, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
		}
	}

}