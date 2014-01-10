/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-03-29 11:37</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.performance.benchmark 
{
	import flash.events.EventDispatcher;
	
	/** 
	* Dispatched when avarange fps is lower than threshold 'onValue' 
	**/
	[Event(name="joinThreshold", type="pl.asria.tools.performance.benchmark.BenchamrkThresholdEvent")]
	/** 
	* Dispatched when avarange fps is grower than threshold 'offValue' 
	**/
	[Event(name="partThreshold", type="pl.asria.tools.performance.benchmark.BenchamrkThresholdEvent")]
	/** 
	* Dispatched when treshold part or join 
	**/
	[Event(name="crossThreshold", type="pl.asria.tools.performance.benchmark.BenchamrkThresholdEvent")]
	/** 
	* Dispatched when threshold is part because avarange value is lower than 'fromValue'
	**/
	[Event(name="partThresholdDownside", type="pl.asria.tools.performance.benchmark.BenchamrkThresholdEvent")]
	/** 
	* Dispatched when threshold is part because avarange value is bigger than 'toValue'
	**/
	[Event(name="partThresholdUpside", type="pl.asria.tools.performance.benchmark.BenchamrkThresholdEvent")]
	public class BenchmarkThreshold extends EventDispatcher
	{
		private static const INSIDE:int = 1;
		private static const OUTSIDE:int = 0;
		private static const UNDEFINIED:int = -1;
		protected var _toValue:Number;
		protected var _fromValue:Number;
		protected var _insideRange:int = UNDEFINIED;
		/**
		 * BenchmarkThreshold - Treshlod for Benchamrk class
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param onValue - if <code>enabled == fale</code> and next measure value is lower than this value, then BanchmarkThreshold join enabled state, and dispatch BenchamrkThresholdEvent.JOIN_THRESHOLD
		 * @param offValue - if <code>enabled == true</code> and next measure value is grower than this value, then BanchmarkThreshold part enabled state, and dispatch BenchamrkThresholdEvent.PART_THRESHOLD
		 */
		public function BenchmarkThreshold(fromValue:Number, toValue:Number, insideRange:Boolean = false):void
		{
			_fromValue = fromValue;
			_toValue = toValue;
			_insideRange = insideRange ? INSIDE : OUTSIDE;
		}
		
		
		/**
		 * Check some measure of FPS and set state for BenchmarkThreshold
		 * @param	avarangeValue	current measure of avarange FPS 
		 * @return	enabled state
		 */
		public function checkJoin(avarangeValue:Number):Boolean
		{
			if (_insideRange != INSIDE)
			{
				if (avarangeValue <= _toValue && avarangeValue >= _fromValue)
				{
					_insideRange = INSIDE;
					dispatchEvent(new BenchamrkThresholdEvent(BenchamrkThresholdEvent.JOIN_THRESHOLD));
					return true;
				}
			}
			return false;
		}
		
		
		/**
		 * Check some measure of FPS and set state for BenchmarkThreshold
		 * @param	avarangeValue	current measure of avarange FPS 
		 * @return	enabled state
		 */
		public function checkPart(avarangeValue:Number):Boolean
		{
			if (_insideRange != OUTSIDE)
			{
				if (avarangeValue < _fromValue)
				{
					_insideRange = OUTSIDE;
					dispatchEvent(new BenchamrkThresholdEvent(BenchamrkThresholdEvent.PART_THRESHOLD_DOWNSIDE));
					
				}
				
				if (avarangeValue > _toValue)
				{
					_insideRange = OUTSIDE;
					dispatchEvent(new BenchamrkThresholdEvent(BenchamrkThresholdEvent.PART_THRESHOLD_UPSIDE));
					
				}
				
				if (_insideRange == OUTSIDE)
				{
					dispatchEvent(new BenchamrkThresholdEvent(BenchamrkThresholdEvent.PART_THRESHOLD));
					return true;
				}
			}
			return false;
		}
		/**
		 * Check some measure of FPS and set state for BenchmarkThreshold
		 * @param	avarangeValue	current measure of avarange FPS 
		 * @return	enabled state
		 */
		public function check(avarangeValue:Number):Boolean
		{
			if (_insideRange == UNDEFINIED)
			{
				if (!checkJoin(avarangeValue)) checkPart(avarangeValue);
			}
			else if(_insideRange == INSIDE)
			{
				checkPart(avarangeValue);
			}
			else
			{
				checkJoin(avarangeValue);
			}
			
			return false;
		}
		
		
		/**
		 * Empty method
		 */
		public function clean():void
		{
			
		}
		
		/**
		 * reset internal state of threshlod enable to false
		 */
		public function reset():void 
		{
			_insideRange = UNDEFINIED;
		}
		
		
		/**
		 * if <code>enabled == true</code> and next measure value is grower than this value, then BanchmarkThreshold part enabled state, and dispatch BenchamrkThresholdEvent.PART_THRESHOLD
		 */
		public function get fromValue():Number 
		{
			return _fromValue;
		}
		
		
		/**
		 * if <code>enabled == fale</code> and next measure value is lower than this value, then BanchmarkThreshold join enabled state, and dispatch BenchamrkThresholdEvent.JOIN_THRESHOLD
		 */
		public function get toValue():Number 
		{
			return _toValue;
		}
		
		public function set fromValue(value:Number):void 
		{
			_fromValue = value;
		}
		
		public function set toValue(value:Number):void 
		{
			_toValue = value;
		}
	}

}