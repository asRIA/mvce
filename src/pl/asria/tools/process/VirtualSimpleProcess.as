/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-07-25 15:31</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.process 
{
	import flash.utils.describeType;
	import pl.asria.tools.data.VirtualClass;
	
	public class VirtualSimpleProcess extends VirtualClass
	{
		protected var _inProcess:Boolean;
	
		/**
		 * SimpleProcess - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function VirtualSimpleProcess() 
		{
		
			
		}
		
		/**
		 * process function is responsible for main process start function
		 */
		[Virtual(prefix = "_")]
		protected final function __process():void
		{

		}
		
		/**
		 * Method to protect start process when it is already running
		 */
		protected function _startProcess():void 
		{
			if (_inProcess) throw new Error("Process is already running");
			_inProcess = true;
		}
		
		/**
		 * Method to protect start process when it is already running
		 */
		protected function _stopProcess():void 
		{
			_inProcess = false;
		}
		
		/**
		 * Main initialize function of 
		 */
		[Virtual(prefix = "_")]
		protected final function __init():void
		{
			
		}
		
		public function get inProcess():Boolean 
		{
			return _inProcess;
		}
	}

}