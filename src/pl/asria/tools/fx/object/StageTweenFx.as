package pl.asria.tools.fx.object 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * To 
	 * @author Piotr Paczkowski
	 */
	public class StageTweenFx extends MovieClip
	{
		public var tweenObject:Object;
		public var timeAnimation:Number = 0.6;
		public function StageTweenFx() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		public function setTweenObject():void
		{
			tweenObject = { scaleX:1.2, scaleY:1.2, alpha:1, y:y - 100, ease:Quad.easeOut};
		}
		
		protected function init(e:Event):void 
		{	
			setTweenObject();
			scaleX = scaleY = 0.1;
			alpha = 0;
			
			var thisInstance:StageTweenFx = this;
			tweenObject.onComplete = function():void 
				{ 
					if (thisInstance.parent != null) 
						thisInstance.parent.removeChild(thisInstance)
				};
				
			removeEventListener(Event.ADDED_TO_STAGE, init);
			TweenMax.to(this, timeAnimation, tweenObject);
		}
		
		/**
		 * 
		 * @param	_stage
		 * @param	offset if null, then center to stage
		 */
		public function adopt(_stage:Stage, offset:Point = null):void
		{
			if (offset == null)
			{
				x = _stage.stageWidth / 2;
				y = _stage.stageHeight / 2;
			}
			else
			{
				x = offset.x;
				y = offset.y;
			}
			
			_stage.addChild(this);
		}
		
		/**
		 * Dodaje efekt do contenera, bądź w przypadku jego braku do aktualnego stage dla obejktu
		 * @param	obejct
		 * @param	contener
		 */
		public function adoptToObject(object:DisplayObject, contener:DisplayObjectContainer = null):void
		{
			var coor:Point = object.localToGlobal(new Point());
			x = coor.x;
			y = coor.y;
			if(contener) contener.addChild(this);
			else if(object.stage) object.stage.addChild(this); 
		}
		
	}

}