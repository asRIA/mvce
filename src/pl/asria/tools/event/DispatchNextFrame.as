/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-03-28 16:24</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.event 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class DispatchNextFrame 
	{
		protected var _delay:uint;
		private var _shape:Shape;
		private var _target:IEventDispatcher;
		private var _event:Event;
	
		/**
		 * DispatchNextFrame - dispatch some event in next frame
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function DispatchNextFrame(target:IEventDispatcher, event:Event, delay:uint = 1) 
		{
			_delay = delay;
			_event = event;
			_target = target;
			_shape = new Shape();
			_shape.addEventListener(Event.ENTER_FRAME, onEnterHandler);
		}
		
		private function onEnterHandler(e:Event):void 
		{
			if (!_delay--)
			{
				_shape.removeEventListener(Event.ENTER_FRAME, onEnterHandler);
				_target.dispatchEvent(_event);
				_target = null;
				_event = null;
				_shape = null;
			}
		}
		
	}

}