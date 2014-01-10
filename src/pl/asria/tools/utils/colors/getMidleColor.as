/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-01-23 13:30</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils.colors 
{
	
	/**
	 * getMidleColor - 
	 * @usage - 
	 * @version - 1.0
	 * @author - Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public function getMidleColor(start:uint, end:uint, progress:Number):uint
	{
		progress = progress<0 ? 0 : progress>1 ? 1 : progress;
		var result:uint;
		
		for (var i:int = 0; i < 4; i++) 
		{
			var currentColorStart:uint = (start >> i * 8) & 0xFF;
			var currentColorEnd:uint = (end >> i * 8) & 0xFF;
			var resultColor:int = currentColorStart +progress * (currentColorEnd - currentColorStart);
			resultColor = resultColor < 0 ? 0 : resultColor >=256 ? 256 :  resultColor;
			result += (resultColor << i * 8);
		}
		
		return result;
	}
	
}