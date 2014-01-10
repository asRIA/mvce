/**
 * CHANGELOG:
 *
 * <ul>
 * <li><b>1.0</b> - 2012-04-13 10:38</li>
 *	<ul>
 *		<li>Create file</li>
 *	</ul>
 * </ul>
 * @author Piotr Paczkowski - kontakt@trzeci.eu
 */
package pl.asria.tools.utils
{
	
	public function sortXML(xml:XML, attributes:Array, options:uint = 0, copy:Boolean = false):XML
	{
		//store in array to sort on
		var xmlArray:Array = new Array();
		var item:XML;
		for each (item in xml.children())
		{
			var object:Object = { data:item };
			for each (var attribute:String in attributes) 
			{
				object[attribute] = item.attribute(attribute)
			}
			xmlArray.push(object);
		}
		
		//sort using the power of Array.sortOn()
		xmlArray.sortOn(attributes, options);
		
		//create a new XMLList with sorted XML
		var sortedXmlList:XMLList = new XMLList();
		var xmlObject:Object;
		for each (xmlObject in xmlArray)
		{
			sortedXmlList += xmlObject.data;
		}
		
		if (copy)
		{
			//don't modify original
			return xml.copy().setChildren(sortedXmlList);
		}
		else
		{
			//original modified
			return xml.setChildren(sortedXmlList);
		}
	}

}