/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2012-10-15 12:45</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{

	/**
	 * flash2cartesian - 
	 * @usage - 
	 * @version - 1.0
	 * @author - Piotr Paczkowski - kontakt@trzeci.eu
	 * @param	angle in degrees
	 * @return cartesian angle from flash angle
	 */
	public function flash2cartesian(angle:Number):Number
	{
		angle = Math.abs(angle - 180);
		angle %= 360;
		angle-= 90;
		if (angle < 0) angle += 360;
		return angle;
	}

}