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
	 * toDisplayRotation - 
	 * @usage - 
	 * @version - 1.0
	 * @author - Piotr Paczkowski - kontakt@trzeci.eu
	 * @param	angle in degrees
	 * @return value in display rotation system <-180;180>
	 */
	public function toDisplayRotation(angle:Number):Number
	{
		if (angle > 360 || angle < -360) angle = angle - int(angle / 360) * 360;
		if (angle > 180) angle = angle -360;
		if (angle < -180) angle = angle + 360;
		return angle;
	}

}