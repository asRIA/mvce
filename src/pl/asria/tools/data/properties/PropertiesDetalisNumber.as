/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-11-14 09:48</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.data.properties 
{
	
	public class PropertiesDetalisNumber extends PropertiesDetalis 
	{
		public var defaultValue:Number;
		public var step:Number;
		public var max:Number;
		public var min:Number;
	
		/**
		 * PropertiesDetalisNumber - 
		 * @usage - 
		 * @version - 1.0
		 * @author - Piotr Paczkowski - kontakt@trzeci.eu
		 */
		
		public function PropertiesDetalisNumber(defaultValue:Number = 0, min:Number = 0, max:Number = 1, step:Number = 0.01, required:Boolean=true) 
		{
			super(required);
			this.defaultValue = defaultValue;
			this.step = step;
			this.max = max;
			this.min = min;
			
		}
		
		public override function process(owner:*, propertyPath:String):Boolean 
		{
			var changed:Boolean = false;
			var number:Number = owner[propertyPath];
			if (isNaN(number) && required)
			{
				number = owner[propertyPath] = defaultValue;
				changed = true;
			}
			
			if(!isNaN(number))
			{
				if (!isNaN(min) && number < min) 
				{
					number = min; 
					changed = true;
				}
				if (!isNaN(max) && number > max) 
				{
					number = max; 
					changed = true;
				}
				if (!isNaN(step) && step > 0)
				{
					var times:int = number / step;
					var tmp:Number = times * step;
					if (tmp != number)
					{
						number = tmp;
						changed = true;
					}
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