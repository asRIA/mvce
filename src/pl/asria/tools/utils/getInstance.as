/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-07-09 23:44</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	import flash.utils.getDefinitionByName;
	
	/**
	 * getInstance - 
	 * @usage - 
	 * @version - 1.0
	 * @author - Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public function getInstance(className:String):*{
		var bodyClass:Class;
		try {
			bodyClass = getDefinitionByName(className) as Class;
		}
		catch (e:Error){}
			
		if (!bodyClass) 
		{
			trace("Factory: not defined:", className,"class");
			return null;
		}
		var instance:Object;
		if (bodyClass)
		{
			try
			{
				instance = new bodyClass() as Object;
			}
			catch (e:Error) { }
		}
		
		return instance;
	}
	
}