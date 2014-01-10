package pl.asria.tools.fx.object 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	[Event(name="playFx", type="pl.asria.tools.fx.object.StageFXEvent")]
	
	/** 
	* Dispatched when fx is removed from stage
	**/
	[Event(name="removedFx", type="pl.asria.tools.fx.object.StageFXEvent")]
	public class StageFX extends MovieClip
	{
		protected var _target:MovieClip;
		/**
		 * Obiekt dodaje się do sceny w miejscu obiektu referencyjnego (dodanego za pomocą 'adoptDisplayObject')
		 * @author Piotr Paczkowski
		 */
		public function StageFX(view:MovieClip = null) 
		{
			if(view) addChild(view);
			_target = view || this;
			_target.addEventListener("requestRemove", requestRemoveHandler, false, 0, true);
		}
		
		private function requestRemoveHandler(e:Event):void 
		{
			if (parent) 
			{
				parent.removeChild(this);
				_target.stop();
			}
			dispatchEvent(new StageFXEvent(StageFXEvent.REMOVED_FX));
			_target.removeEventListener("requestRemove", requestRemoveHandler);
			_target = null;
		}
		
		public function adoptDisplayObject(object:DisplayObject, offset:Point = null):void
		{
			if (object.stage == null) return;
			if (offset == null) offset = new Point();
			var aim:Point = object.localToGlobal(offset);
			x = aim.x;
			y = aim.y;
			
			object.stage.addChild(this);
			mouseChildren = false;
			mouseEnabled = false;
			
		}
		
		public function injectToContent(content:Sprite, position:Point, timeOffset:Number = 0, onTop:Boolean = true):void
		{
			if (onTop) content.addChild(this);
			else content.addChildAt(this,0);
			_target.stop();
			x = position.x;
			y = position.y;
			TweenLite.delayedCall(timeOffset, play);
		}
		override public function play():void 
		{
			if(_target == this)
			{
				super.play();
			}
			else 
			{
				_target.play();
			}
			dispatchEvent(new StageFXEvent(StageFXEvent.PLAY_FX));
		}
		/**
		 * Adopt Fx to stage
		 * @param	stage
		 * @param	offset if null then center to middle point of stage
		 */
		public function adoptToStage(stage:Stage, offset:Point = null):void
		{
			if (!stage) return;
			var aim:Point;
			if (!offset)
				aim = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
			else
				aim = offset;
			
			stage.addChild(this);
			x = aim.x;
			y = aim.y;
			
		}
	}

}