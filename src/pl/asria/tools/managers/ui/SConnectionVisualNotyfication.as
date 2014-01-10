/**
* CHANGELOG:
*
* 2011-11-28 20:07: Create file
*/

package pl.asria.tools.managers.ui 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import pl.asria.tools.managers.animation.AnimationCycle;
	import pl.asria.tools.managers.animation.AnimationManager;
	import pl.asria.tools.managers.animation.AnimationManagerEvent;
	
	/**
	 * Singleton Class of SConnectionVisualNotyfication
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SConnectionVisualNotyfication 
	{
		static private var conten:DisplayObjectContainer;
		static private var loop:AnimationCycle;
		static private var animation:MovieClip;
		static private var _initialized:Boolean;
		static private var _animationManager:AnimationManager;
		
		public function SConnectionVisualNotyfication() 
		{
			
		}
		
		public static function init(conten:DisplayObjectContainer, animation:MovieClip, loop:AnimationCycle):void
		{
			SConnectionVisualNotyfication.animation = animation;
			SConnectionVisualNotyfication.loop = loop;
			SConnectionVisualNotyfication.conten = conten;
			_initialized = animation && loop && conten;
			_animationManager = new AnimationManager(animation);
			_animationManager.addEventListener(AnimationManagerEvent.EMPTY_QUEYE, completeNotyficationHandler);
		}
		
		static private function completeNotyficationHandler(e:AnimationManagerEvent):void 
		{
			if(animation && animation.parent) animation.parent.removeChild(animation);
		}
		
		public static function play(time:Number = -1):void
		{
			check();
			conten.addChild(animation);
			if(!_animationManager.$inCycle)
				_animationManager.$playCycle(loop,time,false);
		}
		
		static private function check():void 
		{
			if(!_initialized) throw new Error("Not initizet property")
		}
		
		public static function stop():void
		{
			check();
			_animationManager.$stopCycle();
		}
		
		static public function get animationManager():AnimationManager 
		{
			return _animationManager;
		}
		
		
		
	}
	
}
