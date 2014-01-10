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
	
	/** 
	* Dispatched when some process is started 
	**/
	[Event(name="startNewProcess", type="pl.asria.tools.process.ProcessManagerEvent")]
	/** 
	* Dispatched when queye is killed 
	**/
	[Event(name="killQueue", type="pl.asria.tools.process.ProcessManagerEvent")]
	/** 
	* Dispatched when manager flush processes 
	**/
	[Event(name="clearQueue", type="pl.asria.tools.process.ProcessManagerEvent")]
	/** 
	* Dispatched when processes queue is just started. It is possible to add new process to queye in handler 
	**/
	[Event(name="startQueue", type="pl.asria.tools.process.ProcessManagerEvent")]
	/** 
	* Dispatched after event CLEAR_QUEUE, during propagation this event, you can not to register new process to manager
	**/
	[Event(name="complteteQueue", type="pl.asria.tools.process.ProcessManagerEvent")]
	public class ProcessManager extends ExtendEventDispatcher
	{
		protected var _vQueue:Vector.<Process>;
		protected var _currentProcess:Process;
		protected var _bussy:Boolean;
		protected var _completeEventPropagation:Boolean;
		protected var _currentProcessID:int;
	
		/**
		 * ProcessManager - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ProcessManager() 
		{
			_vQueue = new Vector.<Process>();
		}
		
		public function registerProcess(process:Process):void
		{
			if (_completeEventPropagation) throw new Error("Please to register new proces on ProcessManagerEvent.CLEAR_QUEUE");
			if (_vQueue.indexOf(process) < 0)
			{
				_vQueue.push(process);
				sortQueue();
			}
			process._processManager = this;
		}
		
		public function removeProcess(process:Process):void
		{
			var index:int = _vQueue.indexOf(process) ;
			if (index >= 0)
			{
				if (_vQueue[index].isRuning()) throw new Error("Can not remove running process, please kill at first or end");
				else _vQueue.splice(index,1);
			}
		}
		
		public function start():void
		{
			if (!_bussy)
			{
				var event:ProcessManagerEvent = new ProcessManagerEvent(ProcessManagerEvent.START_QUEUE);
				preparateEvent(event)
				dispatchEvent(event);
				getNextProcess();
			}
		}
		
		protected function sortQueue():void 
		{
			_vQueue = _vQueue.sort(sortByPriority);
		}
		
		protected function sortByPriority(processA:Process, processB:Process):int 
		{
			if (processA.priority > processB.priority) return -1;
			if (processA.priority < processB.priority) return 1;
			return 0;
		}
		
		protected function getNextProcess():void
		{
			//trace( "ProcessManager.getNextProcess" );
			_currentProcess = null;
			if (_vQueue.length) 
			{
				_bussy = true;
				_currentProcess = _vQueue.shift();		
				
				var event:ProcessManagerEvent = new ProcessManagerEvent(ProcessManagerEvent.START_NEW_PROCESS, _currentProcess);
				_currentProcessID++;
				preparateEvent(event)
				dispatchEvent(event);
				
				_currentProcess.addEventListener(ProcessEvent.END_PROCESS, endProcessHandler);
				_currentProcess.addEventListener(ProcessEvent.KILLED_PROCESS, killProcessHandler);
				
				_currentProcess.startProcess();
			}
			else
			{
				_bussy = false;
				event = new ProcessManagerEvent(ProcessManagerEvent.CLEAR_QUEUE);
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
		
		protected function preparateEvent(event:ProcessManagerEvent):void 
		{
			
		}
		
		protected function killProcessHandler(e:ProcessEvent):void 
		{
			_currentProcess.removeEventListener(ProcessEvent.END_PROCESS, endProcessHandler);
			_currentProcess.removeEventListener(ProcessEvent.KILLED_PROCESS, killProcessHandler);
			//_currentProcess.cleanProcess();
			getNextProcess();
		}
		
		protected function endProcessHandler(e:ProcessEvent):void 
		{
			_currentProcess.removeEventListener(ProcessEvent.END_PROCESS, endProcessHandler);
			_currentProcess.removeEventListener(ProcessEvent.KILLED_PROCESS, killProcessHandler);
			//_currentProcess.cleanProcess();
			getNextProcess();
		}
		
		public function kill():void
		{
			if (_currentProcess) 
			{
				_currentProcess.removeEventListener(ProcessEvent.END_PROCESS, endProcessHandler);
				_currentProcess.removeEventListener(ProcessEvent.KILLED_PROCESS, killProcessHandler);
				_currentProcess.killProcess();
			}
			_vQueue = new Vector.<Process>();
			_bussy = false;
			var event:ProcessManagerEvent = new ProcessManagerEvent(ProcessManagerEvent.KILL_QUEUE);
			preparateEvent(event)
			dispatchEvent(event);
		}
		
		
		public function get pendingLength():int
		{
			return _vQueue.length
		}
		
		public function get bussy():Boolean 
		{
			return _bussy;
		}
		
		public function get currentProcessID():int 
		{
			return _currentProcessID;
		}
		
		public function makeProcess(startManagerOnStartProcess:Boolean, nameProcess:String = null):Process
		{
			return new ProcessingProcess(this, startManagerOnStartProcess, nameProcess);
		}
	}
}

import pl.asria.tools.process.ProcessManagerEvent;
import pl.asria.tools.process.ProcessManager;
import pl.asria.tools.process.Process;
internal class ProcessingProcess extends Process
{
	protected var _parent:ProcessManager;
	protected var _pendingKilled:Boolean;
	protected var _pendingComplete:Boolean;
	protected var _pendingState:uint = 0x0;
	protected var _startManagerOnStartProcess:Boolean;
	public function ProcessingProcess(parent:ProcessManager, startManagerOnStartProcess:Boolean, nameProcess:String = null)
	{
		_startManagerOnStartProcess = startManagerOnStartProcess;
		_name = nameProcess;
		_parent = parent;
		_parent.addEventListener(ProcessManagerEvent.COMPLTETE_QUEUE, onCompleteQueye);
		_parent.addEventListener(ProcessManagerEvent.KILL_QUEUE, onKillQueye);
	}
	
	override protected function onClean():void 
	{
		_parent.removeEventListener(ProcessManagerEvent.COMPLTETE_QUEUE, onCompleteQueye);
		_parent.removeEventListener(ProcessManagerEvent.KILL_QUEUE, onKillQueye);
		_parent = null;
	}
	
	override protected function onEndProcess():void 
	{
		cleanProcess();
	}
	
	override protected function onKillProcess():void 
	{
		cleanProcess();
	}
	
	override protected function onStartProcess():void 
	{
		if(_parent == processManager) throw new Error("You can not reqister ProcessingProcess to his ProcessManager")
		if (_pendingState) executeEndCommand();
		else if(!_parent.bussy && _startManagerOnStartProcess) _parent.start()
	}
	
	protected function onKillQueye(e:ProcessManagerEvent):void 
	{
		_pendingState |= Process.KILLED;
		if (state & Process.RUNNING) executeEndCommand();
	}
	
	protected function onCompleteQueye(e:ProcessManagerEvent):void 
	{
		_pendingState |= Process.COMPLETED;
		if (state & Process.RUNNING) executeEndCommand();
	}
	
	protected function executeEndCommand():void 
	{
		if (_pendingState & Process.COMPLETED) endProcess();
		if (_pendingState & Process.KILLED) endProcess();
	}
}

