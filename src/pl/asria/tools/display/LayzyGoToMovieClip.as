package pl.asria.tools.display 
{
	import com.greensock.TweenLite;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class LayzyGoToMovieClip extends MovieClip
	{
		protected var _target:MovieClip;
		private var _timeOnFrame:Number = 0.03;
		private var tweenObject:Object = { targetFrame:1, tmpFrame:1 };
		
		public function LayzyGoToMovieClip(target:MovieClip = null) 
		{
			_target = target || this;
		}
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			animToFrame(frame, null);
		}
		protected function animToFrame(frame:Object, onComplete:Function):void 
		{
			_target.stop();
			if (frame is FrameLabel)
			{
				tweenObject.targetFrame = FrameLabel(frame).frame;
			}
			else if (frame is String)
			{
				for each(var _frame:FrameLabel in _target.currentLabels)
				{
					if (_frame.name == frame)
					{
						tweenObject.targetFrame = _frame.frame;
						break;
					}
				}
			}
			else if (frame is int || frame is uint || frame is Number)
				tweenObject.targetFrame = frame;
				
			var _offset:int = Math.abs(tweenObject.targetFrame - _target.currentFrame);
			tweenObject.tmpFrame = _target.currentFrame;
			
			TweenLite.killTweensOf(tweenObject);
			TweenLite.to(tweenObject, _timeOnFrame * _offset, {tmpFrame:tweenObject.targetFrame, onUpdate:tmpFrameHandler, onComplete:onComplete});
		}
		
		override public function gotoAndPlay(frame:Object, scene:String = null):void 
		{
			animToFrame(frame, _target.play);
			_target.stop();

		}
		
		public function jumpAndPlay(frame:Object):void 
		{
			_target.gotoAndPlay(frame);
		}
		public function jumpAndStop(frame:Object):void 
		{
			_target.gotoAndStop(frame);
		}
		
		private function tmpFrameHandler():void
		{
			if (_target == this)
			{
				super.gotoAndStop(int(tweenObject.tmpFrame));
			}
			else
			{
				_target.gotoAndStop(int(tweenObject.tmpFrame));
			}
		}
	
		public function get targetFrame():int 
		{
			return tweenObject.targetFrame;
		}
		
		[Inspectable (name = "timeOnFrame", variable = "timeOnFrame", type = "Number", defaultValue = '0.03', category = 'Other')]
		public function get timeOnFrame():Number 
		{
			return _timeOnFrame;
		}
		
		public function set timeOnFrame(value:Number):void 
		{
			_timeOnFrame = value;
		}
		
		public function get target():MovieClip 
		{
			return _target;
		}
		
	}

}