/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-02-14 11:00</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	
	/**
	 * ceilInt - return random value <0; lim);
	 * @usage - 
	 * @version - 1.0
	 * @author - Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public function ceilInt(num:Number):int
	{
		if (num < 0) return Math.floor(num);
		if (num > 0) return Math.ceil(num);
		return 0;
	}
}