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
	
	public class PropertiesDetailsString extends PropertiesDetalis 
	{
		public static const RESTRICT_LOWCASES:String = "qazwsxedcrfvtgbyhnujmikolp"
		public static const RESTRICT_UPCASES:String = "QAZWSXEDCRFVTGBYHNUJMIKOLP"
		public static const RESTRICT_NUMBERS:String = "0123456789"
		public static const RESTRICT_INTERPUNCTION:String = ",.;";
		
		public var restrict:String;
		public var defaultValue:String;
		public var maxChars:int;
	
		/**
		 * PropertiesDetailsString - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function PropertiesDetailsString(maxChars:int = 0, defaultValue:String = "", restrict:String = null, required:Boolean=true) 
		{
			super(required);
			this.restrict = restrict;
			this.defaultValue = defaultValue;
			this.maxChars = maxChars;
		}
		
		public override function process(owner:*, propertyPath:String):Boolean 
		{
			/* TODO Just do it! */
			
			//var changed:Boolean = false;
			//var value:String = owner[propertyPath];
			//
			//if (restrict && restrict.length)
			//{
				//for (var i:int = 0, i_max:int = restrict.length; i < i_max; i++) 
				//{
					//var char:String = restrict.substr(i, 1);
					//if (value.indexOf(char) >= 0)
					//{
						//value.split(cha)
					//}
					//changed
					//
				//}
			//}
			return false
			
		}
		
	}

}