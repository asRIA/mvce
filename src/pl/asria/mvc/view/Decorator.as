/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-12-06 22:43</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.mvc.view 
{
	import pl.asria.mvc.interfaces.IComponentMVC;
	import pl.asria.mvc.ns_mvc;
	import pl.asria.mvc.MVCSystem;
	
	public class Decorator  implements IComponentMVC
	{
		ns_mvc var mSystem:MVCSystem;
		protected function get system():MVCSystem { return ns_mvc::mSystem; }
		
		/**
		 * Decorator - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function Decorator() 
		{
			
		}
		
	}

}