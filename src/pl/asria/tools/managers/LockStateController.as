/**
* CHANGELOG
*
* 2012-03-14 13:26: 1.0 Create file
*/
package pl.asria.tools.managers 
{
	import com.adobe.utils.ArrayUtil;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/** 
	* Dispatched when current procentage compete phases is changed 
	**/
	[Event(name="change", type="flash.events.Event")]
	/** 
	* Dispatched when all phases completed 
	**/
	[Event(name="complete", type="flash.events.Event")]
	public class LockStateController extends EventDispatcher
	{	
		private var _aPhases:Array;
		private var _aCompletedPhases:Array;

		private var _autoClean:Boolean = true;
		/**
		 * LockStateController - Manager to controll phases of starting application
		 * @usage - phases are defined in LockStateController constans. On the first run, all phases are full
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param - referencePhases - array of strings with all phases what should be done. This is copy of parameter. no reference!
		 */
		public function LockStateController(referencePhases:Array) 
		{
			_aPhases = ArrayUtil.copyArray(referencePhases);
			_aCompletedPhases = [];
		}
		
		/**
		 * Set phase as complete, if makes any changes then dispatch event Event.CHANGE
		 * @param	phase	one of costants from: LockStateController
		 * 
		 */
		public function setPhase(phase:String):void 
		{
			//trace( "LockStateController.setPhase > phase : " + phase );
			//trace("complete",_aCompletedPhases);
			//trace("reference",_aPhases);
			// check allow phase to set
			if (!_aCompletedPhases) _aCompletedPhases = [];
			if (_aPhases.indexOf(phase) >= 0)
			{
				// set phase in complete
				if (_aCompletedPhases.indexOf(phase) < 0)
				{
					_aCompletedPhases.push(phase);
					
					// dispatch event
					dispatchEvent(new Event(Event.CHANGE));
					
					if (_aPhases.length == _aCompletedPhases.length)
					{
						dispatchEvent(new Event(Event.COMPLETE));
						if(autoClean) clean();
					}
				}
			}
		}
		
		/**
		 * Return current procentago complete phases
		 */
		public function get procentageCompete():Number
		{
			return 100 * _aCompletedPhases.length / _aPhases.length;
		}
		
		/**
		 * <code>true</code> in default. Clean complete states after dispatch COMPLETE Event.
		 */
		public function get autoClean():Boolean 
		{
			return _autoClean;
		}
		
		public function set autoClean(value:Boolean):void 
		{
			_autoClean = value;
		}
		
		public function clean():void
		{
			_aCompletedPhases = null;
		}
	}

}