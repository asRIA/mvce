/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-05 14:31</li>
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
	* Dispatched when process is killed, dispatched after killProcess algorithm 
	**/
	[Event(name="killedProcess", type="pl.asria.tools.process.ProcessEvent")]
	/** 
	* Dispatched when process is started, dispatched after startProcess algorithm 
	**/
	[Event(name="startProcess", type="pl.asria.tools.process.ProcessEvent")]
	/** 
	* Dispatched when proces is completed 
	**/
	[Event(name="endProcess", type="pl.asria.tools.process.ProcessEvent")]
	/** 
	* Dispatched before start process flow 
	**/
	[Event(name="initProcess", type="pl.asria.tools.process.ProcessEvent")]
	/** 
	* Dispatched some internal process change name of this process
	**/
	[Event(name="nameChanged", type="pl.asria.tools.process.ProcessEvent")]
	/** 
	* Dispatched 
	**/
	[Event(name="progressChanged", type="pl.asria.tools.process.ProcessEvent")]
	public class Process extends ExtendEventDispatcher
	{
		protected var __state:uint = 0x0;
		
		protected var _progress:Number = 0;
		protected var _priority:int;
		protected var _name:String;
		/**  **/
		public static const INITED:uint = 0x1;
		/**  **/
		public static const RUNNING:uint = 0x2;
		/**  **/
		public static const KILLED:uint = 0x4;
		/**  **/
		public static const CLEANED:uint = 0x8;
		/**  **/
		public static const COMPLETED:uint = 0x10;
		internal var _processManager:ProcessManager;
		
	
		/**
		 * Process - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function Process(name:String = null) 
		{
			_name = name || "[unnamed process]: " + String(this);
		}
		
		public function get processManager():ProcessManager 
		{
			return _processManager;
		}
		
		public final function killProcess():void
		{
			trace( "Process.killProcess", this);
			if (__state & CLEANED) throw new Error("Process is clean, can not be killed");
			
			onKillProcess();
			__state = (__state & ~RUNNING) | KILLED;
			dispatchEvent(new ProcessEvent(ProcessEvent.KILLED_PROCESS));
		}
		
		public final function startProcess():void
		{
			trace( "Process.startProcess", this);
			if (__state & CLEANED) throw new Error("Process is clean, can not start again");
			if (__state & RUNNING) throw new Error("Can not to run runned process");
			
			if (!(__state & INITED)) dispatchEvent(new ProcessEvent(ProcessEvent.INIT_PROCESS));
			__state = (__state & ~(KILLED | COMPLETED)) | RUNNING | INITED;
			
			onStartProcess();
			
			dispatchEvent(new ProcessEvent(ProcessEvent.START_PROCESS));
		}
		
		public final function endProcess():void
		{
			trace( "Process.endProcess:", this);
			if (__state & CLEANED) throw new Error("Process is clean, can not be end'ed");
			if (!(__state & RUNNING)) throw new Error("Can not to stop not runned process");
			__state = (__state &~RUNNING) | COMPLETED;
			onEndProcess();
			dispatchEvent(new ProcessEvent(ProcessEvent.END_PROCESS));
		}
		
		public final function cleanProcess():void
		{
			if (__state & RUNNING) throw new Error("Can not to clean runned process, please kill process or end");
			onClean();
			__state |= CLEANED;
		}
		
		public final function isRuning():Boolean
		{
			return Boolean(__state & RUNNING);
		}
		
		protected function onClean():void 
		{
			throw new Error("Not implemented");
		}
		
		protected function onEndProcess():void 
		{
			throw new Error("Not implemented");
		}
		
		protected function onKillProcess():void 
		{
			throw new Error("Not implemented");
		}
		
		protected function onStartProcess():void 
		{
			throw new Error("Not implemented");
		}
		
		public final function get state():uint 
		{
			return __state;
		}
		
		/**
		 * Priority of process in queue in manager. <code>int.MIN </code>- lowest. <code>int.MAX </code> - highest
		 */
		public final function get priority():int 
		{
			return _priority;
		}
		
		public final function set priority(value:int):void 
		{
			_priority = value;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
			dispatchEvent(new ProcessEvent(ProcessEvent.NAME_CHANGED));
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get progress():Number 
		{
			return _progress;
		}
		
		public function set progress(value:Number):void 
		{
			_progress = value < 0 ? 0 : value > 1 ? 1 : value;
			dispatchEvent(new ProcessEvent(ProcessEvent.PROGRESS_CHANGED));
		}
	}
}