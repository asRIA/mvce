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
	 * @param	angle in radians
	 * @param	targetAngle in radians
	 * @return value in radians rotation system <-PI;PI>
	 */
	public function calcAngleOffset(angle:Number, targetAngle:Number):Number
	{
		var offset:Number = targetAngle - angle;
		var absOffset:Number = offset < 0 ? -offset : offset;
		const pi2:Number = Math.PI * 2;
		if (offset > Math.PI)
		{
			if (offset > pi2)
			{
				offset %= pi2;
			}
			
			if (offset > Math.PI) offset = pi2 - offset;
		}
		else if(offset < Math.PI)
		{
			if (offset < -pi2)
			{
				offset = -absOffset%pi2;
			}
			if (offset < Math.PI) offset += pi2;
		}
		//|| angleOffset < -Math.PI
		return offset;
	}

}