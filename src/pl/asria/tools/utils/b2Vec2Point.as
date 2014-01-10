/**
* CHANGELOG:
*
* <ul>
* <li><b>1.0</b> - 2013-01-11 11:42</li>
*	<ul>
*		<li>Create file</li>
*	</ul>
* </ul>
* @author Piotr Paczkowski - kontakt@trzeci.eu
*/
package pl.asria.tools.utils 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.geom.Point;
	
	/**
	 * b2Vec2Point - 
	 * @usage - 
	 * @version - 1.0
	 * @author - Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public function b2Vec2Point(vec:b2Vec2, scale:Number = 1):Point
	{
		return new Point(vec.x * scale, vec.y * scale);
	}
	
}