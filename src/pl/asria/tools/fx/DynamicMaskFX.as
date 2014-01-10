/**
* CHANGELOG
*
* @version 2.0 - RTM
* <li>2012-03-15 15:09 - test sysytem functionality</li>
* @version 1.0 
* <li>2012-03-15 08:56 - Create file</li>
*/
package pl.asria.tools.fx 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import pl.asria.tools.display.IWorkspace;
	import pl.asria.tools.performance.WeakReference;
	import pl.asria.tools.utils.trace.etrace;
	
	/** 
	* Dispatched when all animations and pars are complete 
	**/
	[Event(name="complete", type="flash.events.Event")]
	public class DynamicMaskFX extends EventDispatcher
	{
		private var _appear:Boolean;
		protected var _vSkins:Vector.<DisplayObject>;
		
		/** Animation from left side to right **/
		static public const LEFT_TO_RIGHT:uint = 0x2;
		/** Animation from right side to left **/
		static public const RIGHT_TO_LEFT:uint = 0x3;
		/** Animation form up to down **/
		static public const UP_TO_DOWN:uint = 0x4;
		/** Animation from  down to up **/
		static public const DOWN_TO_UP:uint = 0x5;
		
		/** detect vertical mode **/
		public static const VERTICAL_MASK:uint = 0x4;
		
		/** detect horizontal mode **/
		public static const HORIZONTAL_MASK:uint = 0x2;
		
		/** that means movement is opositiv to normal **/
		public static const BACK_MOVE_MASK:uint = 0x1;
		
		protected var _vMasks:Vector.<DisplayObject>;
		protected var _countComplete:int;
		
		/** available types of animation **/
		protected const _aDirections:Array = [LEFT_TO_RIGHT, RIGHT_TO_LEFT, UP_TO_DOWN, DOWN_TO_UP];
		
		protected var _skin:Object;
		protected var _partMaskToSize:Boolean;
		protected var _target:DisplayObject;
		protected var _boundary:Rectangle;
		protected var _useWeakReference:Boolean;
		protected var _weakTarget:WeakReference;
		protected var _weakSkin:WeakReference;
		protected var _maskContener:Sprite;
		protected var _skinsContener:Sprite;
		protected var _fullMask:Sprite;
		/**
		 * DynamicMaskFX - Animation of appear of dissapeear text using a mask animation and skin ovae activ edge
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function DynamicMaskFX(useWeakReference:Boolean = false) 
		{
			this._useWeakReference = useWeakReference;
		}
		
		/**
		 * Auto clean before usage
		 * @param	target	Any displayObject, supported IWorkspace
		 * @param	boundary	set display properties for this object
		 */
		public function takeOver(target:DisplayObject, boundary:Rectangle = null):DynamicMaskFX
		{
			clean();
			if (_useWeakReference)
			{
				_weakTarget = new WeakReference(target);
			}
			else
			{
				this._target = target;
			}
			_maskContener = new Sprite();
			_skinsContener = new Sprite();
			this._boundary = boundary;
			return this;
		}
		
		/**
		 * 
		 * @param	direction - Please use one of DynamicMaskFX.LEFT_TO_RIGHT, DynamicMaskFX.RIGHT_TO_LEFT, DynamicMaskFX.UP_TO_DOWN, DynamicMaskFX.DOWN_TO_UP
		 * @param	appear - if <code> true </code> thean animation show target, otherwise this object will dissapeard
		 * @param	time - time total time of animation
		 * @param	delay - delat after run animation
		 * @param	partsCount - count of Parts to slice object
		 * @param	partsDelay -  if <code> partMaskToSize == true </code> then each part will be showed tith this delay. If this value will be lower than 0, then delay will be radomend from absolute value of this delay part
		 * @return Returns <code>true</code> if animation will be able to run otherwise <code>false</code>.
		 */
		public function startAnimation(direction:uint, appear:Boolean, time:Number, delay:Number, partsCount:int, partsDelay:Number,ease:Function = null):Boolean
		{
			stop();
			_appear = appear;
			
			if (_aDirections.indexOf(direction) < 0)
			{
				throw new Error("Invalid type of animation:", direction)
				return false;
			}
			var __target:DisplayObject = target;
			if (!__target || !__target.parent) 
			{
				etrace("Missing target. Propably you are using weakReferences, and GC collected this value, or target has no parent");
				return false;
			}
			
			
			// check placement of target
			var __boundary:Rectangle;
			if (_boundary) // if already declarated some bounds
			{
				__boundary = __boundary;
			}
			else if(__target is IWorkspace) // if object is IWorkspace
			{
				__boundary = (__target as IWorkspace).getWorkspace();
				__boundary.x *= __target.scaleX;
				__boundary.y *= __target.scaleY;
				__boundary.x += __target.x;
				__boundary.y += __target.y;
				__boundary.width *= __target.scaleX;
				__boundary.height *= __target.scaleY;
			}
			else if (__target is TextField)/* TODO get textfield bounds */
			{
				__boundary = target.getBounds(target.parent);
			}
			else // get boundary from parent
			{
				__boundary = target.getBounds(target.parent);
			}
			
			_fullMask = getMask();
			_fullMask.width = __boundary.width;
			_fullMask.height = __boundary.height;
			_maskContener.y = __boundary.y;
			_maskContener.x = __boundary.x;
			
			
			// sliceing
			var __sliceingCount:int = partsCount;
			var __isVertical:Boolean = Boolean(direction & VERTICAL_MASK);
			var __isBackMovement:Boolean = Boolean(direction & BACK_MOVE_MASK);
			var __skinMode:Boolean = Boolean(skin);
			
			
			
			// create masks
			_vMasks = new Vector.<DisplayObject> ();
			
			__target.parent.addChild(_maskContener);
			__target.mask = _maskContener
			if (__skinMode) 
			{
				__target.parent.addChild(_skinsContener);
				_skinsContener.y = __boundary.y;
				_skinsContener.x = __boundary.x;
				_vSkins = new Vector.<DisplayObject>();
			}
			for (var i:int = 0; i < __sliceingCount; i++) 
			{
				var __skin:DisplayObject = getSkin();
				var __mask:Sprite = getMask(__isBackMovement, __isVertical);

				if (__isVertical) // adopt mask to part of sliceing
				{
					if (__sliceingCount == 1)
					{
						__mask.width = __boundary.width;
					}
					else
					{
						__mask.width = __boundary.width / partsCount;
					}
					
					__mask.x = i * __mask.width; // placement masks in vertical animation
					if (__isBackMovement) 
					{
						__mask.y = __boundary.height;
					}
					__mask.height = appear ? 0 : __boundary.height
					
					if (__skin)
					{
						__skin.x = __mask.x + __mask.width / 2;
						__skin.y = (appear != __isBackMovement) ? 0 : __boundary.height;
					}
				}
				else
				{
					if (__sliceingCount == 1)
					{
						__mask.height = __boundary.height;
					}
					else
					{
						__mask.height = __boundary.height / partsCount;
					}
					
					__mask.y = i * __mask.height; // placement masks in horizontal animation
					if (__isBackMovement) __mask.x = __boundary.width;
					__mask.width = appear ? 0 : __boundary.width
					if (__skin)
					{
						__skin.y = __mask.y + __mask.height / 2;
						__skin.x = (appear != __isBackMovement) ? 0 : __boundary.width;
					}
				}
				
				
				_vMasks.push(__mask);
				_maskContener.addChild(__mask);
				
				var tweenParameters:Object = 
					{ 
						delay:(delay + (__sliceingCount == 1 ? 0 : partsDelay >= 0 ? partsDelay * i : -Math.random() * partsDelay)),
						onComplete:onCompleteHandler,
						onCompleteParams:[__mask]
					};
					
				if (__isVertical)
				{
					tweenParameters.height = appear ? __boundary.height : 0;
				}
				else
				{
					tweenParameters.width = appear ? __boundary.width : 0;
				}
				if (ease != null)
				{
					tweenParameters.ease = ease;
				}
				if (__skin)
				{
					//_skinsContener.addChild(__skin);
					var tweenSkin:Object = ease == null ?  { } : { ease:ease };
					if (__isVertical) tweenSkin.y = __skin.y + __boundary.height * (appear != __isBackMovement ? 1 : -1);
					else tweenSkin.x = __skin.x + __boundary.width * (appear != __isBackMovement ? 1 : -1);
					tweenSkin.delay = tweenParameters.delay;
					tweenSkin.onStart = onStartSkin;
					tweenSkin.onStartParams = [__skin];
					tweenSkin.onComplete = onCompleteSkin;
					tweenSkin.onCompleteParams = [__skin];
					_vSkins.push(__skin);
					TweenLite.to(__skin, time, tweenSkin)
				}
				
				TweenLite.to(__mask, time, tweenParameters);
			}
			return true;
		}
		
		protected function onCompleteSkin(skin:DisplayObject):void 
		{
			if (skin is MovieClip) (skin as MovieClip).stop();
			_skinsContener.removeChild(skin);
		}
		
		protected function onStartSkin(skin:DisplayObject):void 
		{
			if (skin is MovieClip) (skin as MovieClip).play();
			_skinsContener.addChild(skin);
		}
		
		
		protected function onCompleteHandler(target:Sprite):void 
		{
			_countComplete++;
			if (_countComplete == _vMasks.length)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				// complete set mask or complete unmask
				cleanMaskVector();
				if (_appear) // after end of appear mask is not needed anymore
				{
					if(_maskContener && _maskContener.parent) _maskContener.parent.removeChild(_maskContener);
					if (this.target &&  this.target.mask == _maskContener )
					{
						this.target.mask = null;
					}
				}
				else // after dissapperat mask is empty -> no visible object
				{
					//_maskContener.addChild(_fullMask);
				}
			}
		}
		
		protected function stop():void 
		{
			_countComplete = 0;
			cleanMaskVector();
				
			if(_vSkins)
				for each (var item:DisplayObject in _vSkins) 
				{
					TweenLite.killTweensOf(item);
					if(item.parent) _skinsContener.removeChild(item as DisplayObject);
				}
			
		}
		
		protected function getMask(back:Boolean = false, vertical:Boolean = false):Sprite
		{
			var result:Sprite = new Sprite();
			result.graphics.beginFill(0x000000);
			if (back) 
			{
				if(vertical) result.graphics.drawRect(0, -10, 10, 10);
				else result.graphics.drawRect(-10, 0, 10, 10);
			}
			else result.graphics.drawRect(0, 0, 10, 10);
			return result;
		}
		
		protected function getSkin():DisplayObject
		{
			var __skin:Object = skin;
			var __result:*;
			if (__skin)
			{
				if (__skin is Class) 
					__result =  new (__skin as Class)();
				else if (__skin is Function) 
					__result = (__skin as Function)();
				else 
					__result =  new __skin.constructor();
					
				if (__result is MovieClip) __result.stop();
			}
			return __result;
		}
		
		/**
		 * 
		 * @param skin: Class, Function (generator), or object with acces to constructor
		 */
		public function setSkin(skin:Object):DynamicMaskFX
		{
			this._skin = skin;
			return this;
			
		}
		
		
		/**
		 * Clean all behaviors. Remove mask. Remove skins.
		 * @return
		 */
		public function clean():DynamicMaskFX
		{
			// stop animations and remove subchilds
			stop();
			
			// unmask
			if (target && target.mask == _maskContener) target.mask = null;
			
			// remove child
			if (_skinsContener && _skinsContener.parent) _skinsContener.parent.removeChild(_skinsContener);
			if (_maskContener && _maskContener.parent) _maskContener.parent.removeChild(_maskContener);
			
			// null references
			_target = null;
			_skin = null;
			_maskContener = null;
			_skinsContener = null;
			_weakSkin = null;
			_weakTarget = null;
			
			return this;
		}
		
		private function cleanMaskVector():void 
		{
			if(_vMasks)
				for each (var item:DisplayObject in _vMasks) 
				{
					TweenLite.killTweensOf(item);
					_maskContener.removeChild(item as DisplayObject);
				}
		}
		
		protected function get target():DisplayObject 
		{
			var __result:DisplayObject;
			if (_useWeakReference && _weakTarget)
			{
				__result = _weakTarget.$;
			}
			else
			{
				__result = _target;
			}
			return __result;
		}
		
		protected function get skin():Object 
		{
			var __result:Object;
			if (_useWeakReference && _weakSkin)
			{
				__result = _weakSkin.$;
			}
			else
			{
				__result = _skin;
			}
			return __result;
		}
	}

}