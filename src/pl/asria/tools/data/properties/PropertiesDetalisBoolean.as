/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-11-14 08:39</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.data.properties 
{
	
	public class PropertiesDetalisBoolean extends PropertiesDetalis
	{
		public var defaultValue:Boolean;
		
		/**
		 * PropertiesDetalisBoolean - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function PropertiesDetalisBoolean(defaultValue:Boolean = false, required:Boolean=true) 
		{
			super(required);
			this.defaultValue = defaultValue;
		}
		
		override public function process(owner:*, propertyPath:String):Boolean 
		{
			var changed:Boolean;
			var value:Boolean;
			if (owner[propertyPath] == undefined && required)
			{
				value = defaultValue;
				changed = true;
			}
			
			return changed;
		}
	}

}