/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-25 08:29</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.mvc.factory 
{
	import pl.asria.tools.data.AbstractClass;
	
	[Abstract(name = "create", type = "method")]
	/**Abstract pattern: [Abstract(name = "create", type="method")] */
	public dynamic class AbstractFactoryBuilder extends AbstractClass 
	{
		/**
		 * AbstractFactoryBuilder - this is virtual class pattern. 
		 * @usage - please to create 'create(...):* method in your subclass. 
		 * @param supportType MegaFactory according to this type inoke proper builder
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function AbstractFactoryBuilder() 
		{
			
		}
		
	}

}