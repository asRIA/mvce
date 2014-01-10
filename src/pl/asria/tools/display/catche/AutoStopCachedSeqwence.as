/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-07-03 13:06</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display.catche 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AutoStopCachedSeqwence extends CachedSeqwence
	{
		protected var _isPlayed:Boolean;
	
		/**
		 * AutoStopCachedSeqwence - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function AutoStopCachedSeqwence(source:Sprite, uid:String = null, initCacheMode:int = 1, scaleX:Number = NaN, scaleY:Number = NaN, rotation:Number = NaN):void 
		{
			super(source, uid, initCacheMode, scaleX, scaleY, rotation);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);
		}
		
		public override function play():void 
		{
			//if (stage)
			//{
				super.play();
			//}
			_isPlayed = _played;
			
		}
		
		public override function stop():void 
		{
			super.stop();
			_isPlayed = _played;
		}
		
		protected function onRemovedFromStage(e:Event):void 
		{
			super.stop();
		}
		
		protected function onAddedToStage(e:Event):void 
		{
			if (_isPlayed) super.play();
		}
		
		public function cleanAutostopLiseners():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
	}

}