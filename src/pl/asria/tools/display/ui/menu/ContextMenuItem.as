/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-10 09:08</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.ui.menu 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import pl.asria.tools.data.ICleanable;
	
	public class ContextMenuItem implements ICleanable
	{
		public var description:ContextMenuItemDescription;
		public var callbackparams:Array;
		//public var enabled:Boolean;
		public var callback:Function;
		public var dispatchGlobal:Event;
		//public var label:String;
		//public var type:String;
		internal var builder:ContextMenuBuilder;
		
		/**
		 * ContextMenuItem - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	type
		 * @param	label
		 * @param	dispatchGlobal
		 * @param	callback	with no parameters
		 * @param	enabled
		 */
		//public function ContextMenuItem(type:String, label:String, dispatchGlobal:Event, callback:Function, enabled:Boolean = true, callbackparams:Array = null) 
		public function ContextMenuItem(description:ContextMenuItemDescription, dispatchGlobal:Event, callback:Function, callbackparams:Array = null) 
		{
			this.description = description;
			this.callbackparams = callbackparams;
			//this.enabled = enabled;
			this.callback = callback;
			this.dispatchGlobal = dispatchGlobal;
			//this.label = label;
			//this.type = type;
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			callback = null;
			dispatchGlobal = null;
			//label = null;
			//type = null;
			builder.clean();
			builder = null;
			callbackparams = null;
		}
		
		internal final function invoke():void 
		{
			if (callback != null)
			{
				if (callbackparams) callback.apply(null, callbackparams)
				else callback();
				
			}
			ContextMenuManager.instance.invoke(dispatchGlobal);
		}
		
	}

}