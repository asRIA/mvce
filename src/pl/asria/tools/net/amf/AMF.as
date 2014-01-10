package pl.asria.tools.net.amf
{
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.net.Responder;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import pl.asria.tools.debug.Debug;
	
	/**
	* ...
	* wywalic bledy dla calosci, jak zakonczy pobieranie to wywalac wszystko po kolei !ODSA"PKS A
	*/
	public class AMF 
	{
		public var gateway:AMFconection;
				
		private var succes:Function;
		private var fault:Function;
		private var progress:Function;
		private var _call:String;
		private var _parametrs:Array;
		private static var activeGateways:Dictionary = new Dictionary();
		private var path:String;
		//
		public static function addGateway(path:String):AMFconection
		{
			if (undefined == activeGateways[path]) activeGateways[path] = new AMFconection(path);
			return activeGateways[path] as AMFconection;
		}
		
		public function AMF(path:String, amfcall:String, succesHandler:Function, faultHandler:Function, progressHandler:Function, ...rest) 
		{
			if (path == "")
			{
				throw new Error("AMFPath is not set!", 300001);
			}
			this.path = path;
			_call = amfcall;
			succes = succesHandler;
			fault = faultHandler;
			_parametrs = rest;
			progress = progressHandler;
			
			if (path == "") faultHandlerResponder("No AMFPATH: set fault ");
			var responder:Responder = new Responder(succesHandlerResponder, faultHandlerResponder);
			if ((activeGateways[path] == undefined)||(activeGateways[path] == null))
			{
				gateway = new AMFconection(path);
				gateway.addEventListener(AsyncErrorEvent.ASYNC_ERROR, closeGateway);
				//gateway.addEventListener(Event.DEACTIVATE, deactiveGateway);
				//gateway.addEventListener(Event.ACTIVATE, activeGateway);
				gateway.addEventListener(Event.CLOSE, closeGateway);
				gateway.addEventListener(IOErrorEvent.IO_ERROR, closeGateway);
				gateway.addEventListener(SecurityErrorEvent.SECURITY_ERROR, closeGateway);
				activeGateways[path] = gateway;
			}
			else
			{
				gateway = activeGateways[path];
			}
			
			gateway.addEventListener(ProgressEvent.PROGRESS, progresResponser);
			gateway.addEventListener(NetStatusEvent.NET_STATUS, netStatusResp);
			
			var args:Array = [amfcall, responder];
			args = args.concat(rest);
			gateway.pendingCall(args);
		}
		
		private var pauseOn:int;
		private function deactiveGateway(e:Event):void
		{
			pauseOn = getTimer();
		}
		private function activeGateway(e:Event):void
		{
			trace("Active "+path+" after " + (getTimer() - pauseOn) + " ms.");
		}
		
		private function closeGateway(e:Event):void
		{
			trace("amf connection closed: "+e);
			activeGateways[path] = null;
			delete activeGateways[path];
		}
		private function remotingConnection(apath:String):NetConnection
		{
			trace("AMF: remotingConnection: " + apath);
			var resp:NetConnection = new NetConnection();
			resp.objectEncoding = ObjectEncoding.AMF3;
			if (apath != null)
			{
				resp.connect(apath);
			}
			return resp;
		}
		private function progresResponser(e:ProgressEvent):void
		{
			trace("" + e.bytesLoaded + "/" + e.bytesTotal);
			if (null != progress) progress(e.bytesTotal/e.bytesTotal);
		}
		private function succesHandlerResponder(_re:Object):void
		{
			(activeGateways[path] as AMFconection).reQueuee();
			trace("AMF: [" + _call.slice(_call.lastIndexOf(".")) + "] OK resp");
			trace(Debug.deepTraceObject(_re, 4));
			if (succes != null)
			{
				succes(_re);
			}
			clean();
		}
		private function netStatusResp(e:NetStatusEvent):void
		{
			trace('[netStatusResp]: '+e);
			faultHandlerResponder(e.info);
		}
		private function faultHandlerResponder(_error:*):void
		{
			(activeGateways[path] as AMFconection).reQueuee();
			trace(_call);
			trace(_parametrs);
			trace('[ServiceError] > ');
			
			for (var i:String in _error)
			{
				trace(i + ': ' + _error[i]);
			}
			if (null != fault)
			{
				fault(_error);
			}
		}
		private function clean():void
		{
			gateway.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, closeGateway);
			//gateway.removeEventListener(Event.DEACTIVATE, deactiveGateway);
			//gateway.removeEventListener(Event.ACTIVATE, activeGateway);
			gateway.removeEventListener(Event.CLOSE, closeGateway);
			gateway.removeEventListener(IOErrorEvent.IO_ERROR, closeGateway);
			gateway.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, closeGateway);
			gateway.removeEventListener(ProgressEvent.PROGRESS, progresResponser);
			gateway.removeEventListener(NetStatusEvent.NET_STATUS, netStatusResp);
		}
	}
}