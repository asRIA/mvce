/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-05-13 11:16</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers 
{
	
	public class Operation 
	{
		protected var _args:Array;
		protected var _callback:Function;
	
		/**
		 * PendingOperation - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function Operation(callback:Function, ...args) 
		{
			_callback = callback;
			_args = args;
			
		}
		
		public function execute():*
		{
			var result:*;
			
			if (_args.length)
			{
				result =  _callback.apply(null, _args);
			}
			result = _callback();
			
			_args.length = 0;
			_args = null;
			_callback = null;
			
			return result;
		}
		
	}

}