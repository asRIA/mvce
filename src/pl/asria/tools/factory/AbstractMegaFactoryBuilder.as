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
package pl.asria.tools.factory 
{
	import pl.asria.tools.data.AbstractClass;
	import pl.asria.tools.data.ICleanable;
	
	[Abstract(name = "create", type = "method")]
	/**Abstract pattern: [Abstract(name = "create", type="method")] */
	public dynamic class AbstractMegaFactoryBuilder extends AbstractClass implements ICleanable
	{
		ns_factory var unregister:Boolean;
		ns_factory var cleanup:Boolean = true;
		ns_factory var factory:MegaFactory;
		private var cleaned:Boolean = false;
		
		/**
		 * AbstractMegaFactoryBuilder - this is virtual class pattern. 
		 * @usage - please to create 'create(...):* method in your subclass. 
		 * @param supportType MegaFactory according to this type inoke proper builder
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function AbstractMegaFactoryBuilder() 
		{
			
		}
		
		/* INTERFACE pl.asria.tools.data.ICleanable */
		
		public function clean():void 
		{
			ns_factory::factory = null;
			cleaned = true;
		}
		
		public function get factory():MegaFactory
		{
			return ns_factory::factory;
		}
		
		
		
		
	}

}