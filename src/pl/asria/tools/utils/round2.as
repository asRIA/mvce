/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-06-28 16:14</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	
	/**
	 * round2 - 
	 * @usage - 
	 * @version - 1.0
	 * @author - Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public function round2(value:Number, places:int = 4):Number {
		var rounder:int = Math.pow(10, places);
		
		return int(value * rounder) / rounder;
	}
	
}