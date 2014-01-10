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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TimerSemaphore 
	{
		protected var _lock:Boolean;
		protected var _timer:Timer;
	
		/**
		 * TimerSemaphore - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	time	time in ms
		 */
		public function TimerSemaphore(time:int) 
		{
			_timer = new Timer(time, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
		}
		
		protected function completeTimerHandler(e:TimerEvent):void 
		{
			_lock = false;
		}
		
		/**
		 * Function give acces only in some periodic time
		 * @return
		 */
		public function test():Boolean
		{
			if (!_lock)
			{
				_timer.reset();
				_timer.start();
				_lock = true;
				return true;
			}
			return false;
		}
		
		public function destroy():void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
			_timer = null;
		}
		
	}

}