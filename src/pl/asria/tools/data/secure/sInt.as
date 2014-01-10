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
	public class sInt 
	{
		/**  **/
		protected var _value:int;
		protected var _lock:int;
		
		/**
		 * sInt - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function sInt(val:int = 0) 
		{
			_lock = Math.random() * int.MAX_VALUE;
			value = val;
		}
		
		public function get value():int 
		{
			return _lock ^ _value;
		}
		
		public function set value(value:int):void 
		{
			_value = value ^ _lock;
		}
	}

}