/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-09-27 13:34</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	[inline]
	public function getClass(object:*):Class 
	{
		if (!object) return null;
		var result:Class = object is Class ? object as Class: object.constructor;
		// object is string ID of class
		if (!result) result =  getDefinitionByName(getQualifiedClassName(object)) as Class;
		if (!result) trace("3:Can not to generate class of", object);
		return result;
	}

}