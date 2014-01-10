/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-01-02 14:00</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author ...
*/
package pl.asria.tools.utils 
{
	import flash.utils.Dictionary;
	import pl.asria.tools.utils.isBasedOn;
	
	public class DictUtils 
	{
	
		public static function retriveClassKey(source:Dictionary, superType:Class, includeInheritableClass:Boolean = false):Array
		{
			var result:Array = [];
			for (var type:Object in source) 
			{
				var typeClass:Class = type as Class;
				if (superType == typeClass || (includeInheritableClass && isBasedOn(typeClass, superType) && source[typeClass]))
				{
					result = result.concat(source[typeClass]);
				}
			}
			return result;
		}
		
	}

}