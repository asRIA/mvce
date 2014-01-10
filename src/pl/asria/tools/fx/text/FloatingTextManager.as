/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-19 16:45</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.fx.text 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import pl.asria.tools.display.dispatchOnFrame;
	import pl.asria.tools.event.ExtendEventDispatcher;
	
	public class FloatingTextManager extends ExtendEventDispatcher
	{
		protected var _currentLevel:int;
		protected var _vGraphics:Vector.<MovieClip> = new Vector.<MovieClip>();
		protected var _content:DisplayObjectContainer;
		protected var _pivot:Point;
	
		/**
		 * FloatingTextManager - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function FloatingTextManager() 
		{
			
		}
		
		
		public function initContent(content:DisplayObjectContainer, pivot:Point):void
		{
			_pivot = pivot;
			_content = content;
			
		}
		
		public function addStep(graphicDefinition:MovieClip):void
		{
			dispatchOnFrame(graphicDefinition, graphicDefinition.totalFrames - 1, new Event(Event.COMPLETE));
			graphicDefinition.addEventListener(Event.COMPLETE, completePlayAnimationHandler)
			_vGraphics.push(graphicDefinition);
		}
		
		protected function completePlayAnimationHandler(e:Event):void 
		{
			e.currentTarget.stop();
			_content.removeChild(e.currentTarget as DisplayObject);
		}
		
		
		public function trigger():void
		{
			if (_currentLevel)
			{
				
				var animation:MovieClip = _vGraphics[_currentLevel-1];
				if (!animation.parent)
				{
					animation.x = _pivot.x;
					animation.y = _pivot.y;
					_content.addChild(animation);
					animation.gotoAndPlay(1);
				}
			}
			
		}
		
		public function increaseLevel():void
		{
			_currentLevel = Math.min(_vGraphics.length, _currentLevel);
		}
		
		public function resetLevel():void
		{
			_currentLevel = 0;
		}
		
		public function get level():int 
		{
			return _currentLevel;
		}
		
		public function set level(value:int):void 
		{
			_currentLevel = Math.min(_vGraphics.length, value);
			_currentLevel = Math.max(0, _currentLevel);
		}
		
	}

}