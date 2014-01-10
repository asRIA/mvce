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
	
	public class PropertiesDetalisInt extends PropertiesDetalis
	{
	
		public var defaultValue:int;
		public var step:int;
		public var max:int;
		public var min:int;
		
		/**
		 * PropertiesDetalisInt - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		public function PropertiesDetalisInt(defaultValue:int = 0, min:int = 0, max:int = 1000, step:int = 1, required:Boolean=true) 
		{
			super(required);
			this.step = step;
			this.max = max;
			this.min = min;
			this.defaultValue = defaultValue;
		}
		
		public override function process(owner:*, propertyPath:String):Boolean 
		{
			var changed:Boolean = false;
			var number:int;
			
			if (owner[propertyPath] == undefined && required) 
			{
				number = defaultValue;
				changed = true;
			}
			else
			{
				number = owner[propertyPath]
			}
			
			if (number < min) 
			{
				number = min; 
				changed = true;
			}
			if (number > max) 
			{
				number = max; 
				changed = true;
			}
			if (step > 0)
			{
				var times:int = number / step;
				var tmp:int = times * step;
				if (tmp != number)
				{
					number = tmp;
					changed = true;
				}
			}
			if (changed)
			{
				owner[propertyPath] = number;
			}
			return changed;
			
		}
		
	}

}