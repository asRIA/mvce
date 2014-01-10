/**
 * CHANGELOG:
 *
 * 2011-11-22 11:53: Create file
 */
package pl.asria.tools.fx
{
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="complete",type="flash.events.Event")]
	
	public class BlinkController extends EventDispatcher
	{
		private var target:DisplayObject;
		private var cleanAfterComplete:Boolean;
		private var _countCycles:int;
		private var time:Number;
		private var tweenData:Object;
		private var _tweenObject:TweenMax;
		private var _pendingPause:Boolean;
		
		
		/**
		 * Make $storeState after creation. To get fx effect please use $shake method
		 * @param	target
		 * @param	time	Time of the Shake effect
		 * @param	countCycles	count of cycles
		 * @param	tweenTargetState	
		 * @param	cleanAfterComplete	if <code>true</code> then clean this object after complete shake otherweise references are stillin memory.
		 */
		public function BlinkController(target:DisplayObject, time:Number, countCycles:int, tweenTargetState:Object, cleanAfterComplete:Boolean = false)
		{
			this.target = target;
			this.tweenData = tweenTargetState;
			this.time = time;
			this._countCycles = countCycles;
			this.cleanAfterComplete = cleanAfterComplete;
			
			
			// preparateTweenObject
			delete tweenData.onComplete;
			delete tweenData.onCompleteParams;
			tweenData.yoyo = false;
			tweenData.repeat  = -1;
			//tweenData.onComplete = stopAnimationHandler;
			
			tweenData.paused = true;
			_tweenObject = TweenMax.to(target, time / 2, tweenData );
			delete tweenData.paused;
		}
		
		public function $clean():void
		{
			target = null;
			target = null;
			
			//_tweenObject.revent();
			_tweenObject.currentTime = 0;
			_tweenObject.kill();
			_tweenObject = null;
		}
		
		public function $start():BlinkController
		{
			if(_tweenObject.paused) playAnimationLoop();
			return this;
		}
		
		private function stopAnimationHandler():void 
		{
			if (_countCycles)
			{
				if (_pendingPause)
				{
					_tweenObject.pause();
					_pendingPause = false;
				}
				else 
				{
					playAnimationLoop();
				}
			}
			else
			{
				dispatchEvent(new Event(Event.COMPLETE));
				if(cleanAfterComplete) $clean();
			}
		}
		
		private function playAnimationLoop():void 
		{
			_countCycles--;
			_tweenObject.play();
		}
		
		public function $stop():BlinkController
		{
			//_tweenObject.
			if (cleanAfterComplete)
			{
				$clean();
			}
			return this;
		}
		
		public function $stopAfterCycle():BlinkController
		{
			_countCycles = 0;
			return this;
		}
		
		public function $pause():BlinkController
		{
			_tweenObject.pause();
			return this;
		}
		
		public function $pauseAfterCycle():BlinkController
		{
			_pendingPause = true;
			return this;
		}
		
		public function get countCycles():int 
		{
			return _countCycles;
		}
		
		public function set countCycles(value:int):void 
		{
			_countCycles = value;
		}

	
	}

}