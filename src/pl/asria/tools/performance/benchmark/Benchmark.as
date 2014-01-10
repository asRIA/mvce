/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-03-29 11:09</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.performance.benchmark 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import pl.asria.tools.managers.IJugglable;
	import pl.asria.tools.managers.SEnterFrameJuggler;
	
	/** 
	* Dispatched when is new measure process, after check every internal - register thresholds 
	**/
	[Event(name="eventMeasure", type="flash.events.Event")]
	public class Benchmark extends EventDispatcher implements IJugglable
	{
		/** Dispatched after every avarange measurement **/
		public static const EVENT_MEASURE:String = "eventMeasure";
		
		protected var _timeMeasure:int;
		protected var _id:String;
		protected var _countFrames:int = 0;
		protected var _measureTimestamp:int = 0;
		protected var _avarangeFPS:Number = 0;
		protected var _enabled:Boolean = false;
		protected var _measureOffset:int = 0;
		protected var _vThresholds:Vector.<BenchmarkThreshold> = new Vector.<BenchmarkThreshold>();
		/**
		 * Benchmark - Classs to analize framerate of main app
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	id - name of benchmark
		 * @param	timeMeasure - time in ms for every measure 
		 */
		public function Benchmark(id:String, timeMeasure:int) 
		{
			_timeMeasure = timeMeasure;
			_id = id;
			SEnterFrameJuggler.register(this);
		}
		
		
		/* INTERFACE pl.asria.tools.managers.IJugglable */
		
		public function update(timeOffset:int):void 
		{
			_countFrames++;
			_measureOffset -= timeOffset;
			if (_measureOffset < 0)
			{
				// get avarange fps
				_avarangeFPS = (_countFrames * 1000) / _timeMeasure;
				//trace("2:BENCHMARK("+_id+"): "+Math.round(_avarangeFPS*1000)/1000+"fps, measured in "+(measureTime/1000) + "s");
				
				_countFrames = 0;
				
				// set new measure point 
				_measureOffset = _timeMeasure;
				
				// check join threshlods
				for (var i:int = 0, length:int = _vThresholds.length ; i < length; i++) 
				{
					_vThresholds[i].check(_avarangeFPS);
				}
				
				dispatchEvent(new Event(EVENT_MEASURE));
				
			}
		}
		
		public function get enableJuggler():Boolean 
		{
			return _enabled;
		}
		
		/**
		 * Id of menchmark
		 */
		public function get id():String 
		{
			return _id;
		}
		
		
		/**
		 * Last avarange FPS, 0 if measurement is not completed
		 */
		public function get avarangeFPS():Number 
		{
			return _avarangeFPS;
		}
		
		
		
		/**
		 * Register threshold, since this moment after next avarange FPS measurement, this threshold will be checked
		 * @param	threshold
		 */
		public function registerThreshold(threshold:BenchmarkThreshold):Boolean
		{
			if (_vThresholds.indexOf(threshold) < 0)
			{
				_vThresholds.push(threshold);
				return true;
			}
			
			return false
		}
		
		/**
		 * Remove from queue threshold
		 * @param	threshold
		 */
		public function unregisterThreshold(threshold:BenchmarkThreshold):Boolean
		{
			var index:int = _vThresholds.indexOf(threshold) 
			if (index >= 0)
			{
				_vThresholds.splice(index, 1);
				return true;
			}
			return false;
		}
		
		/**
		 * revent state to clean one.
		 */
		public function clean():void
		{
			stop();
			_vThresholds = null;
			_enabled = false;
			_avarangeFPS = 0;
			_measureOffset = 0;
			SEnterFrameJuggler.unregister(this);
		}
		
		/**
		 * Start benchmark
		 */
		public function start():void
		{
			//trace( "Benchmark.start", _id);
			_measureOffset = _timeMeasure; // lock after pause/play swith offset
			_enabled = true;
			
		}
		
		
		/**
		 * Pause benchmark
		 */
		public function stop():void
		{
			//trace( "Benchmark.stop", _id );
			_enabled = false;
		}
		
		/**
		 * Reset all theshlods value please be casefull, can makes troubles
		 */
		public function resetThreshlods():void 
		{
			if (_vThresholds)
			{
				for (var i:int = 0, len:int = _vThresholds.length; i < len; i++) 
				{
					_vThresholds[i].reset();
				}
			}
		}
	}

}