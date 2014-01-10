/**
 * CHANGELOG:
 *
 * <ul>
 * <li><b>1.0</b> - 2013-07-11 17:02</li>
 *	<ul>
 *		<li>Create file</li>
 *	</ul>
 * </ul>
 * @author Piotr Paczkowski - kontakt@trzeci.eu
 */
package pl.asria.tools.data.secure
{
	public class sIntR extends sInt
	{
		protected var _lifespan:int;
		protected var _counter:int;
		
		/**
		 * sInt -
		 * @usage -
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function sIntR(val:int = 0, lifespan:int = 100000)
		{
			_lifespan = lifespan;
			_counter = _lifespan;
			super(val);
		}
		
		override public function get value():int
		{
			return _lock ^ _value;
		}
		
		override public function set value(value:int):void
		{
			if (--_counter == 0)
			{
				_lock = Math.random();
				_counter = _lifespan;
			}
			_value = value ^ _lock;
		}
	}

}