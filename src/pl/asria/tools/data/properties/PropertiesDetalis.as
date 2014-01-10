/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-11-14 08:36</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.data.properties 
{
	public class PropertiesDetalis
	{
		public var description:String = "";
		public var required:Boolean = false;
		internal var _owner:*;
		
		/**
		 * PropertiesDetalis - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function PropertiesDetalis(required:Boolean = true) 
		{
			this.required = required;
		}
		
		public function validate(owner:*, propertyPath:String):Boolean 	{ throw new Error("Please type own class extands this, and override method") };
		public function process(owner:*, propertyPath:String):Boolean 	{ throw new Error("Please type own class extands this, and override method") };
		
		public function clone():*
		{
			return new PropertiesDetalis(required);
		}
		
		public function get owner():* 
		{
			return _owner;
		}
		public function addDescription(description:String):*
		{
			this.description = description;
			return this;
			
		}
	}

}