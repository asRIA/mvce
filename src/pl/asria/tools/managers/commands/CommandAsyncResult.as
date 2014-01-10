/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-09 19:55</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.managers.commands 
{
	import org.osflash.signals.Signal;
	
	public class CommandAsyncResult 
	{
		
		public var onStart:Signal = new Signal( );
		public var onComplete:Signal = new Signal( );
		public var onFail:Signal = new Signal( );
		
		public var description:*;
		public var result:*;
		/**
		 * CommandAsyncResult - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function CommandAsyncResult() 
		{
			
		}
		
	}

}