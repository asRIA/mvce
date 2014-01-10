/**
* CHANGELOG:
*
* 2011-12-13 12:27: Create file
*/
package pl.asria.tools.display 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import pl.asria.tools.performance.WeakReference;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class StopMovieClip extends MovieClip
	{
		protected var _played:Boolean = true;
		protected var _wrapperMode:Boolean;
		protected var _disableRegister:Boolean;
		private var _view:WeakReference;
		public function StopMovieClip(view:MovieClip = null, autoSwap:Boolean = false) 
		{
			
			_view = new WeakReference(view || this);
			
			if (view)
			{
				_wrapperMode = true;
				if (autoSwap && view.parent)
				{
					view.parent.addChildAt(this,view.parent.getChildIndex(view))
				}
				addChild(view);
			}
			else
			{
				_wrapperMode = false;
			}
			addEventListener(Event.ADDED_TO_STAGE, onAddedHadnler, false, 0, false);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveHadnler, false, 0, false);
			
			if (!parent) 
			{
				_disableRegister = true;
				stop();
				_disableRegister = false;
			}
		}
		
		private function onRemoveHadnler(e:Event):void 
		{
			_disableRegister = true;
			stop();
			_disableRegister = false;
		}
		
		private function onAddedHadnler(e:Event):void 
		{
			if (_played)
			{
				_disableRegister = true;
				play();
				_disableRegister = false;
			}
			
		}
		
		public override function stop():void 
		{
			if (!_disableRegister) _played = false;
			if (_wrapperMode) _view.$.stop();
			else super.stop();
			
		}
		
		public override function play():void 
		{
			if (!_disableRegister) _played = true;
			if (_wrapperMode) _view.$.play();
			else super.play();
		}
		
		public override function gotoAndStop(frame:Object, scene:String = null):void 
		{
			if (_wrapperMode) _view.$.gotoAndStop(frame, scene);
			else super.gotoAndStop(frame, scene);
			if (!_disableRegister) _played = false;
		}
		
		public override function gotoAndPlay(frame:Object, scene:String = null):void 
		{
			if (_wrapperMode) _view.$.gotoAndPlay(frame, scene);
			else super.gotoAndPlay(frame, scene);
			if (!_disableRegister) _played = true;
		}
		
	}

}