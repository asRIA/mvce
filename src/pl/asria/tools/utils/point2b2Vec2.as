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
	 * point2b2Vec2 - 
	 * @usage - 
	 * @version - 1.0
	 * @author - Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public function point2b2Vec2(vec:Point, scale:Number = 1):b2Vec2
	{
		return new b2Vec2(vec.x * scale, vec.y * scale);
	}
	
}