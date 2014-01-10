/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-06-13 17:01</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.data 
{
	
	public class IntBit 
	{
		protected var _range:uint;
		protected var _value:int;
	
		/**
		 * IntBit - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function IntBit(range:uint = 32) 
		{
			_range = range;
		}
		
		public function parse(value:int):void
		{
			_value = value;
		}
		
		public function setBit(id:uint):Boolean
		{
			if (id >= _range) throw new Error("Out of range: " + _range); 
			return (1 << id) & _value;
		}
		
		public function setBit(id:uint):void
		{
			if (id >= _range) throw new Error("Out of range: " + _range);
			_value |= (1 << id);
		}
		
		public function clearBit(id:uint):void
		{
			if (id >= _range) throw new Error("Out of range: " + _range);
			_value &= ~id;
		}
		
		public function get value():int 
		{
			return _value;
		}
		
		public function set value(value:int):void 
		{
			_value = value;
		}
		
	}

}