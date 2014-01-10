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
	import flash.utils.getQualifiedSuperclassName;

	public function getSuperClass(object:*):Class 
	{
		return getDefinitionByName(getQualifiedSuperclassName(object)) as Class;
	}

}