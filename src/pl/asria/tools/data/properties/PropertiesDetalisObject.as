/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-11-14 17:55</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.data.properties 
{
	
	public class PropertiesDetalisObject extends PropertiesDetalis 
	{
		public var properties:Object;
	
		/**
		 * PropertiesDetalisObject - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 * @param	properties hashtable with all of intrested name of arguments with PropertiesDetails
		 * @param	required
		 */
		public function PropertiesDetalisObject(properties:Object, required:Boolean=false) 
		{
			super(required);
			this.properties = properties;
			
		}
		
		public override function process(owner:*, propertyPath:String):Boolean 
		{	
			var object:Object = owner[propertyPath];
			var isChange:Boolean = false;
			
			if (object == null && required)
			{
				owner[propertyPath] = object = { };
				isChange = true;
			}
			
			if (object)
			{
				for (var propertyName:String in properties) 
				{
					var propertyDetails:PropertiesDetalis = properties[propertyName];
					if (propertyDetails.process(object, propertyName))
					{
						isChange = true;
					}
				}
			}
			return isChange;
		}
		
	}

}