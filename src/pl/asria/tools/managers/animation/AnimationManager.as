/**
 * CHANGELOG:
 *
 * 2011-11-24 17:26: Create file
 */
package pl.asria.tools.managers.animation
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="emptyQueye",type="pl.asria.tools.managers.animation.AnimationManagerEvent")]
	
	[Event(name="playLabel", type="pl.asria.tools.managers.animation.AnimationManagerEvent")]
	[Event(name="completeLabel", type="pl.asria.tools.managers.animation.AnimationManagerEvent")]
	public class AnimationManager extends EventDispatcher
	{
		private var _animation:MovieClip;
		private var _vQueye:Vector.<String> = new Vector.<String>();
		private var _inAnimation:Boolean;
		private var _timer:Timer;
		protected var _currentCycle:AnimationCycle;
		protected var _lastLabel:String;
		protected var _currentLabel:String;
		protected var _lastCompleteLabel:String;
		protected var _lookUpTable:Object;
		protected var _LUTMode:Boolean = false;
		private var _content:Sprite;
		
		/**
		 * 
		 * @param	animation any movieslip what should dispatch event "completeLabel" after complete every framelabel, in other case, can be null, then set new Sprite in content, also should be inited LookUpTable to proper work
		 */
		public function AnimationManager(animation:MovieClip = null)
		{
			_content = animation || new Sprite();
			//if (animation == null) throw new Error("Null animation")
			this._animation = animation;
			if (_animation)
			{
				_animation.addEventListener(AnimationManagerEvent.COMPLETE_LABEL, completeAnimHandler);
				_animation.stop();
			}
		}
		
		/**
		 * Play in next animation in order, if if playing any AnimationCycle, then wait to complete this animation, then play
		 * @param	frame
		 */
		public function $playInNext(frame:String):void
		{
			_vQueye.unshift(frame);
			if (_currentCycle && _currentCycle.out)
			{
				_vQueye.unshift(_currentCycle.out);
				_currentCycle = null;
				removeTimmer();
			}
			
			
			if (!_inAnimation)
				$playSeqwence();
		}
		
		/**
		 * push on the end of animation queye
		 * @param	frame
		 * @return	length of queye
		 */
		public function $pushToQueye(frame:String):uint
		{
			return _vQueye.push(frame);
		}
		
		/**
		 * Always clean seqwence
		 * @param	frame
		 */
		public function $playNow(frame:String):void
		{
			_play(frame);
			$clean();
		}
		
		public function $playSeqwence():void
		{
			if (_currentCycle && _vQueye.length == 0)
				_vQueye.push(_currentCycle.cycle);
			
			if (_vQueye.length)
			{
				_play(_vQueye.shift())
			}
			else 
			{
				if(_animation) _animation.stop();
				dispatchEvent(new AnimationManagerEvent(AnimationManagerEvent.EMPTY_QUEYE));
			}
		}
		private function _play(frame:String):void
		{
			//trace( "AnimationManager._play > frame : " + frame );
			_inAnimation = true;
			_lastLabel = _currentLabel;
			_currentLabel = frame;
			if (_LUTMode)
			{
				if (_animation)
				{
					if (_animation.parent) _animation.parent.removeChild(_animation);
					_animation.stop();
				}
				
				_animation = _lookUpTable[frame];
				_content.addChild(_animation);
				_animation.gotoAndPlay(1);
				_animation.addEventListener(AnimationManagerEvent.COMPLETE_LABEL, completeAnimHandler);
			}
			else
			{
				_animation.gotoAndPlay(frame);
			}
			dispatchEvent(new AnimationManagerEvent(AnimationManagerEvent.PLAY_LABEL));
		}
		public function $clean():void
		{
			_currentCycle = null;
			removeTimmer();
			_vQueye = new Vector.<String>();
		}
		public function $clear():void
		{
			$clean();
			if (_animation)
			{
				_animation.stop();
				_animation.removeEventListener(AnimationManagerEvent.COMPLETE_LABEL, completeAnimHandler);
			}
			_animation = null;
			_LUTMode = false;
			_lookUpTable = null;
		}
		
		private function completeAnimHandler(e:Event):void
		{
			if (_LUTMode)
			{
				_animation.removeEventListener(AnimationManagerEvent.COMPLETE_LABEL, completeAnimHandler);
			}
			_inAnimation = false;
			_lastCompleteLabel = _currentLabel;
			dispatchEvent(new AnimationManagerEvent(AnimationManagerEvent.COMPLETE_LABEL));
			$playSeqwence();
		}
		
		public function $playCycle(animationCycle:AnimationCycle, time:Number = -1, afterCurrentAnimation:Boolean = true, afterCurrentCycle:Boolean = false):void
		{
			var _cycleCurrentCpy:AnimationCycle = _currentCycle;
			$clean();
			if (afterCurrentAnimation && _inAnimation)
			{
				if (_cycleCurrentCpy && _cycleCurrentCpy.out)
					_vQueye.push(_cycleCurrentCpy.out);
				if (animationCycle.intro)
					_vQueye.push(animationCycle.intro);
				else
					_vQueye.push(animationCycle.cycle);
				_currentCycle = animationCycle;
			}
			else
			{
				_currentCycle = animationCycle;
				if (animationCycle.intro)
					_play(animationCycle.intro);
				else
					_play(animationCycle.cycle);
			}
			
			removeTimmer();
			if (time > 0)
			{
				_timer = new Timer(time * 1000, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, stopCycleHandler);
				_timer.start();
			}
		}
		
		/**
		 * propabli dispatch event about empty queye
		 * @param	inmedatly
		 */
		public function $stopCycle(inmedatly:Boolean = false):void
		{
			var _cycleCopy:AnimationCycle = _currentCycle;
			$clean();
			removeTimmer();
			if (inmedatly) {
				$playSeqwence();
				return;
			}
			
			if (_cycleCopy && _cycleCopy.out)
				_vQueye.push(_cycleCopy.out);
			if (!_inAnimation)
				$playSeqwence();
			
		}
		
		public function $pause():void 
		{
			if(_inAnimation && _animation) _animation.stop();
		}
		
		public function $resume():void 
		{
			if(_inAnimation && _animation) _animation.play();
		}
		
		public function $getLabels(baseType:String =""):Vector.<String>
		{
			var _labels:Array = []
			if (_LUTMode)
			{
				for (var key:String in _lookUpTable) 
				{
					_labels.push(key);
				}
			}
			else
			{
				for each (var label:FrameLabel in MovieClip(_content).currentLabels)
					_labels.push(label.name);
			}
			
			var result:Vector.<String> = new Vector.<String>();
			for each (var _label:String in _labels)
			{
				if (_label.indexOf(baseType) == 0)
					result.push(_label);
			}
			return result;
		}
		
		
		/**
		 * Init look up table for generate accurate animation to name
		 * @param	lookUpTable hashTable, where index is name of animation, and object is an animation
		 */
		public function $initLUT(lookUpTable:Object):void 
		{
			_lookUpTable = lookUpTable;
			_LUTMode = true;
		}
		
		private function removeTimmer():void
		{
			if (_timer)
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, stopCycleHandler);
			_timer = null;
		}
		
		private function stopCycleHandler(e:TimerEvent):void
		{
			$stopCycle();
		}
		
		public function get $inCycle():Boolean 
		{
			return Boolean(_currentCycle);
		}
		
		public function get $inAnimation():Boolean 
		{
			return _inAnimation;
		}
		
		public function get currentCycle():AnimationCycle 
		{
			return _currentCycle;
		}
		
		public function get lastLabel():String 
		{
			return _lastLabel;
		}
		
		public function get currentLabel():String 
		{
			return _currentLabel;
		}
		
		public function get lastCompleteLabel():String 
		{
			return _lastCompleteLabel;
		}
		
		public function get animation():MovieClip 
		{
			return _animation;
		}
		
		public function get content():Sprite 
		{
			return _content;
		}
	}

}