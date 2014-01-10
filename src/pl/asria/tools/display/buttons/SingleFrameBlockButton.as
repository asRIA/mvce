/**
* CHANGELOG:
*
* 2011-11-23 14:25: Create file
*/
package pl.asria.tools.display.buttons 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class SingleFrameBlockButton extends BlockButton
	{
		public static var LOCK_LABEL:String = "locked";
		public var levelIDS:Number;
		public function SingleFrameBlockButton(view:MovieClip = null) 
		{
			super(view)
			forceControl = false;
			_enableBlockFX = false;
		}
		
		override public function $block():void 
		{
			//trace( target.name, "SingleFrameBlockButton.$block" );
			super.$block();
			_target.gotoAndStop(LOCK_LABEL);
			
		}
		
		override public function $unblock():void 
		{
			//trace( target.name, "SingleFrameBlockButton.$unblock" );
			_target.gotoAndStop(BlockButton.FRAME_OFF);
			super.$unblock();
		}
		
		override protected function _rollOverHandler(e:MouseEvent):void 
		{
			if(!$isBlocked) super._rollOverHandler(e);
		}
		
		override protected function _rollOutHandler(e:MouseEvent):void 
		{
			if(!$isBlocked) super._rollOutHandler(e);
		}
		
		override protected function _upHandler(e:MouseEvent):void 
		{
			checkAutoblock();
			//trace(_block);
			
			if (_target)
			{
				if (_block) _target.gotoAndStop(LOCK_LABEL);
				else _target.gotoAndStop(BlockButton.FRAME_ON);
			}
			
		}
		override protected function _downHandler(e:MouseEvent):void 
		{
			if(!$isBlocked) super._downHandler(e);
		}
		
		override public function $forceUnblock():void 
		{
			//trace(target.name, "SingleFrameBlockButton.$forceUnblock" );
			super.$forceUnblock();
		}
	}

}