/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-28 16:55</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.fx.text 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import pl.asria.tools.display.dispatchOnFrame;
	
	public class FloatingTextTimer 
	{
		protected var _source:MovieClip;
		protected var _middleFrame:int;
		protected var _content:Sprite;
		protected var _time:Number;
		protected var _timer:Timer;
	
		/**
		 * FloatingTextTimer - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function FloatingTextTimer(source:MovieClip, middleFrame:int, content:Sprite) 
		{
			_content = content;
			_middleFrame = middleFrame;
			_source = source;
			_source.stop();
			
			dispatchOnFrame(source, middleFrame-1, new Event("middleFrame"));
			dispatchOnFrame(source, source.totalFrames - 1, new Event("endAniamtion"));
			
			_source.addEventListener("middleFrame", middleFrameHandler, false, 0, true);
			_source.addEventListener("endAniamtion", endAnimationHandler, false, 0, true);
		}
		
		protected function endAnimationHandler(e:Event):void 
		{
			_source.stop();
			_content.removeChild(_source);
		}
		
		protected function middleFrameHandler(e:Event):void 
		{
			_source.stop();
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
				_timer.stop();
			}
			
			_timer = new Timer(_time * 1000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
			_timer.start();
		}
		
		protected function completeTimerHandler(e:TimerEvent):void 
		{
			_source.play();
		}
		
		
		public function play(time:Number, position:Point):void
		{
			_source.gotoAndPlay(1);
			_content.addChild(_source)
			_time = time;
			_source.x = position.x;
			_source.y = position.y;
		}
	}

}