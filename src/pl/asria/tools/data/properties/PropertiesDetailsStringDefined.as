/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-11-23 10:17</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.data.properties 
{
	
	public class PropertiesDetailsStringDefined extends PropertiesDetalis 
	{
		public var defaultValue:String;
		public var rowCount:int;
		public var dateProviderSourceID:String;
	
		/**
		 * PropertiesDetailsStringDefined - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function PropertiesDetailsStringDefined(dateProviderSourceID:String, rowCount:int, required:Boolean=true, defaultValue:String = null) 
		{
			super(required);
			this.defaultValue = defaultValue;
			this.rowCount = rowCount;
			this.dateProviderSourceID = dateProviderSourceID;
		}
		
		public override function process(owner:*, propertyPath:String):Boolean 
		{
			if (owner[propertyPath] == undefined && required) 
			{
				owner[propertyPath] = defaultValue;
				return true;
			}
			return false
		}
		
	}

}