/**
* CHANGELOG:
*
* <ul>
* <li><b>1.1</b> - 2013-01-24 23:48</li>
*	<ul>
*		<li>add required method _preparationData </li>
*	</ul>
* <li><b>1.0</b> - 2012-08-07 11:30</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.net.command 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Timer;
	
	/** 
	* Dispatched when call is out of time, _preparationData is not called
	**/
	[Event(name="commandTimeout", type="pl.asria.tools.net.command.ServerCommandEvent")]
	/** 
	* Dispatched when call is successfull, data should be handled and preparated by _preparationData 
	**/
	[Event(name="comandComplete", type="pl.asria.tools.net.command.ServerCommandEvent")]
	public class ServerCommand extends EventDispatcher
	{
		//private var _data:*;
		/** state after launch server command **/
		public static const STATE_IN_PROGRESS:String = "stateInProgress";
		/** state after clean data **/
		public static const STATE_CLEAN:String = "stateClean";
		/** State on the beggining before first call**/
		public static const STATE_NOT_INITED:String = "stateNotInited";
		/** state after timeout **/
		public static const STATE_TIMEOUT:String = "stateTimeout";
		/** state after complete call command in time limitation **/
		public static const STATE_COMPLETE:String = "stateComplete";
		
		
		protected var _url:String;
		protected var _timeout:int;
		protected var _watchdog:Timer;
		protected var _urlloader:URLLoader;
		protected var _urlRequest:URLRequest;
		protected var _state:String = STATE_NOT_INITED;
		protected var _cleanLog:String;
	
		/**
		 * ServerCommand - Simple class to manement server calls
		 * @usage - 
		 * @version - 1.0
		 * @param	url	From ConnectionSettings
		 * @param	timeout time limitation in [ms]
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function ServerCommand(url:String, timeout:int = 10000) 
		{
			_timeout = timeout;
			_url = url;
			_intiURLLoader();
			_intiURLRequest();
		}
		
		protected function _intiURLRequest():void 
		{
			_urlRequest = new URLRequest(_url);
			_urlRequest.method = URLRequestMethod.POST;
		}
		
		protected function _intiURLLoader():void 
		{
			_urlloader = new URLLoader();
		}
		
		protected function __remURLLListeners():void
		{
			_urlloader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_urlloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_urlloader.removeEventListener(Event.COMPLETE, _completeURLLHandler);
		}
		protected function __addURLLListeners():void
		{
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_urlloader.addEventListener(Event.COMPLETE, _completeURLLHandler);
		}
		
		protected function ioErrorHandler(e:IOErrorEvent):void 
		{
			//trace( "5:ServerCommand.ioErrorHandler", e);
			trace( "5:fail", _urlRequest.url);
		}
		
		protected function securityErrorHandler(e:SecurityErrorEvent):void 
		{
			trace( "5:ServerCommand.securityErrorHandler", e);
		}
		
		protected function _completeURLLHandler(e:Event):void 
		{
			_clearWatchodg();
			_state = STATE_COMPLETE;
			__remURLLListeners();
			//trace( "0:ServerCommand._completeURLLHandler");
			_dataProcess(_urlloader.data);
			dispatchEvent(new ServerCommandEvent(ServerCommandEvent.COMAND_COMPLETE));
		}
		
		protected function _dataProcess(data:*):void 
		{
			//_data = data;
			throw new Error("Data have to be processed");
		}
		
		/**
		 * Call server command
		 * @param	postData	Object, witch values according to documentation
		 */
		public function call(postData:Object):ServerCommand
		{
			if (_state == STATE_IN_PROGRESS) throw new Error("Can not to launch already processed call");
			if (_state == STATE_CLEAN) throw new Error("Can not to launch clanded command");
			_initWatchodg();
			_state = STATE_IN_PROGRESS;
			if (postData) _urlRequest.data = _dataPreparation(postData);
			_urlloader.load(_urlRequest);
			__addURLLListeners();
			return this;
		}
		
		/**
		 * preparation data before call urlRequest. This function do not modify original data
		 * @param	data
		 * @return	preparated data to call
		 */
		protected function _dataPreparation(data:Object):Object 
		{
			throw new Error("Data have to be preparated");
			return data;
		}
		
		/**
		 * this call works only after timeout, or after succesfull call
		 */
		public function retry():ServerCommand
		{
			if (_state == STATE_TIMEOUT || _state == STATE_COMPLETE)
			{
				_urlloader.load(_urlRequest);
				_initWatchodg();
				__addURLLListeners();
			}
			return this;
		}
		
		protected final function _initWatchodg():void
		{
			_watchdog = new Timer(_timeout, 1);
			_watchdog.start();
			_watchdog.addEventListener(TimerEvent.TIMER_COMPLETE, _completeWatchodgHandler)
		}
		
		protected final function _completeWatchodgHandler(e:TimerEvent):void 
		{
			_watchdog.removeEventListener(TimerEvent.TIMER_COMPLETE, _completeWatchodgHandler)
			_watchdog = null;
			_onTimeout();
		}
		
		protected final function _clearWatchodg():void
		{
			_watchdog.stop();
			_watchdog.removeEventListener(TimerEvent.TIMER_COMPLETE, _completeWatchodgHandler)
			_watchdog = null;
		}
		
		protected function _onTimeout():void
		{
			_state = STATE_TIMEOUT;
			__remURLLListeners();
			_urlloader.close();
			trace("2:Connection timeout : ", _url);
			dispatchEvent(new ServerCommandEvent(ServerCommandEvent.COMMAND_TIMEOUT));
		}
		
		/**
		 * Clean all data and internal listenere. Clean also data:ByteArray
		 */
		public function clean():void
		{
			CONFIG::debug
			{
				_cleanLog = new Error().getStackTrace();
			}
			
			if (_state  == STATE_IN_PROGRESS) 
			{
				__remURLLListeners();
				_clearWatchodg();
			}
			_state = STATE_CLEAN;
			_urlloader = null;
			_urlRequest = null;
		}

		
		public function get state():String 
		{
			return _state;
		}
		
	}

}