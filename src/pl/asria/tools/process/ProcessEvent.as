/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-05 14:33</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.process 
{
	import flash.events.Event;
	
	public class ProcessEvent extends Event 
	{
		/**  **/
		public static const START_PROCESS:String = "startProcess";
		/**  **/
		public static const KILLED_PROCESS:String = "killedProcess";
		/**  **/
		public static const END_PROCESS:String = "endProcess";
		/**  **/
		public static const INIT_PROCESS:String = "initProcess";
		/**  **/
		static public const NAME_CHANGED:String = "nameChanged";
		/**  **/
		static public const PROGRESS_CHANGED:String = "progressChanged";
	
		/**
		 * ProcessEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ProcessEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ProcessEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ProcessEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}