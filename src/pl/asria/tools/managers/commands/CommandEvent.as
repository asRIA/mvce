/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-09-26 13:34</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers.commands 
{
	import flash.events.Event;
	
	public class CommandEvent extends Event 
	{
		public var data:*;
		
		/**
		 * CommandEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function CommandEvent(type:String, data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.data = data;
			
		} 
		
		public override function clone():Event 
		{ 
			return new CommandEvent(type, data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CommandEvent", "data","type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}