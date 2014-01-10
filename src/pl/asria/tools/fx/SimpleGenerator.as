/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-26 18:54</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.fx 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/** 
	* Dispatched when new particle is generated 
	**/
	[Event(name="added", type="flash.events.Event")]
	public class SimpleGenerator extends EventDispatcher
	{
		protected var _currentDelay:int;
		protected var _randomThreshold:Number;
		protected var _generatedCount:Number;
		protected var _maxCountToGenerate:int;
		protected var _currentShowMax:int;
		protected var _delay:int;
		protected var _currentDisplayed:int = 0;
		protected var _holded:Boolean;
		protected var _enabled:Boolean;
	
		/**
		 * SimpleGenerator - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SimpleGenerator(maxShowInTheSameTime:int, maxCountToGenerate:int = 10,  delay:int = 1, randomThreshold:Number = 0) 
		{
			//_active = true;
			_generatedCount = 0;
			_maxCountToGenerate = maxCountToGenerate;
			delay = delay < 0 ? 0.5 : delay;
			randomThreshold = randomThreshold > 0.5 ? 0.5 : randomThreshold;
			randomThreshold = randomThreshold < 0 ? 0 : randomThreshold;
			_randomThreshold = randomThreshold;
			_delay = delay;
			_currentShowMax = maxShowInTheSameTime;
			_enabled = false;
			generateNewTimer();
		}

		public function start():void 
		{
			_enabled = true;
		}
		public function stop():void 
		{
			_enabled = false;
		}
		
		protected function generateNewTimer():void 
		{
			_holded = false;
			_currentDelay =  (_delay + (0.5 - Math.random()) * _delay * _randomThreshold);
		}
		
		public function update(timeOffset:int):void
		{
			if (!_holded && _enabled)
			{
				_currentDelay -= timeOffset;
				if (_currentDelay < 0) completeTimerHandler();
				
			}
		}
		
		protected function completeTimerHandler():void 
		{
			if (_currentDisplayed < _currentShowMax)
			{
				generateParticle();
			}
			else
			{
				_holded = true;
			}
		}
		
		public function removeAllDisplayed():void
		{
			if (_holded) generateNewTimer();
			_currentDisplayed = 0;
		}
		
		public function removeDisplayed():void
		{
			if (_holded) generateNewTimer();
			_currentDisplayed--;
		}
		
		
		protected function generateParticle():void 
		{
			if (_generatedCount < _maxCountToGenerate)
			{
				dispatchEvent(new Event(Event.ADDED));
				_currentDisplayed++;
				_generatedCount++;
				generateNewTimer();
			}
		}
		
	}

}