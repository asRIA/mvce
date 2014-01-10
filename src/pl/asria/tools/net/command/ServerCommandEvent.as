/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-08-07 11:41</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.net.command 
{
	import flash.events.Event;
	
	public class ServerCommandEvent extends Event 
	{
		/**  **/
		public static const COMMAND_TIMEOUT:String = "commandTimeout";
		/**  **/
		public static const COMAND_COMPLETE:String = "comandComplete";
		/**  **/
		static public const REQUEST_DATA_PREPARATION:String = "requestDataPreparation";
	
		/**
		 * ServerCommandEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ServerCommandEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ServerCommandEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ServerCommandEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}