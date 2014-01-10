/**
 * CHANGELOG:
 *
 * <ul>
 * <li><b>1.0</b> - 2012-06-20 11:44</li>
 *	<ul>
 *		<li>Create file</li>
 *	</ul>
 * </ul>
 * @author Piotr Paczkowski - kontakt@trzeci.eu
 */
package pl.asria.tools.performance.benchmark
{
	import flash.events.Event;
	
	/**
	 * Dispatched when seqwence level is changed
	 **/
	[Event(name="eventChangeLevel",type="flash.events.Event")]
	/**
	 * Dispatched when ...
	 **/
	[Event(name="eventMeasure",type="flash.events.Event")]
	
	public class SeqwenceBenchmark extends Benchmark
	{
		/**  **/
		public static const EVENT_CHANGE_LEVEL:String = "eventChangeLevel";
		protected var _currentlevel:int = -1;
		protected var _maxLevels:int = -1;
		protected var _currentThreshold:BenchmarkThreshold;
		protected var _intiLevel:int;
		
		/**
		 * SeqwenceBenchmark -
		 * @usage -
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SeqwenceBenchmark(intiLevel:int, id:String, timeMeasure:int)
		{
			super(id, timeMeasure)
			_intiLevel = intiLevel;
		
		}
		
		public override function update(timeOffset:int):void
		{
			_countFrames++;
			_measureOffset -= timeOffset;
			if (_measureOffset < 0)
			{
				// get avarange fps
				_avarangeFPS = (_countFrames * 1000) / _timeMeasure;
				//trace("2:BENCHMARK(" + _id + "): " + Math.round(_avarangeFPS * 1000) / 1000 + "fps, measured in " + (_timeMeasure / 1000) + "s");
				_countFrames = 0;
				
				// set new measure point 
				_measureOffset = _timeMeasure;
				
				// check join threshlods
				_currentThreshold.check(_avarangeFPS); // dispatch events
				dispatchEvent(new Event(EVENT_MEASURE));
			}
		}
		
		public override function registerThreshold(threshold:BenchmarkThreshold):Boolean
		{
			var result:Boolean = super.registerThreshold(threshold);
			if (result)
				_maxLevels++;
			return result
		}
		
		public override function unregisterThreshold(threshold:BenchmarkThreshold):Boolean
		{
			var result:Boolean = super.unregisterThreshold(threshold)
			if (result)
				_maxLevels--;
			return result
		
		}
		
		public function get currentlevel():int
		{
			return _currentlevel;
		}
		
		public function set currentlevel(value:int):void
		{
			value = Math.min(_maxLevels, value);
			value = value < 0 ? 0 : value;
			
			if (value != _currentlevel)
			{
				_currentlevel = value;
				_intiLevel = value;
				if (_currentThreshold)
				{
					_currentThreshold.reset();
					_currentThreshold.removeEventListener(BenchamrkThresholdEvent.PART_THRESHOLD_DOWNSIDE, partThresholdHandler)
					_currentThreshold.removeEventListener(BenchamrkThresholdEvent.JOIN_THRESHOLD, joinThresholdHandler)
					_currentThreshold = null;
				}
				_currentThreshold = _vThresholds[_currentlevel];
				_currentThreshold.reset();
				_currentThreshold.addEventListener(BenchamrkThresholdEvent.PART_THRESHOLD_DOWNSIDE, partThresholdHandler)
				_currentThreshold.addEventListener(BenchamrkThresholdEvent.JOIN_THRESHOLD, joinThresholdHandler)
				dispatchEvent(new Event(EVENT_CHANGE_LEVEL));
			}
		}
		
		protected function joinThresholdHandler(e:BenchamrkThresholdEvent):void
		{
			currentlevel++;
		}
		
		protected function partThresholdHandler(e:BenchamrkThresholdEvent):void
		{
			currentlevel--;
		}
		
		public function get currentThreshold():BenchmarkThreshold
		{
			return _currentThreshold;
		}
		
		public function set intiLevel(value:int):void 
		{
			_intiLevel = value;
		}
		
		public override function start():void
		{
			super.start();
			currentlevel = _intiLevel; // level on init, or last setted level
		}
	
	}

}