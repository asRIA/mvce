/**
* CHANGELOG:
*
* 2011-12-16 11:24: Create file
*/
package pl.asria.tools.math 
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class MathPoint extends Point
	{
		
		static public function angle(pointA:Point, pointB:Point, coordinates:Point = null):Number 
		{
			coordinates = coordinates || new Point();
			var _a:Point = pointA.subtract(coordinates);
			var _b:Point = pointB.subtract(coordinates);
			var _vA:Vector3D = new Vector3D(_a.x, _a.y);
			var _vB:Vector3D = new Vector3D(_b.x, _b.y);
			//var _angle:Number = Math.atan2(y, x);
			return Vector3D.angleBetween(_vA,_vB);
		}
		
		
	}

}