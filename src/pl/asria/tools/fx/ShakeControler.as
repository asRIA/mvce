/**
 * CHANGELOG:
 *
 * 2011-11-22 11:53: Create file
 */
package pl.asria.tools.fx
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	
	[Event(name="complete",type="flash.events.Event")]
	public class ShakeControler extends EventDispatcher
	{
		protected var tween:TweenLite;
		static private const _shakeingObjects:Dictionary = new Dictionary(true);
		private var target:Object;
		private var ease:Function;
		private var cleanAfterComplete:Boolean;
		private var dump:Object  = {};
		
		
		/**
		 * Make $storeState after creation. To get fx effect please use $shake method
		 * @param	target
		 * @param	ease standard ease function like Sine, Linear, Power, Quad from <code>fl.motion.easing.*</code>, or <code>com.greensock.easing.*</code>
		 * @author Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ShakeControler(target:Object, ease:Function = null)
		{
			this.ease = ease || Quad.easeInOut;
			this.target = target;
			$storeState();
		}
		
		private function $clean():void
		{
			target = null;
			ease = null;
		}
		
		/**
		 * make shacke FX. After complete dispatch Event.COMPLETE
		 * @param	time	Time of the Shake effect
		 * @param	ratioX	Value over that shake is propagated. More -> grower shake offset
		 * @param	ratioY	Value over that shake is propagated. More -> grower shake offset
		 * @param	cleanAfterComplete	if <code>true</code> then clean this object after complete shake otherweise references are stillin memory.
		 */
		public function $shake(time:Number = 1, ratioX:Number = 10, ratioY:Number = 10, cleanAfterComplete:Boolean = false):ShakeControler
		{
			if (_shakeingObjects[target])
			{
				_shakeingObjects[target].$stop();
			}
			_shakeingObjects[target] = this;
			this.cleanAfterComplete = cleanAfterComplete;
			var shakeObj:Object = {progress: 0, ratioX: ratioX, ratioY: ratioY};
			tween = shakeObj.tween = TweenLite.to(shakeObj, time / 2, { progress: 1, yoyo: true, onStart:updateShakeFx, onStartParams:[shakeObj], onUpdate: updateShakeFx, onUpdateParams: [shakeObj], onComplete: $stop, ease: ease } );
			return this;
		}
		
		/**
		 * Stop shake, dispatch COMPLETE, clean if required
		 */
		public function $stop():void
		{
			delete _shakeingObjects[target];
			if (tween && tween.active) tween.kill();
			tween = null;
			
			target.x = dump.x;
			target.y = dump.y;
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (cleanAfterComplete)
				$clean();
		}
		
		private function updateShakeFx(object:Object):void
		{
			target.x = dump.x + object.progress * object.ratioX * (1 - Math.random() * 2);
			target.y = dump.y + object.progress * object.ratioY * (1 - Math.random() * 2);
		}
		
		/**
		 * Make dump of position target. This values will be restored after complete shake
		 * @return
		 */
		public function $storeState():ShakeControler 
		{
			dump.x = target.x;
			dump.y = target.y;
			return this;
		}
	
	}

}