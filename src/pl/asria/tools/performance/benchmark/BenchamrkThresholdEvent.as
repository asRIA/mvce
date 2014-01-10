/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-03-29 11:38</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.performance.benchmark 
{
	import flash.events.Event;
	
	public class BenchamrkThresholdEvent extends Event 
	{
		/** avarange FPS is lower than some threshold **/
		public static const JOIN_THRESHOLD:String = "joinThreshold";
		/** avarange FPS is grower than some threshold **/
		public static const PART_THRESHOLD:String = "partThreshold";
		/** Threshold was part or join **/
		public static const CROSS_THRESHOLD:String = "crossThreshold";
		/**  **/
		public static const PART_THRESHOLD_UPSIDE:String = "partThresholdUpside";
		/**  **/
		public static const PART_THRESHOLD_DOWNSIDE:String = "partThresholdDownside";
	
		/**
		 * BenchamrkThresholdEvent - Event to cooperate with Treshold for Benchmark
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function BenchamrkThresholdEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new BenchamrkThresholdEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("BenchamrkThresholdEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}