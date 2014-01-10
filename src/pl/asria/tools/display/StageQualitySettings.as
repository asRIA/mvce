/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-04-04 12:13</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.display 
{
	import flash.display.Stage;
	import flash.display.StageQuality;
	import pl.asria.tools.performance.WeakReference;
	
	public final class StageQualitySettings 
	{
		protected var _stage:WeakReference;
		/** Used witt colabaration **/
		protected static var _quality:String;
		protected static var _lock:Boolean = true;
		
		/**
		 * StageQualitySettings - Defines of stage quality
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param stage - reference to stage
		 */
		public function StageQualitySettings() 
		{
			
		}
		
		public function init(stage:Stage):void
		{
			_stage = new WeakReference(stage);
			_quality = stage.quality;
		}
		
		public function set lock(value:Boolean):void
		{
			_lock = value;
			if (!value)
			{
				if (_stage && _stage.$) 
					_stage.$.quality = _quality;
			}
		}
		
		public function get lock():Boolean 
		{
			return _lock;
		}
		
		/**
		 * If lock is false, then this operation do not change stage quality at all, to manual change stage quality please set loct to false
		 */
		public function set quality(value:String):void
		{
			if (value != null)
			{
				_quality = value;
			}
			if (!_lock)
			{
				if (_stage && _stage.$) 
					_stage.$.quality = value;
			}
		}
		
		public function get quality():String 
		{
			return _quality;
		}
		
	}

}