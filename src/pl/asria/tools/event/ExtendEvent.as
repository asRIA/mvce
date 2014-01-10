/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-25 09:02</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.event 
{
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	
	public class ExtendEvent extends Event 
	{
		protected var _params:Object;
		/**
		 * ExtendEvent - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ExtendEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, params:Object = null) 
		{ 
			super(type, bubbles, cancelable);
			_params = params || {};
			
		} 
		
		public override function clone():Event 
		{ 
			return new ExtendEvent(type, bubbles, cancelable, _params);
		} 
		
		public override function toString():String 
		{ 
			var _result:String = formatToString("ExtendEvent", "type", "bubbles", "cancelable", "eventPhase"); 
			//_result += "\n<PARAMS>\n" + com.adobe.serialization.json.JSON.encode(_params) + "\n</PARAMS>";
			return _result;
		}
		
		public function addParameter(paramName:String, data:*):Event
		{
			_params[paramName] = data;
			return this;
		}
		
		public function removeParameter(paramName:String):Event
		{
			delete _params[paramName];
			return this;
		}
		
		public function getParameter(paramName:String):*
		{
			return _params[paramName]
		}
	}
	
}