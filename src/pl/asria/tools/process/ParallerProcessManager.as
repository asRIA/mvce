/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-05 14:43</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.process 
{
	import pl.asria.tools.event.ExtendEventDispatcher;
	
	public class ParallerProcessManager extends ProcessManager
	{
		/**
		 * ParallerProcessManager - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ParallerProcessManager() 
		{
		}
		
		override protected function getNextProcess():void 
		{
			if (!_bussy)
			{
				_bussy = true;
				
				var copyQueue:Vector.<Process> = _vQueue.slice();
				for (var i:int = 0, i_max:int = copyQueue.length; i < i_max; i++) 
				{
					var process:Process = copyQueue[i];
					var event:ProcessManagerEvent = new ProcessManagerEvent(ProcessManagerEvent.START_NEW_PROCESS, process);
					preparateEvent(event)
					dispatchEvent(event);
					process.addEventListener(ProcessEvent.END_PROCESS, endProcessHandler);
					process.addEventListener(ProcessEvent.KILLED_PROCESS, killProcessHandler);
					process.startProcess();
				}
			}
		}
		
		override public function registerProcess(process:Process):void 
		{
			super.registerProcess(process);
			if (_bussy) process.startProcess();
		}
		
		protected function finishQueye():void
		{
			if (!_vQueue.length) 
			{
				_bussy = false;
				var event:ProcessManagerEvent = new ProcessManagerEvent(ProcessManagerEvent.CLEAR_QUEUE);
				preparateEvent(event)
				dispatchEvent(event);
				
				if (!_vQueue.length)
				{
					event = new ProcessManagerEvent(ProcessManagerEvent.COMPLTETE_QUEUE);
					preparateEvent(event);
					_completeEventPropagation = true;
					dispatchEvent(event);
					_completeEventPropagation = false;
				}
				else
				{
					getNextProcess();
				}
			}
		}
		
		override protected function killProcessHandler(e:ProcessEvent):void 
		{
			var process:Process = e.currentTarget as Process;
			removeProcess(process);
			process.removeEventListener(ProcessEvent.END_PROCESS, endProcessHandler);
			process.removeEventListener(ProcessEvent.KILLED_PROCESS, killProcessHandler);
			finishQueye();
		}
		
		override protected function endProcessHandler(e:ProcessEvent):void 
		{
			var process:Process = e.currentTarget as Process;
			removeProcess(process);
			process.removeEventListener(ProcessEvent.END_PROCESS, endProcessHandler);
			process.removeEventListener(ProcessEvent.KILLED_PROCESS, killProcessHandler);
			finishQueye();
		}
		
		override public function kill():void
		{
			for (var i:int = 0, i_max:int = _vQueue.length; i < i_max; i++) 
			{
				var process:Process = _vQueue[i];
				process.removeEventListener(ProcessEvent.END_PROCESS, endProcessHandler);
				process.removeEventListener(ProcessEvent.KILLED_PROCESS, killProcessHandler);
				process.killProcess();
			}
			_vQueue = new Vector.<Process>();
			_bussy = false;
			var event:ProcessManagerEvent = new ProcessManagerEvent(ProcessManagerEvent.KILL_QUEUE);
			preparateEvent(event)
			dispatchEvent(event);
		}
		
		
	}

}