/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-05 12:44</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	import flash.utils.describeType;
	
	public function isBasedOn(subClass:Class, baseClass:Class):Boolean
	{
		var descriptionSubclass:XML = describeType(subClass);
		var descriptionBase:XML = describeType(baseClass);
		return descriptionSubclass.factory.extendsClass.(@type == String(descriptionBase.@name)).length() > 0;
	}

}