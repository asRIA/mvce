/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-09 19:54</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers.commands 
{
	import org.osflash.signals.Signal;
	import pl.asria.tools.managers.SEnterFrameJuggler;
	
	public class CommandQueue 
	{
		protected var _started:Boolean;
		public var onComplete:Signal = new Signal();
		public var onFail:Signal = new Signal();
		
		/**
		 * CommandQueue - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function CommandQueue() 
		{
			
		}
		
		public function registerCommand(commandManager:CommandManager, commandDescription:*):void
		{
			
		}
		
		public function start():void
		{
			if (_started) return;
			
			_started = true;
			SEnterFrameJuggler.updateSignal.addOnce(function(delay:int):void {
				execute();
				});
		}
		
		protected function execute():void 
		{
			
		}
		
	}

}