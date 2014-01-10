package pl.asria.tools.display.ui 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import pl.asria.tools.event.display.ui.EventProgress;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - trzeci.eu
	 */
	public class ProgressElement extends MovieClip
	{
		
		public function ProgressElement() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removedStage);
		}
		
		private function removedStage(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedStage);
			stage.removeEventListener(EventProgress.UPDATE, progresHandler);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(EventProgress.UPDATE, progresHandler);
		}
		
		private function progresHandler(e:EventProgress):void 
		{
			progress = e.progress
		}
		
		protected function set progress(value:int):void
		{
			
		}
	}
	
}