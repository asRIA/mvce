/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-02-24 00:36</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.mvc.model 
{
	import org.osflash.signals.Signal;
	import pl.asria.mvc.interfaces.IComponentMVC;
	
	public class Model implements IComponentMVC
	{
		/**
		 * Model - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function Model() 
		{
			
		}
		public var signalChange:Signal;
		public var signalDestroy:Signal;
	}

}