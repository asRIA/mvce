/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-09 17:14</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import pl.asria.tools.data.ICleanable;
	
	/** 
	* Dispatched when source would like to create menu object iteam
	**/
	[Event(name="requestDescription", type="pl.asria.tools.display.ui.menu.ContextMenuSourceEvent")]
	public class ContextMenuSource extends EventDispatcher implements ICleanable
	{
		public var triggers:Vector.<String>;
		public var type:String;
		public var payload:*;
		public var object:IEventDispatcher;
	
		/**
		 * ContextMenuSource - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	obejct
		 * @param	trigger
		 * @param	payload
		 */
		public function ContextMenuSource(type:String,obejct:IEventDispatcher, triggers:Vector.<String>, payload:*) 
		{
			this.triggers = triggers;
			this.type = type;
			this.payload = payload;
			this.object = obejct;
			
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			this.payload = null;
			this.triggers = null;
			this.object = null;
			this.type = null;
		}
		
		public override function toString():String 
		{
			return "[ContextMenuSource] " + "{type:" + type +", obejct:" + object + ", trigger:" + triggers + ", payload:" + payload + "}";
			
		}

		
	}

}