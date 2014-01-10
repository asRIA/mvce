/**
* CHANGELOG:
*
* 2011-11-24 18:37: Create file
*/
package pl.asria.tools.managers.ui 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="idleJoin", type="pl.asria.tools.managers.ui.IdleManagerEvent")]
	[Event(name="wakeUp", type="pl.asria.tools.managers.ui.IdleManagerEvent")]
	/** 
	* Dispatched when idle manager is still in idle mode 
	**/
	[Event(name="idleRefresh", type="pl.asria.tools.managers.ui.IdleManagerEvent")]
	public final class IdleManager extends EventDispatcher
	{
		private var _timer:Timer;
		private var _idle:Boolean;
		
		/**
		 * ...
		 * @author Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	stage
		 * @param	idle	time idle in [s]
		 */
		public function IdleManager(stage:Stage, idle:Number) 
		{
			_timer = new Timer(idle*1000);
			_timer.addEventListener(TimerEvent.TIMER, idleAlert);
			_timer.start();
			stage.addEventListener(MouseEvent.MOUSE_MOVE, triggerHadnler,false,int.MAX_VALUE,true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, triggerHadnler,false,int.MAX_VALUE, true);
		}
		
		private function idleAlert(e:TimerEvent):void 
		{
			if (!_idle) dispatchEvent(new IdleManagerEvent(IdleManagerEvent.IDLE_JOIN));
			else dispatchEvent(new IdleManagerEvent(IdleManagerEvent.IDLE_REFRESH));
			_idle = true;
		}
		
		private function triggerHadnler(e:Event):void 
		{
			_timer.reset();
			_timer.start();
			if (_idle) dispatchEvent(new IdleManagerEvent(IdleManagerEvent.WAKE_UP));
			_idle = false;
		}

	}

}