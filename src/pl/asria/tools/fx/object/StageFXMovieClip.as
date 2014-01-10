/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-05-23 22:32</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.fx.object 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import pl.asria.tools.display.catche.addBasicCacheScript;
	
	public class StageFXMovieClip extends MovieClip
	{
		protected var _target:MovieClip;
	
		/**
		 * StageFXMovieClip - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function StageFXMovieClip(target:MovieClip = null):void 
		{
			if(target) addChild(target);
			_target = target || this;
			_target.mouseEnabled = false;
			_target.mouseChildren = false;
			
			addBasicCacheScript(_target, _target.totalFrames - 1, new Event(Event.COMPLETE));
			_target.addEventListener(Event.COMPLETE, completePlaymentHandler);
			
		}
		
		protected function completePlaymentHandler(e:Event):void 
		{
			_target.removeEventListener(Event.COMPLETE, completePlaymentHandler);
			if (_target.parent)
			{
				_target.parent.removeChild(_target);
			}
		}
		
		
		
	}

}