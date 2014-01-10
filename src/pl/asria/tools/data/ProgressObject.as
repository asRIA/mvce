/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-03-27 11:49</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.data 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	
	/** 
	* Dispatched when progress changed 
	**/
	[Event(name="progress", type="flash.events.ProgressEvent")]
	/** 
	* Dispatched when process is completed 
	**/
	[Event(name="complete", type="flash.events.Event")]
	public class ProgressObject extends EventDispatcher
	{
		private var _currentSteps:Number = 0;
		private var _totalSteps:Number = 0;
		/**
		 * ProgressObject - Progres object to notyficate any progress change
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ProgressObject(totalSteps:Number) 
		{
			_totalSteps = totalSteps;
		}
		
		public function get totalSteps():Number 
		{
			return _totalSteps;
		}
		
		public function set totalSteps(value:Number):void 
		{
			_totalSteps = value;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _currentSteps, _totalSteps));
			
		}
		
		public function get currentSteps():Number 
		{
			return _currentSteps;
		}
		
		public function set currentSteps(value:Number):void 
		{
			_currentSteps = value;
			if (_totalSteps == _currentSteps)
			{
				dispatchEvent(new Event(Event.COMPLETE,false,false));
			}
			else
			{
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,_currentSteps,_totalSteps));
			}
		}
		
		public function get progress():Number 
		{
			return _currentSteps/_totalSteps;
		}
		
	}

}