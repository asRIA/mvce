/**
 * CHANGELOG:
 *
 * 2011-11-10 08:33: Create file
 */
package pl.asria.tools.data
{	
	import flash.events.EventDispatcher;
	import pl.asria.tools.event.data.SimpleDataProviderEvent;
	
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	[Event(name="setData", type="pl.asria.tools.event.data.SimpleDataProviderEvent")]
	[Event(name="update", type="pl.asria.tools.event.data.SimpleDataProviderEvent")]
	[Event(name="clean", type="pl.asria.tools.event.data.SimpleDataProviderEvent")]
	
	public class SimpleDataProvider extends EventDispatcher
	{
		private var _data:*;
		
		public function SimpleDataProvider(data:* = null)
		{
			_data = data;
		}
		
		public function get data():* 
		{
			return _data;
		}
		
		public function set data(value:*):void 
		{
			if (value == null)
			{
				clean();
			}
			else if (_data != value)
			{
				_data = value;
				dispatchEvent(new SimpleDataProviderEvent(SimpleDataProviderEvent.SET_DATA));
				dispatchEvent(new SimpleDataProviderEvent(SimpleDataProviderEvent.UPDATE));
			}
		}
		
		/**
		 * Dispatch Event after this, please use this function after every modyfication data
		 */
		public function update():void
		{
			dispatchEvent(new SimpleDataProviderEvent(SimpleDataProviderEvent.UPDATE));
		}
		
		public function clean():void 
		{
			_data = null;
			dispatchEvent(new SimpleDataProviderEvent(SimpleDataProviderEvent.CLEAN));
		}
	
	}

}