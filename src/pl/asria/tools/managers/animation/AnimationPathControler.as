/**
* CHANGELOG:
*
* 2011-12-01 11:38: Create file
*/
package pl.asria.tools.managers.animation 
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.SmoothCurve;
	import flash.utils.Timer;
	import pl.asria.engineZuma.events.ZumaEngineEvent;
	import pl.asria.tools.math.MathLine;
	import pl.asria.tools.utils.DisplayObjectUtils;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="requestMoveStop", type="pl.asria.tools.managers.animation.AnimationPathControlerEvent")]
	[Event(name="requestMoveDown", type="pl.asria.tools.managers.animation.AnimationPathControlerEvent")]
	[Event(name="requestMoveUp", type="pl.asria.tools.managers.animation.AnimationPathControlerEvent")]
	public class AnimationPathControler extends EventDispatcher
	{
		private var _mainLine:MathLine;
		private var _progress:Number = 0;
		private var contenerTarget:Sprite;
		private var _smoothCurve:SmoothCurve;
		private var rotateType:int;
		private var _currentAngle:Number;
		private var _animationLag:Timer;
		private var _targetProgress:Number;
		public var lag:Number = 0;
		
		/**
		 * 
		 * @param	contenerTarget
		 * @param	smoothCurve
		 * @param	rotateType AnimationPathControlerTypes.ROTATION_NONE, AnimationPathControlerTypes.ROTATION_ONCE, AnimationPathControlerTypes.ROTATION_ALWAYS, 
		 * @param	animationLag	Lag after come to targetPoint to dispatch event REQUEST_MOVE_STOP
		 */
		public function AnimationPathControler(contenerTarget:Sprite, smoothCurve:SmoothCurve, rotateType:int = 1/*AnimationPathControlerTypes.ROTATION_ONCE*/, animationLag:Number = 0.1) 
		{
			_animationLag = new Timer(animationLag * 1000,1);
			_animationLag.addEventListener(TimerEvent.TIMER_COMPLETE, animationLagCompleteHandelr);
			this.rotateType = rotateType;
			_smoothCurve = smoothCurve;
			this.contenerTarget = contenerTarget;

			_mainLine = MathLine.getOverPoints(smoothCurve.start, smoothCurve.end);
			if (rotateType == 1)
			{
				var offset:Point = smoothCurve.end.subtract(smoothCurve.start);
				currentAngle = DisplayObjectUtils.angleCalc(offset.y, offset.x);
			}
		}
		
		private function animationLagCompleteHandelr(e:TimerEvent):void 
		{
			dispatchEvent(new AnimationPathControlerEvent(AnimationPathControlerEvent.REQUEST_MOVE_STOP));
		}
		
		public function calcProgress(referencePoint:Point):Number
		{
			var perpendicularLine:MathLine = _mainLine.getPerpendicular(referencePoint);
			var crossingPoint:Point = MathLine.intersectionPoint(_mainLine, perpendicularLine);
			return _mainLine.progressBetween(_smoothCurve.start, _smoothCurve.end, crossingPoint);
		}
		
		public function get targetProgress():Number 
		{
			return _targetProgress;
		}
		
		
		/**
		 * @dispatch	Dispatch what movement is required now. Dispatch in animated object AnimationPathControlerEvent.REQUEST_MOVE_UP
		 */
		public function set targetProgress(value:Number):void 
		{
			_targetProgress = value;			
			if (_progress < _targetProgress)
				dispatchEvent(new AnimationPathControlerEvent(AnimationPathControlerEvent.REQUEST_MOVE_UP));
			else
				dispatchEvent(new AnimationPathControlerEvent(AnimationPathControlerEvent.REQUEST_MOVE_DOWN));
		}
		
		public function tweenAnimToTargetProgress(targetProgress:Number):void
		{
			this.targetProgress = targetProgress;
			TweenLite.killTweensOf(this);
			TweenLite.to(this, lag * distanceToTargetProgress, {progress:targetProgress, ease:Linear.easeNone, onComplete:completeHandler});
		}
		
		private function get distanceToTargetProgress():Number
		{
			return Math.abs((targetProgress - _progress) * _smoothCurve.length);
		}
		
		private function get offsetToTargetProgress():Number
		{
			return Math.abs(targetProgress - _progress);
		}
		
		
		/**
		 * Manual move to targetProgres
		 * @param	timeDelta	in ms, time between last movement to current
		 * @param	speedValue	how many pixels per 1000 ms
		 * @return	Returns <code>true</code> if object is in currentTarget progress otherwise <code>false</code>.
		 */
		public function manualAnimToTarget(timeDelta:int, speedValue:Number):Boolean
		{
			var offsetPixels:Number = speedValue * Number(timeDelta) / 1000;
			var offsetProgress:Number = offsetPixels / _smoothCurve.length;
			
			if (offsetToTargetProgress <= offsetProgress)  // object in target progres point
			{
				progress = _targetProgress;
				_animationLag.reset();
				_animationLag.start();
				return true;
			}
			
			if (_targetProgress > _progress)
				progress += offsetProgress
			else
				progress -= offsetProgress;
			
			return false;
			
		}
		
		public function completeHandler():void 
		{
			_animationLag.reset();
			_animationLag.start();
			
			//dispatchEvent(new AnimationPathControlerEvent(AnimationPathControlerEvent.REQUEST_MOVE_STOP));
		}
		
		public function $clear():void 
		{
			_animationLag.stop();
			_animationLag.removeEventListener(TimerEvent.TIMER_COMPLETE, animationLagCompleteHandelr);
			contenerTarget = null;
		}
		
		public function set currentAngle(value:Number):void 
		{
			_currentAngle = value;
			if (contenerTarget)
				contenerTarget.rotation = _currentAngle * 180 / Math.PI - 90;
		}
		
		public function set progress(value:Number):void 
		{
			_progress = value;
			var currentPosition:Point = _smoothCurve.getPointByDistance(int(_progress * _smoothCurve.length));
			if (contenerTarget)
			{
				contenerTarget.x = currentPosition.x;
				contenerTarget.y = currentPosition.y;
			}
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		public function get smoothCurve():SmoothCurve 
		{
			return _smoothCurve;
		}
	}

}