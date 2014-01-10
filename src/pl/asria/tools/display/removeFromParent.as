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
package pl.asria.tools.display 
{
	import flash.display.DisplayObject;

	public function removeFromParent(object:DisplayObject):Boolean
	{
		if (object && object.parent)
		{
			object.parent.removeChild(object);
			return true;
		}
		return false
	}
}