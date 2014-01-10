/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-09-25 11:46</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers.commands 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import pl.asria.tools.utils.getClass;
	import pl.asria.tools.utils.isBasedOn;
	
	public class CommandManager extends EventDispatcher
	{
		protected var _lutMessageTriggers:Dictionary = new Dictionary(true);
		protected var _dispatchTarget:IEventDispatcher;
		/**
		 * CommandManager - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	in default it is insfance of this CommandManager
		 */
		public function CommandManager(mapObservableDispatcher:IEventDispatcher = null) 
		{
			_dispatchTarget = mapObservableDispatcher || this;
		}

		/**
		 * 
		 * @param	trigger	class or simple type
		 * @param	command
		 * @param	priotity
		 */
		public function map(trigger:String, executor:Class, priotity:int = 0):void 
		{
			if (!isBasedOn(executor, Command)) throw new Error("command class has to extends pl.asria.tools.managers.commands.Command")
			mapExecutor(trigger, executor);
			_dispatchTarget.addEventListener(trigger, messageHandlerGrabber);
		}
		
		public function mapClass(payload:Class, executor:Class, priotity:int = 0):void
		{
			if (!isBasedOn(executor, Command)) throw new Error("command class has to extends: " + getQualifiedClassName(Command));
			mapExecutor(payload, executor);
		}
		
		public function mapFunction(payload:Class, executor:Function, priotity:int = 0):void
		{
			if(executor.length == 0) throw new Error("executor function miss payload data argument: " + getQualifiedClassName(payload));
			mapExecutor(payload, executor)
		}
		
		protected function mapExecutor(trigger:Object, executor:Object, priotity:int = 0):void
		{
			var _vClass:Vector.<CommandEntry>;
			if (undefined == _lutMessageTriggers[trigger])
			{
				_lutMessageTriggers[trigger] = _vClass = new Vector.<CommandEntry>();
				_vClass[0] = new CommandEntry(executor, priotity);
			}
			else
			{
				_vClass  = _lutMessageTriggers[trigger];
				_vClass.push(new CommandEntry(executor, priotity));
				_vClass.sort(CommandEntry.sorter)
			}
		}
		
		
		protected function messageHandlerGrabber(e:CommandEvent):void 
		{
			executeData(e.type, e.data);
		}
		
		public function execute(trigger:Object):void 
		{
			executeData(getClass(trigger), trigger);
		}
		
		protected function executeData(trigger:Object, data:Object):void 
		{
			var commandsRow:Vector.<CommandEntry> = _lutMessageTriggers[trigger];
			if (commandsRow) 
			{
				for (var i:int = 0, i_max:int = commandsRow.length; i < i_max; i++ )
				{
					var executor:Function = commandsRow[i].command is Function ? commandsRow[i].command as Function : new commandsRow[i].command().execute as Function;
					executor(data);
				}
			}
			else
			{
				trace("3:There is no registred executor for :"+getQualifiedClassName(trigger)+" - " + trigger)
			}
		}
		
		public function unmapExecutor(trigger:Object, executor:Object):void 
		{
			var _vClass:Vector.<CommandEntry>;
			if (undefined != _lutMessageTriggers[trigger])
			{
				_vClass = _lutMessageTriggers[trigger];
				for (var i:int = 0, i_max:int = _vClass.length; i < i_max; i++) 
				{
					if (_vClass[i].command == executor) 
					{
						_vClass.splice(i, 1);
						break;
					}
				}
				
				if (!_vClass.length)
				{
					delete _lutMessageTriggers[trigger];
				}
			}
		}
		
		public function unmapClass(payload:Class, executor:Class):void
		{
			unmapExecutor(payload, executor);
		}
		
		public function unmapFunction(payload:Class, executor:Function):void
		{
			unmapExecutor(payload, executor)
		}
		
		public function unmap(trigger:String, executor:Class):void 
		{
			unmapExecutor(trigger, executor);
			if (undefined == _lutMessageTriggers[trigger])
			{
				_dispatchTarget.removeEventListener(trigger, messageHandlerGrabber);
			}
		}
		
	}
}

internal class CommandEntry
{
	public var command:Object;
	public var priotity:int;
	/**
	 * 
	 * @param	command	function or class extends Command
	 * @param	priotity
	 */
	public function CommandEntry(command:Object, priotity:int = 0):void
	{
		this.priotity = priotity;
		this.command = command;
	}
	
	public static function sorter(A:CommandEntry, B:CommandEntry):int 
	{
		if (A.priotity > B.priotity) return -1;
		if (A.priotity < B.priotity) return 1;
		return 0;
	}
}