/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-05 14:48</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.process 
{
	import flash.events.Event;
	
	public class ProcessManagerEvent extends Event 
	{
		public var data:*;
		public var process:Process;
		/**  **/
		public static const START_NEW_PROCESS:String = "startNewProcess";
		/**  **/
		public static const CLEAR_QUEUE:String = "clearQueue";
		/**  **/
		public static const KILL_QUEUE:String = "killQueue";
		/**  **/
		public static const START_QUEUE:String = "startQueue";
		/**  **/
		static public const COMPLTETE_QUEUE:String = "complteteQueue";
	
		/**
		 * ProcessManagerEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ProcessManagerEvent(type:String, process:Process = null,  data:*=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.data = data;
			this.process = process;
			
		} 
		
		public override function clone():Event 
		{ 
			return new ProcessManagerEvent(type, process, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ProcessManagerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}