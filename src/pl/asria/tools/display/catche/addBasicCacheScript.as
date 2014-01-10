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
package pl.asria.tools.display.catche 
{
	
		import flash.display.MovieClip;
		import flash.events.Event;
		import flash.events.IEventDispatcher;
		//import pl.asria.tools.managers.animation.AnimationManagerEvent;
		/**
		 * addBasicCacheScript - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function addBasicCacheScript(targetContent:MovieClip, numFrame:int, eventType:Event, dispatcher:IEventDispatcher = null):void 
		{
			var target:MovieClip = targetContent;
			var _dispatcher:IEventDispatcher = dispatcher || targetContent;
			var eventType:Event = eventType;
			target.addFrameScript(numFrame, 
					function():void {
						_dispatcher.dispatchEvent(eventType);
					} 
				);
		}

}