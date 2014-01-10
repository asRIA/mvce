package pl.asria.tools.net.amf
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	public class AMFconection extends NetConnection
	{
		private static const MAXCONNECTIONS:int = 1;
		private var timestamp:int;
		private var activeCall:int = 0;
		private var pendingCalls:Array = new Array();
		public function AMFconection(sURL:String) 
		{
			//trace("Set connection: " + sURL);
			objectEncoding = ObjectEncoding.AMF3;
			try
			{
				timestamp = getTimer();
				if (sURL) connect(sURL);
			}
			catch (err:Error)
			{
				trace("Nie ma polaczenia z bramą  AMF");
			}
			addEventListener(Event.CONNECT, 
				function():void { 
					trace("Connect with: " + sURL + " activated after: " + (getTimer() - timestamp)) 
					} 
					);
					
		}
		public function pendingCall(rest:Array):void
		{
			if (activeCall < MAXCONNECTIONS)
			{
				call.apply(this, rest);
				activeCall++;
			}
			else 
			{
				pendingCalls.push(rest);
			}
		}
		public function reQueuee():void
		{
			if (activeCall > 0) activeCall--;
			if (pendingCalls.length > 0)
			{
				pendingCall(pendingCalls.pop());
			}
		}
	}
	
}