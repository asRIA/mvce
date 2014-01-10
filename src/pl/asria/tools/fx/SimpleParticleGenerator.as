/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-27 15:27</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.fx 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import pl.asria.tools.display.catche.addBasicCacheScript;
	import pl.asria.tools.display.catche.CachedSeqwence;
	
	public class SimpleParticleGenerator extends Sprite
	{
		protected var _currentShowMax:int;
		protected var _particleClass:Class;
		protected var _arena:Rectangle;
		protected var _cached:Boolean;
		protected var _delay:Number;
		protected var _randomThreshold:Number;
		protected var _timer:Timer;
		protected var _maxCountToGenerate:int;
		protected var _generatedCount:Number;
		protected var _currentDisplayed:int;
		protected var _active:Boolean;
	
		/**
		 * SimpleParticleGenerator - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function SimpleParticleGenerator(particleClass:Class, arena:Rectangle, cached:Boolean = true) 
		{
			_cached = cached;
			_arena = arena;
			_particleClass = particleClass;
			
		}
		
		public function hide():void 
		{
			cleanTimer();
		}
		
		/**
		 * 
		 * @param	maxShowInTheSameTime
		 * @param	maxCountToGenerate
		 * @param	delay	time, min 0.5 s
		 * @param	randomThreshold	0 to 1
		 */
		public function show(maxShowInTheSameTime:int, maxCountToGenerate:int = 10,  delay:Number = 1, randomThreshold:Number = 0):void 
		{
			//_active = true;
			_generatedCount = 0;
			_maxCountToGenerate = maxCountToGenerate;
			
			delay = delay < 0 ? 0.5 : delay;
			
			randomThreshold = randomThreshold > 0.5 ? 0.5 : randomThreshold;
			randomThreshold = randomThreshold < 0 ? 0 : randomThreshold;
			
			
			_randomThreshold = randomThreshold;
			_delay = delay;
			_currentShowMax = maxShowInTheSameTime;
			
			generateNewTimer();
		}
		
		protected function generateNewTimer():void 
		{
			cleanTimer();
			
			_timer = new Timer(1000*(_delay + (0.5 - Math.random())* _delay *_randomThreshold), 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
			_timer.start();
		}
		
		protected function completeTimerHandler(e:TimerEvent):void 
		{
			cleanTimer();
			if (_currentDisplayed < _currentShowMax)
			{
				generateParticle();
			}
			else
			{
				generateNewTimer();
			}
		}
		
		protected function generateParticle():void 
		{
			
			if (_generatedCount < _maxCountToGenerate)
			{
				var animation:MovieClip = new _particleClass() as MovieClip;
				if (_cached)
				{
					animation = new CachedSeqwence(animation, null, CachedSeqwence.CACHE_MODE_DIRECT);
					(animation as CachedSeqwence).keepFromGC(-1);
				}
				addBasicCacheScript(animation, animation.totalFrames - 1, new Event(Event.COMPLETE));
				animation.addEventListener(Event.COMPLETE, completeAnimationHandler);
				animation.gotoAndPlay(1);
				addChild(animation);
				animation.x = _arena.x + _arena.width * Math.random();
				animation.y = _arena.y + _arena.height * Math.random();
				animation.mouseChildren = false;
				animation.mouseEnabled = false;
				
				addScriptsToAnimation(animation);
				_currentDisplayed++;
				_generatedCount++;
				generateNewTimer();
			}
			
			
		}
		
		protected function addScriptsToAnimation(animation:MovieClip):void 
		{
			
		}
		
		protected function completeAnimationHandler(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, completeAnimationHandler);
			removeChild(e.currentTarget as DisplayObject);
			e.currentTarget.stop();
			_currentDisplayed--;
		}
		
		protected function cleanTimer():void 
		{
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, completeTimerHandler);
				_timer = null;
			}
			
		}
		
		public function set currentShowMax(value:int):void 
		{
			_currentShowMax = value;
		}
		
		public function set delay(value:Number):void 
		{
			_delay = value;
		}
		
		
		
	}

}