/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-24 18:37</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.events.IEventDispatcher;
		//import pl.asria.tools.managers.animation.AnimationManagerEvent;
		/**
		 * dispatchOnFrame - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		
		 /**
		  * 
		  * @param	targetContent
		  * @param	frame please use [int] as default value
		  * @param	eventType
		  * @param	dispatcher
		  */
		public function dispatchOnFrame(targetContent:MovieClip, frame:int, eventType:Event, dispatcher:IEventDispatcher = null):void 
		{
			if (!targetContent) return;
			var target:MovieClip = targetContent;
			var _dispatcher:IEventDispatcher = dispatcher || targetContent;
			var eventType:Event = eventType;
			target.addFrameScript(frame, 
					function():void {
						_dispatcher.dispatchEvent(eventType);
					} 
				);
		}

}