package pl.asria.tools.performance 
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class WeakReference 
	{
		protected var __keepReftimer:Timer;
		private var _ref : Dictionary;
		private var _keepRef:Object;
		/**
		 * The constructor - creates a weak reference.
		 * 
		 * @param obj the object to create a weak reference to
		 */
		public function WeakReference(reference:*) 
		{
			_ref = new Dictionary( true );
			_ref[reference] = 1;
		}
		
		
		/**
		 * To get a strong reference to the object.
		 * 
		 * @return a strong reference to the object or null if the
		 * object has been garbage collected
		 */
		public function get $() : *
		{
			for ( var item:* in _ref )
			{
				return item;
			}
			return null;
		}
		
		/**
		 * Force keept alive reverence
		 * @param	time in ms. If less than 0, then keep reference always. Can be overrided by keepAlive(0)
		 */
		public function keepAlive(time:int):void
		{
			_keepRef = _keepRef || $;
			if (__keepReftimer)
			{
				__keepReftimer.stop();
				__keepReftimer.removeEventListener(TimerEvent.TIMER_COMPLETE, releaseKeeperReferneceHandler);
			}
			
			if (time >= 0)
			{
				//__keepReftimer = new Timer(time, 1);
				__keepReftimer = new Timer(5000, 1);
				__keepReftimer.addEventListener(TimerEvent.TIMER_COMPLETE, releaseKeeperReferneceHandler, false, 0, true);
				__keepReftimer.start();
			}
		}
		
		protected function releaseKeeperReferneceHandler(e:TimerEvent):void 
		{
			__keepReftimer.stop();
			__keepReftimer.removeEventListener(TimerEvent.TIMER_COMPLETE, releaseKeeperReferneceHandler);
			__keepReftimer = null;
			_keepRef = null;
		}
	}

}
