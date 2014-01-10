/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-09 22:50</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.factory 
{
	import org.osflash.signals.Signal;
	import pl.asria.tools.data.ICleanable;
	import pl.asria.tools.managers.SEnterFrameJuggler;
	
	public class MegaFactoryResult implements ICleanable
	{
		public var description:Object;
		protected var _data:Object;
	
		public var onComplete:Signal = new Signal(MegaFactoryResult);
		public var onFail:Signal = new Signal(MegaFactoryResult);
		
		/**
		 * AsyncMegaFactoryResult - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function MegaFactoryResult() 
		{
			
		}
		
		[inline]
		public final function get isComplete():Boolean { return data != null; }
		
		public function get data():Object 
		{
			return _data;
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			if (onFail)
			{
				onFail.removeAll();
				onFail = null;
			}
			
			if (onComplete)
			{
				onComplete.removeAll();
				onComplete = null;
			}
			
			description = null;
			_data = null;
		}
		
		public function setData(object:Object):void 
		{
			_data = object;
			onComplete.dispatch(this);
		}
		
		public function setDataAsync(object:Object):void 
		{
			SEnterFrameJuggler.updateSignal.addOnce(function(delay:uint):void {
				setData(object);
			});
		}
		
	}

}